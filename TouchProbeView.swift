import SwiftUI
import UIKit

struct TouchProbeView: UIViewRepresentable {
    let monitor: InputMonitor

    func makeUIView(context: Context) -> ProbeUIView {
        let view = ProbeUIView()
        view.backgroundColor = .clear
        view.monitor = monitor

        let hover = UIHoverGestureRecognizer(target: view, action: #selector(ProbeUIView.handleHover(_:)))
        view.addGestureRecognizer(hover)

        let pointer = UIPointerInteraction(delegate: view)
        view.addInteraction(pointer)

        return view
    }

    func updateUIView(_ uiView: ProbeUIView, context: Context) {
        uiView.monitor = monitor
    }
}

final class ProbeUIView: UIView, UIPointerInteractionDelegate {
    weak var monitor: InputMonitor?

    @objc func handleHover(_ recognizer: UIHoverGestureRecognizer) {
        let p = recognizer.location(in: self)
        Task { @MainActor in
            self.monitor?.feedPoint(p)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else { return }
        Task { @MainActor in
            self.monitor?.feedPoint(p)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else { return }
        Task { @MainActor in
            self.monitor?.feedPoint(p)
        }
    }

    func pointerInteraction(_ interaction: UIPointerInteraction,
                            styleFor region: UIPointerRegion) -> UIPointerStyle? {
        UIPointerStyle.hidden()
    }

    func pointerInteraction(_ interaction: UIPointerInteraction,
                            regionFor request: UIPointerRegionRequest,
                            defaultRegion: UIPointerRegion) -> UIPointerRegion? {
        UIPointerRegion(rect: bounds)
    }
}
