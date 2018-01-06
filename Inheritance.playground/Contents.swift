// structs are not inheritable
struct Wheels {
    var amount: Int?
}

// fails
//struct Car: Vehicle {
//    var name: String?
//}

// fails
//class Bike: Vehicle {
//    var name: String?
//}

class Transport {
    required init(_ wheels: Wheels) {
    }
}

let x = Transport(Wheels())

// required have to decend from the parent implementation
class Boat: Transport {
    // fails
//        required init(_ wheels: Any) {
//            super.init(wheels as! Wheels)
//        }
    required init(_ wheels: Wheels) {
        super.init(wheels)
    }
}

let y = Boat(Wheels())
