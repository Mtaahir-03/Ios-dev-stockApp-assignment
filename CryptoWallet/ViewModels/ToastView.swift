import SwiftUI

struct ToastView: View {
    let message: String
    let icon: String
    let showToast: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            if showToast {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .foregroundColor(.white)
                    
                    Text(message)
                        .font(Typography.bodyBold)
                        .foregroundColor(.white)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(Color.black.opacity(0.8))
                .cornerRadius(30)
                .padding(.bottom, 32)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(), value: showToast)
            }
        }
    }
}
