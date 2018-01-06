import UIKit
import PlaygroundSupport

class DemoViewController : UIViewController {
    
    override func loadView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, height: 400, width: 400))
        view.backgroundColor = .white

        let image = UIImage(named: "appleLogo.png")
        
        let button = UIButton()
        button.imageView?.image = image
        
        button.imageView?.contentMode = .center;
        
        view.addSubview(button)
        self.view = view
    }
}

let vc = DemoViewController()
PlaygroundPage.current.liveView = vc

let parentFrame = UIApplication.shared.keyWindow?.frame
