import Cocoa
import AVFoundation
import AVKit
import QuartzCore
import PlaygroundSupport

var view = NSView(frame: NSRect(x: 0, y: 0, width: 640, height: 480))

var session = AVCaptureSession()

session.sessionPreset = AVCaptureSession.Preset.vga640x480
session.beginConfiguration()
session.commitConfiguration()

var input : AVCaptureDeviceInput! = nil
var err : NSError?
var devices : [AVCaptureDevice] = AVCaptureDevice.devices()
for device in devices {
	if device.hasMediaType(AVMediaType.video) && device.supportsSessionPreset(AVCaptureSession.Preset.vga640x480) {
		
		try! input = AVCaptureDeviceInput(device: device as AVCaptureDevice) as AVCaptureDeviceInput
		
		if session.canAddInput(input) {
			session.addInput(input)
			break
		}
	}
}

let k = String(kCVPixelBufferPixelFormatTypeKey)
let v = kCVPixelFormatType_32BGRA

var output = AVCaptureVideoDataOutput()
output.videoSettings = [k: v]
output.alwaysDiscardsLateVideoFrames = true

if session.canAddOutput(output) {
	session.addOutput(output)
}

var captureLayer = AVCaptureVideoPreviewLayer(session: session)

view.wantsLayer = true
view.layer = captureLayer

session.startRunning()

PlaygroundPage.current.liveView = view
