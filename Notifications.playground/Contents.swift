import UIKit
import PlaygroundSupport

let testNotification = Notification.Name("testNotificationIdentifier")

class TestNotification: NSObject {
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(TestNotification.handleNotification), name: testNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: testNotification, object: nil)
    }


    func postNotification() {
        NotificationCenter.default.post(name: testNotification, object: nil, userInfo:["foo": "bar"])
    }


    @objc func handleNotification(withNotification notification: NSNotification) {
        guard let message = notification.userInfo?["foo"] else {
            return
        }
        print(message)
    }
}

let n = TestNotification()
n.postNotification()


PlaygroundPage.current.needsIndefiniteExecution
