//  Created by Michał Kozik on 03/02/2023.

import SwiftUI

struct GameClock: View {
    @State private var topClockIsActive: Bool = false
    @State private var bottomClockIsActive: Bool = true

    var body: some View {
        VStack {
            PlayerClock(isActive: topClockIsActive)
                .rotationEffect(.degrees(180))
            Button("Toogle", action: toggleClocks)
            PlayerClock(isActive: bottomClockIsActive)
        }
    }

    func toggleClocks() -> Void {
        topClockIsActive.toggle()
        bottomClockIsActive.toggle()
    }
}


struct GameClock_Previews: PreviewProvider {
    static var previews: some View {
        GameClock()
    }
}
