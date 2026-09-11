import SwiftUI

struct ContentView: View {
    @StateObject private var monitor = InputMonitor()

    var body: some View {
        ZStack {
            TouchProbeView(monitor: monitor)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Text("P14 TOUCH BRIDGE V5")
                    .font(.title2.bold())

                Text("TAP / DRAG AYIRMA TESTİ")
                    .font(.caption.monospaced())

                HStack(spacing: 12) {
                    card("TAP", "\(monitor.pseudoTapCount)")
                    card("DRAG", "\(monitor.pseudoDragCount)")
                }

                Text(monitor.detectorState)
                    .font(.system(size: 42, weight: .black, design: .rounded))

                VStack(spacing: 5) {
                    Text("Son TAP: X \(f(monitor.pseudoTapX))  Y \(f(monitor.pseudoTapY))")
                    Text("Mesafe: \(f(monitor.gestureDistance)) px")
                    Text("Süre: \(f(monitor.gestureDurationMs)) ms")
                }
                .font(.headline.monospacedDigit())

                Text("Kısa, küçük hareket → TAP\nUzun sürükleme → DRAG")
                    .multilineTextAlignment(.center)
                    .font(.callout)

                Spacer()

                Button("Sıfırla") { monitor.clear() }
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }

    private func card(_ title: String, _ value: String) -> some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(.blue.opacity(0.12))
            .overlay(
                VStack {
                    Text(title).font(.headline)
                    Text(value).font(.system(size: 52, weight: .black, design: .rounded))
                }
            )
            .frame(height: 150)
    }

    private func f(_ v: Double) -> String {
        String(format: "%.0f", v)
    }
}
