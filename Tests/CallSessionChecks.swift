import Foundation
import Testing
@testable import Roasted

struct CallSessionChecks {
    @MainActor @Test func sampleLifecycleAndEvidenceIsolation() {
        let session = CallSession(configuration: nil)
        session.accept()
        #expect(session.phase == .home)
        session.ring()
        session.decline()
        #expect(session.phase == .home)
        session.ring()
        session.accept()
        session.accept()
        #expect(session.messages.count == 1)
        session.end()
        #expect(session.receipt?.signals.isEmpty == true)
        session.goHome()
        session.ring()
        session.accept()
        session.advanceMock()
        session.end()
        #expect(session.receipt?.signals.first?.improvementObserved == false)
        session.goHome()
        session.ring()
        session.accept()
        session.advanceMock()
        session.advanceMock()
        session.end()
        #expect(session.receipt?.isMock == true)
        #expect(session.savedReceipts.isEmpty)
        session.goHome()
        #expect(session.messages.isEmpty && !session.isMuted)
    }
}

@Suite(.serialized)
struct DemoBackendSaveRecoveryChecks {
    private let sessionID = "8EE186CB-3144-49E3-B0D1-C08F5BD83646"

    @MainActor @Test func lostPostAcknowledgementMatchesUppercaseRequestToLowercaseSavedUUID() async throws {
        let memory = try memoryPayload(receiptID: sessionID.lowercased())
        SaveRecoveryURLProtocol.state.configure(post: .transport(.networkConnectionLost), memory: .http(200, memory))
        let (backend, session) = makeBackend()
        defer { session.invalidateAndCancel() }

        let result = try await save(using: backend)

        #expect(result.receipt.id == sessionID.lowercased())
        #expect(result.memory.first?.signal == "Spend time on")
        #expect(result.warnings == nil)
        #expect(SaveRecoveryURLProtocol.state.requests == ["POST /sessions", "GET /memory"])
    }

    @MainActor @Test func unrelatedReceiptDoesNotHideTheOriginalSaveFailure() async throws {
        let memory = try memoryPayload(receiptID: "90ef2e61-a0d7-4f46-8ef1-3a60262d0a01")
        SaveRecoveryURLProtocol.state.configure(post: .transport(.networkConnectionLost), memory: .http(200, memory))
        let (backend, session) = makeBackend()
        defer { session.invalidateAndCancel() }

        do {
            _ = try await save(using: backend)
            Issue.record("An unrelated receipt must not turn a failed save into success.")
        } catch let error as URLError {
            #expect(error.code == .networkConnectionLost)
        }
        #expect(SaveRecoveryURLProtocol.state.requests == ["POST /sessions", "GET /memory"])
    }

    @MainActor @Test func validationRejectionDoesNotReadMemoryOrRetryThePost() async throws {
        SaveRecoveryURLProtocol.state.configure(
            post: .http(422, Data(#"{"error":"Learning evidence did not match."}"#.utf8)),
            memory: .http(200, try memoryPayload(receiptID: sessionID)))
        let (backend, session) = makeBackend()
        defer { session.invalidateAndCancel() }

        do {
            _ = try await save(using: backend)
            Issue.record("A validation rejection must remain a failure.")
        } catch let error as DemoBackendError {
            guard case let .requestFailed(status, reason) = error else {
                Issue.record("Expected the original HTTP validation error.")
                return
            }
            #expect(status == 422)
            #expect(reason == "Learning evidence did not match.")
        }
        #expect(SaveRecoveryURLProtocol.state.requests == ["POST /sessions"])
    }

    @MainActor private func makeBackend() -> (DemoBackend, URLSession) {
        let settings = URLSessionConfiguration.ephemeral
        settings.protocolClasses = [SaveRecoveryURLProtocol.self]
        let session = URLSession(configuration: settings)
        let configuration = DemoConfiguration(baseURL: URL(string: "https://save-recovery.invalid")!,
                                              token: "fake-test-token", certificate: Data())
        return (DemoBackend(configuration: configuration, session: session), session)
    }

    @MainActor private func save(using backend: DemoBackend) async throws -> SaveResponse {
        try await backend.save(id: sessionID, createdAt: "2026-09-18T22:00:00Z", topic: "Synthetic save recovery",
                               transcript: [ConversationLine(id: "user-1", speaker: "You", text: "A synthetic utterance.")],
                               candidates: [])
    }

    private func memoryPayload(receiptID: String) throws -> Data {
        try JSONSerialization.data(withJSONObject: [
            "receipts": [["id": receiptID, "createdAt": "2026-09-18T22:00:00Z", "topic": "Synthetic save recovery",
                          "signals": [], "usefulExpression": "", "culturalTakeaway": "", "isMock": true]],
            "memory": [["kind": "grammar", "signal": "Spend time on", "originalQuote": "spend time for",
                        "nativeAlternative": "spend time on", "retryQuote": "spend time on", "improvementObserved": true]],
        ])
    }
}

private final class SaveRecoveryURLProtocol: URLProtocol, @unchecked Sendable {
    enum Outcome: Sendable {
        case transport(URLError.Code)
        case http(Int, Data)
    }

    // URLProtocol invokes callbacks off the test actor; all shared state is lock protected.
    final class State: @unchecked Sendable {
        private let lock = NSLock()
        private var post: Outcome = .transport(.networkConnectionLost)
        private var memory: Outcome = .transport(.cannotConnectToHost)
        private var recorded: [String] = []

        var requests: [String] { lock.withLock { recorded } }

        func configure(post: Outcome, memory: Outcome) {
            lock.withLock {
                self.post = post
                self.memory = memory
                recorded = []
            }
        }

        func response(for request: URLRequest) -> Outcome {
            lock.withLock {
                let route = "\(request.httpMethod ?? "GET") \(request.url?.path ?? "")"
                recorded.append(route)
                switch route {
                case "POST /sessions": return post
                case "GET /memory": return memory
                default: return .http(404, Data())
                }
            }
        }
    }

    static let state = State()
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        switch Self.state.response(for: request) {
        case let .transport(code):
            client?.urlProtocol(self, didFailWithError: URLError(code))
        case let .http(status, data):
            let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    override func stopLoading() {}
}
