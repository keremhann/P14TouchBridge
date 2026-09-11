import Foundation
import GameController
import UIKit

@MainActor
final class InputMonitor: ObservableObject {
    @Published var mouseConnected = false
    @Published var deltaX: Double = 0
    @Published var deltaY: Double = 0
    @Published var leftPressed = false
    @Published var scrollX: Double = 0
    @Published var scrollY: Double = 0

    @Published var hoverX: Double = 0
    @Published var hoverY: Double = 0
    @Published var touchX: Double = 0
    @Published var touchY: Double = 0
    @Published var touchState = "-"
    @Published var eventCount = 0

    @Published var pseudoTapCount = 0
    @Published var pseudoTapX: Double = 0
    @Published var pseudoTapY: Double = 0
    @Published var detectorState = "BEKLİYOR"

    private var settleTask: Task<Void, Never>?
    private var lastPoint = CGPoint.zero
    private var motionStarted = false

    init() {
        NotificationCenter.default.addObserver(
            forName: .GCMouseDidConnect, object: nil, queue: .main
        ) { [weak self] _ in
            Task { @MainActor in self?.attachMouse() }
        }
        NotificationCenter.default.addObserver(
            forName: .GCMouseDidDisconnect, object: nil, queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.mouseConnected = false
            }
        }
        attachMouse()
    }

    private func attachMouse() {
        guard let mouse = GCMouse.current else {
            mouseConnected = false
            return
        }
        mouseConnected = true

        mouse.mouseInput?.mouseMovedHandler = { [weak self] _, dx, dy in
            Task { @MainActor in
                self?.deltaX = Double(dx)
                self?.deltaY = Double(dy)
            }
        }

        mouse.mouseInput?.leftButton.pressedChangedHandler = { [weak self] _, _, pressed in
            Task { @MainActor in self?.leftPressed = pressed }
        }

        mouse.mouseInput?.scroll.valueChangedHandler = { [weak self] _, x, y in
            Task { @MainActor in
                self?.scrollX = Double(x)
                self?.scrollY = Double(y)
            }
        }
    }

    func setHover(_ p: CGPoint) {
        hoverX = p.x
        hoverY = p.y
        eventCount += 1
        feedMotion(p)
    }

    func setTouch(_ p: CGPoint, state: String) {
        touchX = p.x
        touchY = p.y
        touchState = state
        eventCount += 1
        feedMotion(p)
    }

    private func feedMotion(_ p: CGPoint) {
        let d = hypot(p.x - lastPoint.x, p.y - lastPoint.y)
        lastPoint = p

        guard d > 0.5 else { return }
        motionStarted = true
        detectorState = "HAREKET"

        settleTask?.cancel()
        settleTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(220))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                guard let self, self.motionStarted else { return }
                self.pseudoTapCount += 1
                self.pseudoTapX = p.x
                self.pseudoTapY = p.y
                self.detectorState = "TAP ÜRETİLDİ"
                self.motionStarted = false
            }
        }
    }

    func clear() {
        deltaX = 0; deltaY = 0
        scrollX = 0; scrollY = 0
        hoverX = 0; hoverY = 0
        touchX = 0; touchY = 0
        touchState = "-"
        eventCount = 0
        pseudoTapCount = 0
        pseudoTapX = 0; pseudoTapY = 0
        detectorState = "BEKLİYOR"
        motionStarted = false
        settleTask?.cancel()
    }
}
