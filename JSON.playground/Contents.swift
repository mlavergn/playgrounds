import Foundation

class Item: NSObject {
    let id = NSUUID().uuidString
    let checkpoint = Date()
    
    override public var description: String {
        return "\(self.id): \(self.checkpoint)"
    }
}

// the JSON encoders will not recurse through these
// to generate an encodable representation
// there are only a few supported types: String / Int / Array / Dict / Bool ...
var itemStore: [String: Item] = [:]
let item = Item()
itemStore[item.id] = item

print(itemStore)

func decode(_ payload: Data) -> Any? {
    do {
        return try JSONSerialization.jsonObject(with:payload, options: [.mutableContainers, .allowFragments])
    } catch {
        return nil
    }
}

func encode(_ object: Any) -> Data? {
    do {
        return try JSONSerialization.data(withJSONObject:object, options:[])
    } catch {
        return nil
    }
}

let enc = encode(itemStore)
print(enc!)

let dec = decode(enc!)
print(dec!)
