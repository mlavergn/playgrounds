import Foundation
import Metal

func metalRoutine() {
    if #available(iOS 11.0, macOS 10.11, *) {
        // grab the default metal device
        guard let device: MTLDevice = MTLCreateSystemDefaultDevice() else {
            return
        }
        
        // create a command queue to process commands
        guard let commandQueue: MTLCommandQueue = device.makeCommandQueue() else {
            return
        }
        
        // command buffers hold any state we require for a given command
        guard let commandBuffer: MTLCommandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }
        
        // create a compute command encoder to do a computational task
        let commandEncoder:  MTLComputeCommandEncoder? = commandBuffer.makeComputeCommandEncoder()
        
        // setup
        typealias DataType = CInt
        
        let count = 10_000_000
        var data = (0..<count).map{ _ in DataType(arc4random_uniform(100)) } // Our data, randomly generated
        let dataBuffer = device.newBufferWithBytes(&data, length: strideof(DataType.stride) * count, options: []) // Our data in a buffer (copied)
        
        
        // commits the task
        commandBuffer.commit()
        
        // wait until it's completed
        commandBuffer.waitUntilCompleted()
    }
}

metalRoutine()
