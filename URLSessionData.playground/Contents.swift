import Foundation
import PlaygroundSupport
import UIKit

enum BackgroundRequestType: String {
    case POST
    case GET
}

class BackgroundRequest: NSObject, UIApplicationDelegate, URLSessionDelegate, URLSessionTaskDelegate {
    
    // root string for session IDs
    var sessionRoot = "com.example.app."
    
    override init() {
        super.init()
        UIApplication.shared.delegate = self
    }
    
    // Performs the background call
    func performBackgroundRequest(_ url: URL, _ body: String, _ uuid: String) {
        let config = URLSessionConfiguration.background(withIdentifier: sessionRoot + uuid)
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = BackgroundRequestType.POST.rawValue
        
        guard let fileURL = serializePayloadToDisk(body: body) else {
            print("failed to serialize")
            return
        }
        
        let sessionUploadTask = session.dataTask(with: request)
        sessionUploadTask.resume()
    }
    
    // Write the payload to disk
    func serializePayloadToDisk(body: String) -> URL? {
        guard let data = body.data(using: .utf8) else {
            return nil
        }
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("uploadData")
        try? data.write(to: fileURL)
        
        return fileURL
    }
    
    // URLSessionTaskDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("didComplete")
        if let _ = error {
            print(error!.localizedDescription)
        } else {
            // do your parsing with buffer here.
            guard let urlResponse = task.response as? HTTPURLResponse else {
                return
            }
            print(urlResponse.statusCode)
        }
    }
    
    // UIApplicationDelegate
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        URLSessionConfiguration.background(withIdentifier: identifier)
    }
}

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
BackgroundRequest().performBackgroundRequest(url!, "{'title': 'foo', 'body': 'bar', 'userId': 8888}", NSUUID().uuidString)

PlaygroundPage.current.needsIndefiniteExecution = true

