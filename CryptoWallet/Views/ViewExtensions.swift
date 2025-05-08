import SwiftUI

extension View {
    func cardTransition() -> some View {
        self.transition(
            .asymmetric(
                insertion: .scale(scale: 0.95).combined(with: .opacity),
                removal: .scale(scale: 0.95).combined(with: .opacity)
            )
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: true)
    }
    
    func slideInTransition() -> some View {
        self.transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: true)
    }
}
