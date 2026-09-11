import Foundation
import GameController
import UIKit
import Combine

@MainActor
final class InputMonitor: ObservableObject {
    @Published var mouseConnected = false
    @Published var deltaX: Double = 0
    @Published var deltaY: Double = 0
    @Published var scrollX: Double = 0
    @Published var scrollY: Double = 0
    @Published var leftPressed = false
    @Published var hoverX: Double = 0
    @Published var hoverY: Double = 0
    @Published var touchX: Double = 0
    @Published var touchY: Double = 0
    @Published var touchState = "Yok"
    @Published var eventCount = 0

    private var observers: [NSObjectProtocol] = []

    init() {
        observers.append(
            NotificationCenter.default.addObserver(
                forName: .GCMouseDidBecomeCurrent,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                Task { @MainActor in self?.attachCurrentMouse() }
            }
        )

        observers.append(
            NotificationCenter.default.addObserver(
                forName: .GCMouseDidStopBeingCurrent,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                Task { @MainActor in self?.mouseConnected = false }
            }
        )

        attachCurrentMouse()
    }

    deinit {
        for o in observers { NotificationCenter.default.removeObserver(o) }
    }

    func attachCurrentMouse() {
        guard let mouse = GCMouse.current, let input = mouse.mouseInput else {
            mouseConnected = false
            return
        }

        mouseConnected = true

        input.mouseMovedHandler = { [weak self] _, dx, dy in
            Task { @MainActor in
                self?.deltaX = Double(dx)
                self?.deltaY = Double(dy)
                self?.eventCount += 1
            }
        }

        input.leftButton.pressedChangedHandler = { [weak self] _, _, pressed in
            Task { @MainActor in
                self?.leftPressed = pressed
                self?.eventCount += 1
            }
        }

        input.scroll.valueChangedHandler = { [weak self] _, x, y in
            Task { @MainActor in
                self?.scrollX = Double(x)
                self?.scrollY = Double(y)
                self?.eventCount += 1
            }
        }
    }

    func setHover(_ point: CGPoint) {
        hoverX = point.x
        hoverY = point.y
        eventCount += 1
    }

    func setTouch(_ point: CGPoint, state: String) {
        touchX = point.x
        touchY = point.y
        touchState = state
        eventCount += 1
    }

    func clear() {
        deltaX = 0; deltaY = 0
        scrollX = 0; scrollY = 0
        hoverX = 0; hoverY = 0
        touchX = 0; touchY = 0
        touchState = "Yok"
        eventCount = 0
    }
}
