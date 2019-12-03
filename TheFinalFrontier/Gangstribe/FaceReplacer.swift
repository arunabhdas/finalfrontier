import UIKit
import AVFoundation
import GLKit

class FaceReplacer: NSObject {
  
  let imageView: GLKView
  var newFace: UIImage? {
    didSet {
      if let newFace = newFace {
        newFaceCI = CIImage(image: newFace)
      } else {
        newFaceCI = nil
      }
    }
  }
  
  fileprivate var newFaceCI: CIImage?
  fileprivate let eaglContext = EAGLContext(api: .openGLES2)
  fileprivate let context: CIContext
  fileprivate let detector: CIDetector
  
  init(imageView: GLKView) {
    self.imageView = imageView
    context = CIContext(eaglContext: self.eaglContext!)
    detector = CIDetector(ofType: CIDetectorTypeFace, context: self.context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh, CIDetectorTracking: true])!
    super.init()
    imageView.delegate = self
    imageView.context = eaglContext!
  }
  
  fileprivate let captureSession = AVCaptureSession()
  fileprivate var cameraImage: CIImage?
  
  
  fileprivate func replaceFaceInImage(_ startImage: CIImage) -> CIImage {
    guard let newFaceCI = newFaceCI else { return startImage }
    
    if let face = detector.features(in: startImage).first as? CIFaceFeature {
      
      let compositingFilter = CIFilter(name: "CISourceAtopCompositing")!
      let transformFilter = CIFilter(name: "CIAffineTransform")!
      
      let angle = face.hasFaceAngle ? face.faceAngle : 0
      let angleInRadians = CGFloat(angle * Float(M_PI / -180.0))
      let newFaceSize = newFaceCI.extent.size
      
      transformFilter.setValue(newFaceCI, forKey: kCIInputImageKey)
      let translate = CGAffineTransform(translationX: face.bounds.origin.x, y: face.bounds.origin.y)
      
      let scale = CGAffineTransform(scaleX: face.bounds.width / newFaceSize.width, y: face.bounds.height / newFaceSize.height)
      let rotation = CGAffineTransform(rotationAngle: angleInRadians)
      
      var finalTransform = CGAffineTransform.identity
      finalTransform = finalTransform.concatenating(scale)
      finalTransform = finalTransform.concatenating(rotation)
      finalTransform = finalTransform.concatenating(translate)
      
      transformFilter.setValue(NSValue(cgAffineTransform: finalTransform), forKey: "inputTransform")
      let transformResult = transformFilter.outputImage!
      compositingFilter.setValue(startImage, forKey: kCIInputBackgroundImageKey)
      compositingFilter.setValue(transformResult, forKey: kCIInputImageKey)
      
      return compositingFilter.outputImage!
      
    } else {
      return startImage
    }
  }
  
  func startCapture() throws
  {
    captureSession.sessionPreset = AVCaptureSession.Preset.photo
    let cameraError = NSError(domain: "facereplace", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to access front camera"])
    
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.front)

    guard let frontCamera = discoverySession.devices.first else {
        throw cameraError
    }
    do
    {
      let input = try AVCaptureDeviceInput(device: frontCamera)
      captureSession.addInput(input)
    }
    
    let videoOutput = AVCaptureVideoDataOutput()
    
    videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes()))
    if captureSession.canAddOutput(videoOutput)
    {
      captureSession.addOutput(videoOutput)
    }
    
    captureSession.startRunning()
  }
  
  func stopCapture() {
    captureSession.stopRunning()
  }
}

extension FaceReplacer: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
    cameraImage = CIImage(cvPixelBuffer: pixelBuffer)
    DispatchQueue.main.async {
      self.imageView.setNeedsDisplay()
    }
    
  }
}

extension FaceReplacer: GLKViewDelegate {
  func glkView(_ view: GLKView, drawIn rect: CGRect) {
    guard let cameraImage = cameraImage else { return }
    
    let result = replaceFaceInImage(cameraImage)
    
    context.draw(result,
                 in: AVMakeRect(aspectRatio: result.extent.size, insideRect: CGRect(x: 0, y: 0, width: view.drawableWidth, height: view.drawableHeight)), from: cameraImage.extent)
    
  }
}
