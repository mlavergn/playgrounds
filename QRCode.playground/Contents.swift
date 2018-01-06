import Cocoa
import PlaygroundSupport

func generateQRImage(text: String) -> CGImage? {
    let data = text.data(using: .isoLatin1, allowLossyConversion: false)

    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        // L 7% : M 15% : Q 25% : H 30%
        filter.setValue("M", forKey: "inputCorrectionLevel")
        
        if let ciImageDefault = filter.outputImage {
            let scaleX = ciImageDefault.extent.size.width
            let scaleY = ciImageDefault.extent.size.height
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            let ciImage = ciImageDefault.transformed(by: transform)
            
            guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else {
                return nil
            }
            
            return cgImage
        }

        return nil
    }
    
    return nil
}

let text = "DLRGQELIGS234098"
if let cgImage = generateQRImage(text: text) {
    let image = NSImage.init(cgImage: cgImage, size: NSSize(width: 256, height: 256))
    let imageView = NSImageView(image: image)
    imageView.setFrameSize(image.size)
    imageView.translatesAutoresizingMaskIntoConstraints = false

    let labelView = NSTextView()
    labelView.string = text
    labelView.font = NSFon
    labelView.alignment = .center
    labelView.translatesAutoresizingMaskIntoConstraints = false

    let view = NSView()
    view.addSubview(imageView)
    view.addSubview(labelView)
    view.setFrameSize(NSSize(width: 256, height: 256 + 20))

    let vconstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[image][label]|", options: [], metrics: nil, views: ["image": imageView, "label": labelView])
    let hconstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: ["label": labelView])

    view.addConstraints(vconstraints)
    view.addConstraints(hconstraints)

    PlaygroundPage.current.liveView = view
}

PlaygroundPage.current.needsIndefiniteExecution = true

