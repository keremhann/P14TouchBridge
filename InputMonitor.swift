import Foundation
import UIKit

@MainActor
final class InputMonitor: ObservableObject {
    @Published var tapCount = 0
    @Published var doubleTapCount = 0
    @Published var longPressCount = 0
    @Published var dragCount = 0
    @Published var swipeCount = 0
    @Published var x: Double = 0
    @Published var y: Double = 0
    @Published var state = "HAZIR"

    private var lastPoint: CGPoint?
    private var startPoint: CGPoint?
    private var startTime: Date?
    private var lastEventTime = Date.distantPast
    private var settleTask: Task<Void, Never>?
    private var lastTapTime = Date.distantPast
    private var totalDistance: CGFloat = 0

    func point(_ p: CGPoint) {
        x = p.x; y = p.y
        let now = Date()

        if now.timeIntervalSince(lastEventTime) > 0.28 || startPoint == nil {
            startPoint = p
            lastPoint = p
            startTime = now
            totalDistance = 0
            state = "TEMAS"
        } else if let lp = lastPoint {
            totalDistance += hypot(p.x-lp.x, p.y-lp.y)
            lastPoint = p
            state = totalDistance > 45 ? "SÜRÜKLEME" : "TEMAS"
        }
        lastEventTime = now

        settleTask?.cancel()
        settleTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(230))
            guard !Task.isCancelled else { return }
            await MainActor.run { self?.finish(at: p) }
        }
    }

    private func finish(at p: CGPoint) {
        guard let started = startTime else { return }
        let duration = Date().timeIntervalSince(started)
        let d = totalDistance

        if d < 28 {
            if duration >= 0.75 {
                longPressCount += 1
                state = "UZUN BASMA"
            } else if Date().timeIntervalSince(lastTapTime) < 0.48 {
                doubleTapCount += 1
                state = "ÇİFT DOKUNMA"
                lastTapTime = .distantPast
            } else {
                tapCount += 1
                state = "DOKUNMA"
                lastTapTime = Date()
            }
        } else if d > 160 && duration < 0.9 {
            swipeCount += 1
            state = "KAYDIRMA"
        } else {
            dragCount += 1
            state = "SÜRÜKLEME"
        }

        startPoint = nil
        lastPoint = nil
        startTime = nil
        totalDistance = 0
    }

    func reset() {
        tapCount=0; doubleTapCount=0; longPressCount=0; dragCount=0; swipeCount=0
        x=0; y=0; state="HAZIR"
        startPoint=nil; lastPoint=nil; startTime=nil; totalDistance=0
        settleTask?.cancel()
    }
}
