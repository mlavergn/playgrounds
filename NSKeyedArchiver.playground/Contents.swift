import Foundation

class Storable: NSObject, NSCoding {
    var setVar: Set<String>
    
    init(_ setVar: Set<String> = Set()) {
        self.setVar = setVar
    }
    
    override var description: String {
        return setVar.debugDescription
    }
    
    required convenience init(coder decoder: NSCoder) {
        if let setVar = decoder.decodeObject(forKey: "setVar") as? Set<String> {
            self.init(setVar)
        } else {
            self.init(Set())
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.setVar, forKey: "setVar")
    }
}

let x = Storable(["foo", "foo", "bar"])
print(x)
let y = NSKeyedArchiver.archivedData(withRootObject: x)
let z = NSKeyedUnarchiver.unarchiveObject(with: y)!
print(z)
