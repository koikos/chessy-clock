//  Created by Michał Kozik on 03/02/2023.

import SwiftUI

struct PlayerClock: View {
    let isActive: Bool
    @State var tapsCount: Int = 0

    let activeForeground: Color = .white
    let activeBackground: Color = .green

    let inactiveForeground: Color = .black
    let inactiveBackground: Color = .white

    var body: some View {
        Button(action: registerTap) {
            HStack{
                Spacer()
                VStack {
                    Spacer()
                    Text("\(tapsCount)")
                        .font(.system(size: 72))
                    Spacer()
                }
                Spacer()
            }
            .background(isActive ? activeBackground : inactiveBackground)
        .foregroundColor(isActive ? activeForeground : inactiveForeground)
        }
    }

    func registerTap() -> Void {
        if isActive == true {
            tapsCount += 1
        }
    }
}

struct PlayerClock_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PlayerClock(isActive: false)
            PlayerClock(isActive: true)
        }
    }
}
