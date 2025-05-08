import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let address: String
    let size: CGFloat
    
    var body: some View {
        Image(uiImage: generateQRCode(from: address, size: size))
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
    
    private func generateQRCode(from string: String, size: CGFloat) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        filter.correctionLevel = "H"
        
        guard let qrCodeImage = filter.outputImage else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }
        
        let scale = size / qrCodeImage.extent.width
        let scaledImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }
        
        return UIImage(cgImage: cgImage)
    }
}
