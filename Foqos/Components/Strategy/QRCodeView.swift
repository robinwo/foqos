import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI
import UIKit

struct QRCodeView: View {
  @EnvironmentObject var themeManager: ThemeManager
  @Environment(\.dismiss) private var dismiss

  let url: String
  let profileName: String
  @State private var qrCodeImage: UIImage? = nil

  var body: some View {
    NavigationView {
      ZStack {
        GlassPageBackground()

        VStack(spacing: 30) {
          Text(profileName)
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.top)

          VStack(spacing: 20) {
            if let qrCodeImage {
              Image(uiImage: qrCodeImage)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding(20)
                .background(
                  RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white.opacity(0.92))
                )
            } else {
              ProgressView()
                .frame(width: 250, height: 250)
            }

            Text("Scan this code without the app running to start or stop this profile.")
              .font(.body)
              .multilineTextAlignment(.center)
              .foregroundColor(.secondary)
              .fixedSize(horizontal: false, vertical: true)
          }
          .padding(24)
          .glassSurface(cornerRadius: 28, tint: themeManager.themeColor, strokeOpacity: 0.14)

          if let qrCodeImage {
            ShareLink(
              item: Image(uiImage: qrCodeImage),
              preview: SharePreview(
                profileName,
                image: Image(uiImage: qrCodeImage)
              )
            ) {
              HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Share QR code")
              }
              .frame(maxWidth: .infinity)
              .padding()
              .background(themeManager.themeColor)
              .foregroundColor(.white)
              .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
          }
        }
        .padding()
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbarBackground(.hidden, for: .navigationBar)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
              .foregroundColor(.primary)
          }
        }
      }
      .onAppear {
        generateQRCode(from: url)
      }
    }
  }

  private func generateQRCode(from string: String) {
    // Create the QR code filter
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    // Set the input message
    let data = Data(string.utf8)
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("M", forKey: "inputCorrectionLevel")

    // Get the output image
    if let outputImage = filter.outputImage {
      // Scale the image
      let transform = CGAffineTransform(scaleX: 10, y: 10)
      let scaledImage = outputImage.transformed(by: transform)

      // Convert to UIImage
      if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
        self.qrCodeImage = UIImage(cgImage: cgImage)
      }
    }
  }
}
