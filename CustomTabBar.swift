//
//  HomeTab.swift
//  LoginForms
//
//  Created by Praks on 8/1/20.
//

import SwiftUI
enum TabButtons: CaseIterable, Hashable {
    case home, personal, business, jobStatus, more

    var title: String {
        switch self {
        case .home: return "Home"
        case .personal: return "Personal"
        case .business: return "Business"
        case .jobStatus: return "Job Status"
        case .more: return "More"
        }
    }

    var icon: Image {
        switch self {
        case .home: return Image(systemName: "house")
        case .personal: return Image(systemName: "person")
        case .business: return Image(systemName: "bag")
        case .jobStatus: return Image(systemName: "waveform.path.ecg")
        case .more: return Image(systemName: "line.horizontal.3")
        }
    }
}
struct HomeTab: View {
    @State var selectedTab: TabButtons = .business
    @State var curvePosition: CGFloat = 0

    var body: some View {
        GeometryReader { reader in
            HStack(alignment: .center, spacing: 0) {
                ForEach(TabButtons.allCases, id: \.self) { tab in
                    GeometryReader { buttonReader in
                        VStack(alignment: .center, spacing: 0) {
                            self.customizeImage(tab)
                            Text(tab.title)
                                .font(.system(size: 12))
                                .frame(maxWidth: .infinity)
                                .foregroundColor(tab == self.selectedTab ? Color.red : Color.gray)
                        }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onAppear {
                                DispatchQueue.main.async {
                                    self.curvePosition = reader.frame(in: .global).midX
                                }
                            }
                            .onTapGesture() {
                                withAnimation(.spring()) {
                                    self.selectedTab = tab
                                    self.curvePosition = buttonReader.frame(in: .global).midX
                                }
                        }
                    }

                }
            }.frame(width: reader.size.width,
                height: 70)
                .background(Color.white.clipShape(CurveShape(curvePosition: self.curvePosition)))
            .shadow(color: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), radius: 5, x: 0, y: 0)
        }.background(Color.white)
    }

    func customizeImage(_ tab: TabButtons) -> AnyView {
        return AnyView(
            tab.icon
                .frame(width: 30, height: 30)
                .foregroundColor(tab == self.selectedTab ? Color.white : Color.gray)
                .offset(y: self.selectedTab == tab ? -25 : 0)
                .background(
                    Rectangle().frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .opacity(self.selectedTab == tab ? 1 : 0)
                        .offset(y: self.selectedTab == tab ? -25 : 0)
                        .foregroundColor(.red)
                        .shadow(color: Color(#colorLiteral(red: 1, green: 0.2333956361, blue: 0.1861040294, alpha: 0.6425506162)), radius: 5, x: 0, y: 0)
                )
        )
    }

}

struct HomeTab_Previews: PreviewProvider {
    static var previews: some View {
        HomeTab()
    }
}

struct CurveShape: Shape {
    var curvePosition: CGFloat
    var animatableData: CGFloat {
        get { return curvePosition }
        set { curvePosition = newValue }
    }

    func path(in rect: CGRect) -> Path {

        return Path { path in

            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))


            // adding Curve...
            path.move(to: CGPoint(x: curvePosition + 75, y: 0))
            path.addQuadCurve(to: CGPoint(x: curvePosition + 30, y: 23), control: CGPoint(x: curvePosition + 50, y: 2))

            path.addQuadCurve(to: CGPoint(x: curvePosition - 30, y: 23), control: CGPoint(x: curvePosition, y: 50))

            path.addQuadCurve(to: CGPoint(x: curvePosition - 75, y: 0), control: CGPoint(x: curvePosition - 50, y: 2))
        }
    }
}
