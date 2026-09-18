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
