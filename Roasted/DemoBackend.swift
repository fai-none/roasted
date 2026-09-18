import Foundation
import Security

struct DemoConfiguration {
    let baseURL: URL
    let token: String
    let certificate: Data

    static func load() -> DemoConfiguration? {
        let env = ProcessInfo.processInfo.environment
        let defaults = UserDefaults.standard
        if let address = env["ROASTED_SERVER_URL"], let url = URL(string: address),
           url.scheme == "https", let token = env["ROASTED_DEMO_TOKEN"], !token.isEmpty,
           let encoded = env["ROASTED_SERVER_CERT"], let certificate = Data(base64Encoded: encoded) {
            defaults.set(address, forKey: "demo.serverURL")
            defaults.set(certificate, forKey: "demo.serverCertificate")
            DemoKeychain.save(token)
            return DemoConfiguration(baseURL: url, token: token, certificate: certificate)
        }
        guard let address = defaults.string(forKey: "demo.serverURL"),
              let url = URL(string: address), url.scheme == "https",
              let certificate = defaults.data(forKey: "demo.serverCertificate"),
              let token = DemoKeychain.read(), !token.isEmpty else { return nil }
        return DemoConfiguration(baseURL: url, token: token, certificate: certificate)
    }
}

private enum DemoKeychain {
    static var query: [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: "dev.roasted.demo.backend",
         kSecAttrAccount as String: "demo-access"]
    }
    static func save(_ token: String) {
        let value = Data(token.utf8)
        if SecItemUpdate(query as CFDictionary, [kSecValueData as String: value] as CFDictionary) == errSecItemNotFound {
            var item = query
            item[kSecValueData as String] = value
            item[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            SecItemAdd(item as CFDictionary, nil)
        }
    }
    static func read() -> String? {
        var item = query
        item[kSecReturnData as String] = true
        item[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: CFTypeRef?
        guard SecItemCopyMatching(item as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

private final class DemoTLSDelegate: NSObject, URLSessionDelegate, @unchecked Sendable {
    let certificate: Data
    init(certificate: Data) { self.certificate = certificate }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let trust = challenge.protectionSpace.serverTrust,
              let anchor = SecCertificateCreateWithData(nil, certificate as CFData),
              let chain = SecTrustCopyCertificateChain(trust) as? [SecCertificate],
              let leaf = chain.first,
              SecCertificateCopyData(leaf) as Data == certificate else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        SecTrustSetAnchorCertificates(trust, [anchor] as CFArray)
        SecTrustSetAnchorCertificatesOnly(trust, true)
        guard SecTrustEvaluateWithError(trust, nil) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        completionHandler(.useCredential, URLCredential(trust: trust))
    }
}

struct LearnerMemory: Codable {
    let kind: String
    let signal: String
    let originalQuote: String
    let nativeAlternative: String
    let retryQuote: String
    let improvementObserved: Bool
    let updatedAt: String?
}

struct MemoryResponse: Decodable {
    let memory: [LearnerMemory]
    let receipts: [LearningReceipt]
}

struct SaveResponse: Decodable {
    let receipt: LearningReceipt
    let memory: [LearnerMemory]
    let warnings: [String]?
}

struct SessionBootstrap {
    let secret: String
    let instructions: String
    let tools: [[String: Any]]
    let memory: [LearnerMemory]
    let receipts: [LearningReceipt]
}

enum DemoBackendError: LocalizedError {
    case message(String)
    case requestFailed(status: Int, reason: String)
    var errorDescription: String? {
        switch self {
        case let .message(message): message
        case let .requestFailed(status, reason): "Demo backend HTTP \(status): \(reason)"
        }
    }
}

@MainActor final class DemoBackend {
    let configuration: DemoConfiguration
    private let session: URLSession
    init(configuration: DemoConfiguration, session: URLSession? = nil) {
        self.configuration = configuration
        if let session {
            self.session = session
            return
        }
        let settings = URLSessionConfiguration.ephemeral
        settings.timeoutIntervalForRequest = 20
        settings.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: settings, delegate: DemoTLSDelegate(certificate: configuration.certificate), delegateQueue: nil)
    }

    func memory() async throws -> MemoryResponse {
        try JSONDecoder().decode(MemoryResponse.self, from: await request("memory"))
    }

    func start() async throws -> SessionBootstrap {
        let data = try await request("session", body: [:])
        guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let secret = object["secret"] as? String,
              let instructions = object["instructions"] as? String,
              let tools = object["tools"] as? [[String: Any]] else {
            throw DemoBackendError.message("The demo backend returned an incomplete call configuration.")
        }
        let memory = try JSONDecoder().decode(MemoryResponse.self, from: data)
        return SessionBootstrap(secret: secret, instructions: instructions, tools: tools, memory: memory.memory, receipts: memory.receipts)
    }

    func save(id: String, createdAt: String, topic: String, transcript: [ConversationLine], candidates: [[String: Any]]) async throws -> SaveResponse {
        let body: [String: Any] = ["id": id, "createdAt": createdAt, "topic": topic,
            "transcript": transcript.map { ["id": $0.id, "speaker": $0.speaker, "text": $0.text] },
            "candidates": candidates]
        do {
            return try JSONDecoder().decode(SaveResponse.self, from: await request("sessions", body: body))
        } catch {
            let saveError = error
            guard !Task.isCancelled else { throw saveError }
            if case let DemoBackendError.requestFailed(status, _) = saveError, (400..<500).contains(status) {
                throw saveError
            }
            // The transaction may have committed even when its response was lost.
            // Confirm this exact call with a fresh read; never invent a receipt or
            // submit a second session to make an uncertain save look successful.
            if let saved = try? await memory(),
               let receipt = saved.receipts.first(where: { $0.id == id }) {
                return SaveResponse(receipt: receipt, memory: saved.memory, warnings: nil)
            }
            throw saveError
        }
    }

    private func request(_ path: String, body: [String: Any]? = nil) async throws -> Data {
        var request = URLRequest(url: configuration.baseURL.appendingPathComponent(path))
        request.setValue("Bearer \(configuration.token)", forHTTPHeaderField: "Authorization")
        if let body {
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            // This pinned local broker exposes only sanitized fixed error messages.
            let body = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let reason = (body?["error"] as? String).map { String($0.prefix(300)) } ?? "Check the Mac backend and provider setup."
            throw DemoBackendError.requestFailed(status: status, reason: reason)
        }
        return data
    }
}
