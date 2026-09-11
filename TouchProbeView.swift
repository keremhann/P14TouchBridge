import SwiftUI
import UIKit

struct TouchProbeView: UIViewRepresentable {
    let monitor: InputMonitor
    func makeUIView(context: Context) -> ProbeUIView {
        let v = ProbeUIView()
        v.monitor = monitor
        v.backgroundColor = .clear
        let hover = UIHoverGestureRecognizer(target: v, action: #selector(ProbeUIView.hover(_:)))
        v.addGestureRecognizer(hover)
        v.addInteraction(UIPointerInteraction(delegate: v))
        return v
    }
    func updateUIView(_ uiView: ProbeUIView, context: Context) { uiView.monitor = monitor }
}

final class ProbeUIView: UIView, UIPointerInteractionDelegate {
    weak var monitor: InputMonitor?
    @objc func hover(_ g: UIHoverGestureRecognizer) {
        let p = g.location(in: self)
        Task { @MainActor in self.monitor?.point(p) }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { send(touches) }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { send(touches) }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { send(touches) }
    private func send(_ touches: Set<UITouch>) {
        guard let p = touches.first?.location(in: self) else { return }
        Task { @MainActor in self.monitor?.point(p) }
    }
    func pointerInteraction(_ interaction: UIPointerInteraction, regionFor request: UIPointerRegionRequest, defaultRegion: UIPointerRegion) -> UIPointerRegion? {
        UIPointerRegion(rect: bounds)
    }
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        UIPointerStyle.hidden()
    }
}
