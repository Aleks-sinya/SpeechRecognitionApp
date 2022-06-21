//
//  TextViewController.swift
//  SpeechRecognitionApp
//
//  Created by Алексей Синяговский on 21.06.2022.
//

import UIKit
import AVFoundation
import Speech

class TextViewController: UIViewController {
    var text = ("","")
    
    var player: AVAudioPlayer?
    
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var recognizeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text.1
        title = text.0
        
        //configure player // if you need to play text
        guard let url = Bundle.main.url(forResource: text.1, withExtension: "mp3") else { return }
        player = try? AVAudioPlayer(contentsOf: url)
        
        // MARK: - Configure speech recognition
        
        SFSpeechRecognizer.requestAuthorization {[unowned self] (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    [unowned self] in
                    self.recognizeButton.isEnabled = true
                }
            case .denied:
                print("status denied")
            case .notDetermined:
                print("status not determined")
            case .restricted:
                print("status restricted")
            @unknown default:
                fatalError()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recognizeAction(_ sender: UIButton) {
        if sender.isSelected {
            audioEngine.stop()
            request.endAudio()
            recognitionTask?.cancel()
        } else {
            startRecognition()
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    fileprivate func startRecognition() {
        let node = audioEngine.inputNode
        let recognitionFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recognitionFormat) {
            [unowned self] (buffer, audioTime) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch let error {
            print(error.localizedDescription)
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: {
            [unowned self] (result, error) in
            if let res = result?.bestTranscription {
                DispatchQueue.main.async { [unowned self] in
                    self.resultLabel.text = res.formattedString;
                }
            } else if let error = error {
                print("\(error.localizedDescription)")
            }
        })
    }

}

