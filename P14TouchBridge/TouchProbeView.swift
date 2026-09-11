import SwiftUI
import UIKit

struct TouchProbeView: UIViewRepresentable {
    @ObservedObject var monitor: InputMonitor

    func makeCoordinator() -> Coordinator {
        Coordinator(monitor: monitor)
    }

    func makeUIView(context: Context) -> ProbeUIView {
        let view = ProbeUIView()
        view.backgroundColor = .clear
        view.isMultipleTouchEnabled = true
        view.monitor = monitor

        let hover = UIHoverGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.hoverChanged(_:))
        )
        view.addGestureRecognizer(hover)

        let pointer = UIPointerInteraction(delegate: context.coordinator)
        view.addInteraction(pointer)
        context.coordinator.hostView = view
        return view
    }

    func updateUIView(_ uiView: ProbeUIView, context: Context) {}

    final class Coordinator: NSObject, UIPointerInteractionDelegate {
        let monitor: InputMonitor
        weak var hostView: UIView?

        init(monitor: InputMonitor) {
            self.monitor = monitor
        }

        @objc func hoverChanged(_ recognizer: UIHoverGestureRecognizer) {
            guard let view = hostView else { return }
            let p = recognizer.location(in: view)
            Task { @MainActor in self.monitor.setHover(p) }
        }

        func pointerInteraction(
            _ interaction: UIPointerInteraction,
            regionFor request: UIPointerRegionRequest,
            defaultRegion: UIPointerRegion
        ) -> UIPointerRegion? {
            guard let view = interaction.view else { return defaultRegion }
            return UIPointerRegion(rect: view.bounds, identifier: "P14Probe" as NSString)
        }

        func pointerInteraction(
            _ interaction: UIPointerInteraction,
            styleFor region: UIPointerRegion
        ) -> UIPointerStyle? {
            UIPointerStyle.hidden()
        }
    }
}

final class ProbeUIView: UIView {
    weak var monitor: InputMonitor?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        report(touches, state: "DOWN")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        report(touches, state: "MOVE")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        report(touches, state: "UP")
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        report(touches, state: "CANCEL")
    }

    private func report(_ touches: Set<UITouch>, state: String) {
        guard let t = touches.first else { return }
        let p = t.location(in: self)
        Task { @MainActor [weak self] in
            self?.monitor?.setTouch(p, state: state)
        }
    }
}
