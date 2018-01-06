import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let square = UIView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        square.backgroundColor = UIColor.blue
        
        view.addSubview(square)
        
        UIView.animate(withDuration: 2.0) {
            square.backgroundColor = UIColor.red
            square.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
        }

        self.view = view
    }
}

PlaygroundPage.current.liveView = MyViewController()
