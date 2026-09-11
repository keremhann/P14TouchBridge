import SwiftUI

struct ContentView: View {
    @StateObject private var monitor = InputMonitor()

    var body: some View {
        ZStack {
            TouchProbeView(monitor: monitor)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Text("P14 TOUCH BRIDGE")
                    .font(.title2.bold())

                Text("TEST 1 — INPUT DIAGNOSTIC")
                    .font(.caption.monospaced())

                GroupBox("USB / Mouse verisi") {
                    VStack(alignment: .leading, spacing: 8) {
                        row("GCMouse", monitor.mouseConnected ? "BAĞLI ✅" : "YOK ❌")
                        row("Delta X", f(monitor.deltaX))
                        row("Delta Y", f(monitor.deltaY))
                        row("Sol tık", monitor.leftPressed ? "BASILI" : "BIRAKILDI")
                        row("Scroll X", f(monitor.scrollX))
                        row("Scroll Y", f(monitor.scrollY))
                    }
                }

                GroupBox("iOS koordinatları") {
                    VStack(alignment: .leading, spacing: 8) {
                        row("Hover X", f(monitor.hoverX))
                        row("Hover Y", f(monitor.hoverY))
                        row("Touch X", f(monitor.touchX))
                        row("Touch Y", f(monitor.touchY))
                        row("Touch state", monitor.touchState)
                        row("Event", "\(monitor.eventCount)")
                    }
                }

                Text("P14'te köşelere dokun ve parmağını sürükle. Özellikle Hover X/Y ile Touch X/Y değerlerine bak.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)

                Spacer()

                Text("Amaç: P14'ün relative mouse verisini iOS içindeki mutlak pointer koordinatına çevirebiliyor muyuz?")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .allowsHitTesting(false)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button("Sıfırla") { monitor.clear() }
                        .buttonStyle(.borderedProminent)
                        .padding()
                }
            }
        }
    }

    private func row(_ name: String, _ value: String) -> some View {
        HStack {
            Text(name)
            Spacer()
            Text(value).monospacedDigit()
        }
    }

    private func f(_ v: Double) -> String {
        String(format: "%.2f", v)
    }
}
