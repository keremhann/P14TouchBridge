import Foundation
import GameController
import UIKit

@MainActor
final class InputMonitor: ObservableObject {
    @Published var pseudoTapCount = 0
    @Published var pseudoDragCount = 0
    @Published var pseudoTapX: Double = 0
    @Published var pseudoTapY: Double = 0
    @Published var detectorState = "BEKLİYOR"
    @Published var gestureDistance: Double = 0
    @Published var gestureDurationMs: Double = 0

    private var settleTask: Task<Void, Never>?
    private var gestureStartPoint: CGPoint?
    private var lastPoint = CGPoint.zero
    private var gestureStartTime: ContinuousClock.Instant?
    private var totalDistance: CGFloat = 0
    private var gestureActive = false

    func feedPoint(_ p: CGPoint) {
        if !gestureActive {
            gestureActive = true
            gestureStartPoint = p
            lastPoint = p
            gestureStartTime = .now
            totalDistance = 0
            detectorState = "HAREKET"
        } else {
            let d = hypot(p.x - lastPoint.x, p.y - lastPoint.y)
            if d > 0.3 {
                totalDistance += d
                lastPoint = p
                detectorState = "HAREKET"
            }
        }

        settleTask?.cancel()
        settleTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(180))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                self?.finishGesture(at: p)
            }
        }
    }

    private func finishGesture(at p: CGPoint) {
        guard gestureActive else { return }

        let duration: Double
        if let start = gestureStartTime {
            duration = Double(start.duration(to: .now).components.attoseconds) / 1e15
        } else {
            duration = 0
        }

        gestureDistance = Double(totalDistance)
        gestureDurationMs = duration

        // Kısa mesafeli hareket = TAP adayı, uzun hareket = DRAG adayı.
        if totalDistance <= 35 {
            pseudoTapCount += 1
            pseudoTapX = p.x
            pseudoTapY = p.y
            detectorState = "TAP"
        } else {
            pseudoDragCount += 1
            detectorState = "DRAG"
        }

        gestureActive = false
        gestureStartPoint = nil
        gestureStartTime = nil
        totalDistance = 0
    }

    func clear() {
        pseudoTapCount = 0
        pseudoDragCount = 0
        pseudoTapX = 0
        pseudoTapY = 0
        detectorState = "BEKLİYOR"
        gestureDistance = 0
        gestureDurationMs = 0
        gestureActive = false
        settleTask?.cancel()
    }
}
