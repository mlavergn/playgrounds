import Foundation

protocol BaseProtocol {
    func callable(foo: String)
}

class Base {
    var delegate: BaseProtocol?
    
    init(val: String) {
        self.delegate?.callable(foo: val)
    }
}

extension Base {
    // as in ObjC, this is not allowed
    // var something: String
    func callable(foo: String) {
        print(foo)
    }
}
// being our own deelgate is fine here since the extension
// has satisfied BaseProtocol for all inheriters of Base
class SuperBase: Base, BaseProtocol {
    init() {
        super.init(val: "demo")
        self.delegate = self
    }
}

// everything is fine
let test = SuperBase()
test.callable(foo: "bar")
