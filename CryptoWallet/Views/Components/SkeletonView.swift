import SwiftUI

struct SkeletonView: View {
    let width: CGFloat
    let height: CGFloat
    
    @State private var isAnimating = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.gray.opacity(0.2),
                            Color.gray.opacity(0.1),
                            Color.gray.opacity(0.2)
                        ]
                    ),
                    startPoint: isAnimating ? .leading : .trailing,
                    endPoint: isAnimating ? .trailing : .leading
                )
            )
            .frame(width: width, height: height)
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

struct TokenRowSkeleton: View {
    var body: some View {
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                SkeletonView(width: 60, height: 16)
                SkeletonView(width: 120, height: 12)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                SkeletonView(width: 80, height: 16)
                SkeletonView(width: 60, height: 12)
            }
        }
        .padding()
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
    }
}
