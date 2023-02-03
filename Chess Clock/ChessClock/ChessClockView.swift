//  Created by Michał Kozik on 03/02/2023.

import SwiftUI

struct ChessClockView: View {
    @StateObject private var theClock: ChessClock = ChessClock(seconds: 3)

    private let activeForeground: Color = .white
    private let activeBackground: Color = .green
    private let inactiveForeground: Color = .black
    private let inactiveBackground: Color = .white

    private static var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .hour, .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        formatter.allowsFractionalUnits = true
        return formatter
    }()

    var body: some View {
        VStack {

            Button(action: theClock.firstTimerTap) {
                HStack{
                    Spacer()
                    VStack {
                        Spacer()
                        Text(ChessClockView.timeFormatter.string(from: theClock.firstTimerElapsedTime)!)
                            .font(.system(size: 72))
                        Spacer()
                    }
                    Spacer()
                }
                .background(theClock.firstTimerIsActive ? activeBackground : inactiveBackground)
                .foregroundColor(theClock.firstTimerIsActive ? activeForeground : inactiveForeground)
            }
            .rotationEffect(Angle(degrees: 180))

            Divider()

            Button(action: theClock.secondTimerTap) {
                HStack{
                    Spacer()
                    VStack {
                        Spacer()
                        Text(ChessClockView.timeFormatter.string(from: theClock.secondTimerElapsedTime)!)
                            .font(.system(size: 72))
                        Spacer()
                    }
                    Spacer()
                }
                .background(theClock.secondTimerIsActive ? activeBackground : inactiveBackground)
                .foregroundColor(theClock.secondTimerIsActive ? activeForeground : inactiveForeground)
            }
        }
    }
}


struct GameClock_Previews: PreviewProvider {
    static var previews: some View {
        ChessClockView()
    }
}
