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
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(view)
        
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: mainView, attribute: .width, multiplier: 1, constant: -20)

        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .lessThanOrEqual, toItem: mainView, attribute: .height, multiplier: 1, constant: 120)

        let leftConstraint = NSLayoutConstraint(item: view, attribute: .leadingMargin, relatedBy: .equal, toItem: mainView, attribute: .leadingMargin, multiplier: 1, constant: 5)

        let rightConstraint = NSLayoutConstraint(item: view, attribute: .trailingMargin, relatedBy: .equal, toItem: mainView, attribute: .trailingMargin, multiplier: 1, constant: 5)

        let topConstraint = NSLayoutConstraint(item: view, attribute: .centerYWithinMargins, relatedBy: .equal, toItem: mainView, attribute: .centerYWithinMargins, multiplier: 1, constant: 5)
        
        mainView.addConstraints([widthConstraint, heightConstraint, leftConstraint, rightConstraint])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = .gray

        mainView.addSubview(label)
        
        var labelConstraints: [NSLayoutConstraint] = []
        
        labelConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat:
            "V:[label(==120@1000)]",
            options: [],
            metrics: nil,
            views: ["label": label]))

        labelConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat:
            "H:|[label]|",
            options: [],
            metrics: nil,
            views: ["label": label]))
        
        NSLayoutConstraint.activate(labelConstraints)
        
        // mainView will be full screen by default
        self.view = mainView
    }
}

let vc = DemoViewController()
PlaygroundPage.current.liveView = vc

let parentFrame = UIApplication.shared.keyWindow?.frame
vc.setLabelText("\(parentFrame!.size)")
