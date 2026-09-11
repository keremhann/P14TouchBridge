import SwiftUI

struct ContentView: View {
    @StateObject private var m = InputMonitor()
    var body: some View {
        ZStack {
            TouchProbeView(monitor: m).ignoresSafeArea()
            VStack(spacing: 14) {
                Text("P14 TOUCH BRIDGE").font(.title.bold())
                Text(m.state).font(.system(size: 42, weight: .black, design: .rounded))
                Text("X \(Int(m.x))   Y \(Int(m.y))").monospacedDigit()
                HStack { box("TAP",m.tapCount); box("2× TAP",m.doubleTapCount) }
                HStack { box("UZUN",m.longPressCount); box("DRAG",m.dragCount) }
                box("SWIPE",m.swipeCount)
                Text("P14 hareketini dokunma hareketlerine çeviren deneysel motor")
                    .font(.caption).foregroundStyle(.secondary)
                Spacer()
                Button("Sıfırla"){m.reset()}.buttonStyle(.borderedProminent)
            }.padding()
        }
    }
    private func box(_ s:String,_ n:Int)->some View {
        RoundedRectangle(cornerRadius:16).fill(.blue.opacity(0.12))
            .overlay(VStack{Text(s).font(.caption.bold());Text("\(n)").font(.largeTitle.bold())})
            .frame(height:100)
    }
}
