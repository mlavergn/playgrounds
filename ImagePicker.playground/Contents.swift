import UIKit
import PlaygroundSupport

class DemoViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

		let picker = UIImagePickerController()
		picker.sourceType = .photoLibrary
		
		let accessCamera = false
		if accessCamera {
			picker.sourceType = .camera
			picker.cameraCaptureMode = .photo
			picker.showsCameraControls = false
			picker.cameraOverlayView = nil
		}

		picker.isNavigationBarHidden = true
		picker.isToolbarHidden = true
		picker.edgesForExtendedLayout = UIRectEdge.all
		
        self.view = view
    }
}

PlaygroundPage.current.liveView = DemoViewController()
