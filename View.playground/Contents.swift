import UIKit
import PlaygroundSupport

class DemoViewController : UIViewController {
    let label = UILabel()

    public func setLabelText(_ text: String) {
        label.text = text
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 32.0
        view.translatesAutoresizingMaskIntoConstraints = false

        
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}

let vc = DemoViewController()
PlaygroundPage.current.liveView = vc

let parentFrame = UIApplication.shared.keyWindow?.frame
vc.setLabelText("\(parentFrame!.size)")
