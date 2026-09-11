import SwiftUI

struct ContentView: View {
    @StateObject private var monitor = InputMonitor()

    var body: some View {
        ZStack {
            TouchProbeView(monitor: monitor)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("P14 TOUCH BRIDGE V4")
                    .font(.title2.bold())

                Text("TAP EMÜLASYON TESTİ")
                    .font(.caption.monospaced())

                RoundedRectangle(cornerRadius: 24)
                    .fill(.blue.opacity(0.14))
                    .overlay(
                        VStack(spacing: 12) {
                            Text("TAP TEST")
                                .font(.largeTitle.bold())
                            Text("\(monitor.pseudoTapCount)")
                                .font(.system(size: 72, weight: .black, design: .rounded))
                            Text(monitor.detectorState)
                                .font(.headline.monospaced())
                            Text("X \(f(monitor.pseudoTapX))   Y \(f(monitor.pseudoTapY))")
                                .monospacedDigit()
                        }
                    )
                    .frame(maxHeight: 330)

                Text("P14 üzerinde parmağını kısa bir mesafe hareket ettirip durdur. Hareket 220 ms durduğunda V4 bunu geçici olarak TAP kabul eder.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)

                Text("Bu aşama yalnızca P14 hareketinden güvenilir bir TAP olayı türetip türetemediğimizi test eder.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()

                Button("Sıfırla") { monitor.clear() }
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }

    private func f(_ v: Double) -> String {
        String(format: "%.0f", v)
    }
}
