import Foundation

func simulatorDevice() -> String {
    let path = NSTemporaryDirectory()
    guard let range = path.range(of: "/data/") else {
        return "unknown"
    }
    let plist = String(path[..<range.lowerBound] + "/device.plist")
    guard let dict = NSDictionary(contentsOfFile: plist) else {
        return "unknown"
    }
    guard let device = dict["name"] as? String else {
        return "unknown"
    }
    return device
}
print(simulatorDevice())

