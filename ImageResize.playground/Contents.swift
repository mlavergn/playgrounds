import UIKit
import Accelerate
import PlaygroundSupport

class DemoViewController : UIViewController {
    let label = UILabel()

    func resize(ciimage: CIImage) -> NSImage? {
        guard let cgimage = CIContext().createCGImage(ciimage, from: ciimage.extent) else {
            //    guard let cgimage = ciimage.cgImage else {
            print("error")
            return nil
        }
        
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: .defaultIntent)
        
        let bytesPerPixel = cgimage.bitsPerPixel / 8
        
        
        // setup a buffer for the incoming image
        var sourceBuffer = vImage_Buffer()
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgimage, numericCast(kvImageNoFlags))
        
        let destHeight = 128
        let destWidth = 128
        
        var destBuffer = vImage_Buffer()
        vImageBuffer_Init(&destBuffer, vImagePixelCount(destWidth), vImagePixelCount(destHeight), UInt32(cgimage.bitsPerPixel), numericCast(kvImageNoFlags))
        
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        
        let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        
        let resizedImage = destCGImage.flatMap { NSImage(cgImage: $0, size: NSSize(width: destWidth, height: destHeight)) }
        return resizedImage
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let image = UIImage()
        
        let cgImage = image.cgImage!
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: cgImage.colorSpace!, bitmapInfo: cgImage.alphaInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: Int(size.width), height: Int(size.height)))
        
        context?.interpolationQuality = .high
        let newImage = UIImage(cgImage: context!.makeImage()!)
        return newImage
        
        
        // shitty scale
        //        let widthFactor = image.size.width / size.width
        //        let heightFactor = image.size.height / size.height
        
        //        var resizeFactor = widthFactor
        //        if image.size.height > image.size.width {
        //            resizeFactor = heightFactor
        //        }
        
        //        let size = CGSize(width: image.size.width / resizeFactor, height: image.size.height / resizeFactor)
        //        UIGraphicsBeginImageContext(size)
        //        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        //        return newImage!
        
        // crop
        //        let cgImage = image.cgImage?.cropping(to: CGRect(origin: CGPoint.zero, size: size))
        //        return UIImage(cgImage: cgImage!, scale: 0.0, orientation: .up)
    
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}

let vc = DemoViewController()
PlaygroundPage.current.liveView = vc

let parentFrame = UIApplication.shared.keyWindow?.frame

