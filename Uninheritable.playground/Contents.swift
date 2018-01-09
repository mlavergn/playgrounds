import Foundation

open class Base: NSObject {
    init(val: String, dummy: Int, dummy2: Int) {
        super.init()
    }
}

open class Super: Base {
    let val: String
    
    private init?(val: String, dummy: Int) {
        super.init(val: val, dummy: dummy, dummy2: 0)
    }
    
    public required convenience init?(val: String) {
        self.init(val: val, dummy: 0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
// The goal is to have Sub subclass Super
// but the fact that Super only exposes a convenience initializer
// prevents the init call from a child class from reaching the
// super classes
//
class Sub: Super {
    let otherVal = "yada"
    
    public init(val: String, nada: Int) {
        // this is not a valid initializer
        super.init(val: "sub", dummy: 0, dummy2: 0)
    }
    
    public convenience required init?(val: String) {
        self.init(val: "sub", nada: 0)
        // this is illegal due to being a convenience init
        // super.init(val: val)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
