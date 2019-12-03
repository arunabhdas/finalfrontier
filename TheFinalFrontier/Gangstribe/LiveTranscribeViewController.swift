import UIKit
import GLKit
import AVFoundation
import Speech

class LiveTranscribeViewController: UIViewController {
  
  let audioEngine = AVAudioEngine()
  let speechRecognizer = SFSpeechRecognizer()
  let request = SFSpeechAudioBufferRecognitionRequest()
  var recognitionTask: SFSpeechRecognitionTask?
  var mostRecentlyProcessedSegmentDuration: TimeInterval = 0
  
  @IBOutlet weak var imageView: GLKView!
  var faceReplacer: FaceReplacer!
  
  @IBOutlet weak var faceCollectionView: UICollectionView!
  let faceSource = FaceSource()
  
  @IBOutlet weak var transcriptionOutputLabel: UILabel!
  
  @IBAction func handleDoneTapped(_ sender: BorderedButton) {
    faceReplacer.stopCapture()
    stopRecording()
    dismiss(animated: true, completion: .none)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialiseFaceReplacer()
    SFSpeechRecognizer.requestAuthorization {
      [unowned self] (authStatus) in
      switch authStatus {
      case .authorized:
        do {
          try self.startRecording()
        } catch let error {
          print("There was a problem starting recording: \(error.localizedDescription)")
        }
      case .denied:
        print("Speech recognition authorization denied")
      case .restricted:
        print("Not available on this device")
      case .notDetermined:
        print("Not determined")
      }
    }
  }
}

extension LiveTranscribeViewController {
  fileprivate func startRecording() throws {
    mostRecentlyProcessedSegmentDuration = 0
    self.transcriptionOutputLabel.text = ""
    // 1
    let node = audioEngine.inputNode
    let recordingFormat = node.outputFormat(forBus: 0)

    // 2
    node.installTap(onBus: 0, bufferSize: 1024,
                    format: recordingFormat) { [unowned self]
      (buffer, _) in
      self.request.append(buffer)
    }

    // 3
    audioEngine.prepare()
    try audioEngine.start()
    
    recognitionTask = speechRecognizer?.recognitionTask(with: request) {
      [unowned self]
      (result, _) in
      if let transcription = result?.bestTranscription {
//        self.transcriptionOutputLabel.text = transcription.formattedString
        self.updateUIWithTranscription(transcription)
      }
    }
  }
  
  fileprivate func stopRecording() {
    audioEngine.stop()
    request.endAudio()
    recognitionTask?.cancel()
  }
}

extension LiveTranscribeViewController {
  fileprivate func initialiseFaceReplacer() {
    faceReplacer = FaceReplacer(imageView: imageView)
    do {
      try faceReplacer.startCapture()
    } catch let error as NSError {
      let alert = UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert)
      present(alert, animated: true, completion: .none)
    }
    faceCollectionView.dataSource = faceSource
    faceCollectionView.delegate = faceSource
    faceSource.collectionView = faceCollectionView
    faceSource.faceChosen = {
      [unowned self]
      face in
      self.faceReplacer.newFace = face
    }
  }
  
  // 1
  fileprivate func updateUIWithTranscription(_ transcription: SFTranscription) {
    self.transcriptionOutputLabel.text = transcription.formattedString
  
    // 2
    if let lastSegment = transcription.segments.last,
      lastSegment.duration > mostRecentlyProcessedSegmentDuration {
      mostRecentlyProcessedSegmentDuration = lastSegment.duration
      // 3
      faceSource.selectFace(lastSegment.substring)
    }
  }
}

