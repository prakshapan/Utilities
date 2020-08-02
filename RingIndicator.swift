import SwiftUI

struct RingIndicator: View {
    @State private var fillPoint: Double = 0.0
    @State private var colorIndex = 0

    let duration = 0.8

    var colors: [Color] = [.red, .green, .blue, .yellow]

    private var animation: Animation {
        Animation.easeInOut(duration: duration)
            .repeatForever(autoreverses: false)
    }

    private var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: duration,
            repeats: true,
            block: { _ in
                if self.colorIndex + 1 >= self.colors.count {
                    self.colorIndex = 0
                } else {
                    self.colorIndex += 1
                }
            })
    }

    var body: some View {
        VStack() {
            Ring(fillPoint: fillPoint)
                .stroke(colors[colorIndex], lineWidth: 10)
                .frame(width: 100, height: 100)
                .onAppear() {
                    withAnimation(self.animation) {
                        self.fillPoint = 1.0
                        _ = self.timer
                    }
            }
        }
    }
}

struct Ring: Shape {
    var fillPoint: Double
    var delayPoint: Double = 0.5

    var animatableData: Double {
        get { return fillPoint }
        set { fillPoint = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var start: Double = 0
        let end = 360 * fillPoint
        start = fillPoint > delayPoint ? 2 * fillPoint * 360 : 0

        var path = Path()
        path.addArc(center: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2),
            radius: rect.size.width / 2,
            startAngle: .degrees(start),
            endAngle: .degrees(end),
            clockwise: false)

        return path
    }

}

struct RingIndicatorModifier: ViewModifier {
    @Binding var isAnimating: Bool
    func body(content: Content) -> some View {
        ZStack {
            content.opacity(isAnimating ? 0 : 100)
            if isAnimating {
                VStack {
                    Spacer()
                    RingIndicator()
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
            }

        }
    }

}

extension View {
    func ringIndicator(_ isAnimating: Binding<Bool>) -> some View {
        ModifiedContent(
            content: self,
            modifier: RingIndicatorModifier(isAnimating: isAnimating)
        )
    }
}
