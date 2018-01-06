import UIKit
import PlaygroundSupport

class DemoViewController : UIViewController {
    let label = UILabel()
    
    public func setLabelText(_ text: String) {
        label.text = text
    }
    
    override func loadView() {
        let mainView = UIView()
        mainView.backgroundColor = .yellow
        
        // in playgrounds this is actually an iPad, so we use hard coded values
        // let screenRect = UIScreen.main.bounds
        let screenRect = CGRect(x: 0, y: 0, width: 375, height: 668)

        let view = UIView(frame: CGRect(x: 5, y: 5, width: screenRect.size.width - 10, height: screenRect.size.height - 10))
        mainView.addSubview(view)
        view.backgroundColor = .white
        
        var labelRect = CGRect(x: 0, y: 0, width: 150, height: 20)
        labelRect.origin.x = (screenRect.width - labelRect.width) / 2
        labelRect.origin.y = (screenRect.height - labelRect.height) / 2
        
        label.text = "\(labelRect.origin)"
        
        label.frame = labelRect
        label.textColor = .black
        label.backgroundColor = .gray
        
        view.addSubview(label)
        
        // mainView will be full screen by default
        self.view = mainView
    }
}

let vc = DemoViewController()
PlaygroundPage.current.liveView = vc

let parentFrame = UIApplication.shared.keyWindow?.frame
//vc.setLabelText("\(parentFrame!.size)")
