//
//  SOSViewController.swift
//  iHelp
//
//  Created by Lucio Grimaldi on 12/07/17.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class SOSViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
	
	
	var audioPlayer: AVAudioPlayer?
	var audioRecorder: AVAudioRecorder?
	var soundFileURL: URL?
	var textFromRegistration : String = ""

	@IBOutlet weak var progressView: UIProgressView!

	
	    override func viewDidLoad() {
        super.viewDidLoad()
			// Do any additional setup after loading the view.
            
            self.navigationItem.hidesBackButton = true
            let newBackButton : UIBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = newBackButton
			let fileManager = FileManager.default
			
			let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
			
			soundFileURL = dirPaths[0].appendingPathComponent("recordedAudio.caf")
			
			let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
			                      AVEncoderBitRateKey: 16,
			                      AVNumberOfChannelsKey: 2,
			                      AVSampleRateKey: 44100] as [String : Any]
			
			let audioSession = AVAudioSession.sharedInstance()
			
			
			do {
				try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
			}catch let error as NSError{
				NSLog("audioSession error: \(error.localizedDescription)", 0)
			}
			
			//il set della porta di output va DOPO audioSession.setCategory
			do {
				try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
			}
			catch let error as NSError{
				NSLog("audioSession error with speakers: \(error.localizedDescription)", 0)
			}
			
			
			do{
				try audioRecorder = AVAudioRecorder(url: soundFileURL!, settings: recordSettings as [String : AnyObject])
				audioRecorder?.prepareToRecord()
			}catch let error as NSError{
				NSLog("audioSession error: \(error.localizedDescription)", 0)
			}

			recordAudio()
            
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        back()
    }
	
    @IBAction func sendButton(_ sender: UIButton) {
        
    }
    func back() {
        present(alertView(), animated: true, completion: nil)
    }
    
	func recognizeFile(url: URL){
	
		guard let myRecognizer = SFSpeechRecognizer() else {
			// A recognizer is not supported for the current locale
			NSLog("A recognizer is not support for the current locale", 0)
			return
		}
		if !myRecognizer.isAvailable {
			// The recognizer is not available right now
			return
		}
		let request = SFSpeechURLRecognitionRequest(url: url)
		
		myRecognizer.recognitionTask(with: request) { (result, error) in
			
			guard let result = result else {
				// Recognition failed, so check error for details and handle it
				NSLog("No word's can be recognized.", 0)
				self.textFromRegistration = "No word's recognized."
				NSLog("URL file: \(String(describing: self.soundFileURL))", 0)
				return
			}
			if result.isFinal {
				// Print the speech that has been recognized so far
				self.textFromRegistration = result.bestTranscription.formattedString
				
				NSLog("Speech text is -> \(self.textFromRegistration)", 0)
				NSLog("URL file: \(String(describing: self.soundFileURL))", 0)
				
				
			}
		}
		
		return
	}

    
	func recordAudio() {
		
		if audioRecorder?.isRecording == false{
			audioRecorder?.record()
			NSLog("Audio is recording", 0)
			progressView.setProgress(0, animated: true)
			
//			var timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
			
//			var progress : Float = 0.1
			
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
                self.stopAudioRecording()
			}
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()){
				self.updateProgressBar()
			}
			
		}
		
	}
	
	func updateProgressBar(){
		var progress : Float = 0
		for _ in 0..<10{
			progress = progress + 0.1
			NSLog("update prgress view", 0)
			DispatchQueue.main.async {
				self.progressView.setProgress(progress, animated: true)
			}
			sleep(1)
		}
	}
	
	func stopAudioRecording() {
		
		if audioRecorder?.isRecording == true {
			audioRecorder?.stop()
			recognizeFile(url: soundFileURL!)
		}
		//else {
		//	audioPlayer?.stop()
		//}
	}
	
	func stopAudioRecording(_ sender: UIButton) {
		
		if audioRecorder?.isRecording == true {
			audioRecorder?.stop()
			recognizeFile(url: soundFileURL!)
		}
		//else {
		//	audioPlayer?.stop()
		//}
	}


	func playAudio(_ sender: UIButton) {
		if audioRecorder?.isRecording == false {
			do {
				try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
				audioPlayer!.delegate = self
				audioPlayer!.prepareToPlay()
				audioPlayer!.play()
			}catch let error as NSError{
				NSLog("audioPlayer error: \(error.localizedDescription)", 0)
			}
		}
	}
	
	func playAudio() {
		if audioRecorder?.isRecording == false {
			do {
				try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
				audioPlayer!.delegate = self
				audioPlayer!.prepareToPlay()
				audioPlayer!.play()
			}catch let error as NSError{
				NSLog("audioPlayer error: \(error.localizedDescription)", 0)
			}
		}
	}

	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		NSLog("Audio did finish playing", 0)
	}
	
	func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
		NSLog("Audio play decode error", 0)
	}
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        NSLog("Audio finish recording", 0)
	}
	
	
	func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
		NSLog("Audio record encode error", 0)
	}
	
	
    func alertView() -> UIAlertController {
        let alert = UIAlertController(title: "Cancel", message: "Would you like to go back?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            guard (self.navigationController?.popViewController(animated: true)) != nil else {
                NSLog("View non caricata")
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let reportViewControler = sb.instantiateViewController(withIdentifier: "mainView")
                return self.present(reportViewControler, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
    }
	
	
	
	
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
