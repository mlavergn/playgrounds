import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Demo"
        label.textColor = .darkGray
		view.addSubview(label)

		let textField = UITextField(frame: CGRect(x: 10, y: 60, width: 300, height: 44))
		textField.placeholder = "Type here"
		textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
		textField.textColor = .black
		textField.isUserInteractionEnabled = true
		view.addSubview(textField)
		
        self.view = view
    }
}

PlaygroundPage.current.liveView = MyViewController()
