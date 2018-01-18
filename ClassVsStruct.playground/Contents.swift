import Foundation

// struct implementation of Foo
struct SFoo {
    var x: String
    let y: Int
    
    init() {
        x = "hello"
        y = 1
    }
}

// class implementation of Foo
class CFoo {
    var x: String
    let y: Int
    
    init() {
        x = "hello"
        y = 1
    }
}

var testSFoo = SFoo()
var testCFoo = CFoo()

// will be the same
print("struct:", testSFoo.x)
print("class:", testCFoo.x)

func testS(foo: SFoo) {
    // makes a copy of SFoo (value ref)
    var z = foo
    z.x = "world";
    print("struct:", z.x)
}

func testC(foo: CFoo) {
    // references the instance of CFoo (pointer ref)
    let z = foo
    z.x = "world";
    print("class:", z.x)
}

// call the functions
testS(foo: testSFoo)
testC(foo: testCFoo)

// these will differ since the SFoo has never been modified
print("struct:", testSFoo.x)
print("class:", testCFoo.x)

// force swift to reference the  same struct via inout
func testSIO(foo: inout SFoo) {
    // this would still make a copy, need to access foo directly
    // var z = foo
    foo.x = "world";
    print("struct:", foo.x)
}

testSIO(foo: &testSFoo)

// these will be the same
print("struct:", testSFoo.x)
print("class:", testCFoo.x)
