import Foundation

/*
 https://www.uraimo.com/2016/04/07/swift-and-c-everything-you-need-to-know/
 */

// int array

let array: [Int8] = [1, 2, 3, 4]

array.withUnsafeBufferPointer { (ptr: UnsafeBufferPointer<Int8>) in
    print(ptr.baseAddress! + 1)
}

// char array

var cap = 10
var ptr = UnsafeMutablePointer<CChar>.allocate(capacity: cap)
var buf = UnsafeMutableBufferPointer(start: ptr, count: cap)
_ = buf.initialize(from: repeatElement(0, count: cap))

// set a value at index 5
ptr[5] = 123

// show me
var i = 0
for val in buf {
    print(i, val)
    i += 1
}

// cleanup refs
ptr.deinitialize()
// free
ptr.deallocate(capacity: cap)
