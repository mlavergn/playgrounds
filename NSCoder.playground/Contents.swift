import Foundation

enum DiskStoreItem: String {
	case id
}

enum DiskStoreKey: String {
	case items
	case checkpoint
}

class DiskStore: NSObject, NSCoding {
    private var items: [String: [Int]]
    private var checkpoint: TimeInterval
    
    static func sharedInstance() -> DiskStore {
        guard let diskStore = DiskStore.read() else {
            return DiskStore()
        }
        return diskStore
    }
    
    init(items: [String: [Int]] = [:], checkpoint: TimeInterval = Date.timeIntervalSinceReferenceDate) {
        self.items = items
        self.checkpoint = checkpoint
    }
    
    /// MARK: NSCoding
    
    required convenience init(coder decoder: NSCoder) {
        if let items = decoder.decodeObject(forKey: DiskStoreKey.items.rawValue) as? [String: [Int]] {
            let checkpoint = decoder.decodeDouble(forKey: DiskStoreKey.checkpoint.rawValue)
            self.init(items: items, checkpoint: checkpoint)
        } else {
            self.init()
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.items, forKey: DiskStoreKey.items.rawValue)
        aCoder.encode(self.checkpoint, forKey: DiskStoreKey.checkpoint.rawValue)
    }
    
    /// MARK: Features
    
    static let fileURL: URL = {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, false)
        let pathRoot: String
        if !paths.isEmpty {
            pathRoot = (paths[0] as NSString).expandingTildeInPath
        } else {
            pathRoot = ("~/Library" as NSString).expandingTildeInPath
        }
        var pathURL = URL(fileURLWithPath: pathRoot, isDirectory: true)
        pathURL.appendPathComponent("com.example.app")
        
        var reachable = (try? pathURL.checkResourceIsReachable()) ?? false
        do {
            if reachable == false {
                try FileManager.default.createDirectory(at: pathURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
			print(error)
        }
        
        pathURL.appendPathComponent("DiskStore.dat")
        
        return pathURL
    }()
	
	static func diskCheckpoint() -> TimeInterval {
		guard let attr = try? FileManager.default.attributesOfItem(atPath: fileURL.path) else {
			return Date.timeIntervalSinceReferenceDate
		}
		let diskDate = attr[FileAttributeKey.modificationDate] as? Date
		guard let diskCheckoint = diskDate?.timeIntervalSinceReferenceDate else {
			return Date.timeIntervalSinceReferenceDate
		}
		return diskCheckoint
	}
    
    static func read() -> DiskStore? {
        let reachable = (try? fileURL.checkResourceIsReachable()) ?? false
        if reachable {
            guard let diskStore = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? DiskStore else {
                print("bomb out")
                return nil
            }
            print(diskStore)
            return diskStore
        }
        print("read out")
        return nil
    }
    
    func push(_ item: DiskStoreItem, _ id: Int) {
        if items[item.rawValue] != nil {
            items[item.rawValue]!.append(id)
        } else {
            items[item.rawValue] = [id]
        }
    }
    
    func peek(_ item: DiskStoreItem) -> Int? {
        return items[item.rawValue]?.last
    }
    
    func pop(_ item: DiskStoreItem) -> Int? {
        return items[item.rawValue]?.removeLast()
    }
    
    func commit() -> Bool {
		// check to ensure we don't have a stale copy
        if self.checkpoint < DiskStore.diskCheckpoint() {
			print("merge")
			// merge required
			return false
        }
        checkpoint = Date.timeIntervalSinceReferenceDate
        let result = NSKeyedArchiver.archiveRootObject(self, toFile: DiskStore.fileURL.path)
        if !result {
            print("write error")
            return false
        }
	
		return true
    }
    
    override var description: String {
        return "\(self.checkpoint): \(self.items)"
    }
}

let diskStore = DiskStore.sharedInstance()
print(diskStore)

