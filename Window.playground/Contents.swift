//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .red
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

let iphone7Frame = CGRect(x: 0, y: 0, width: 375, height: 667)

let window = UIApplication.shared.keyWindow!
window.frame = iphone7Frame
window.clipsToBounds = true
window.makeKeyAndVisible()

