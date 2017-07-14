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
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var labelTestoTradotto: UILabel!
	
	    override func viewDidLoad() {
        super.viewDidLoad()
			// Do any additional setup after loading the view.
			
			askSpeechPermission()
			
			playButton.isEnabled = false
			stopButton.isEnabled = false
			
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
				return
			}
			if result.isFinal {
				// Print the speech that has been recognized so far
				self.textFromRegistration = result.bestTranscription.formattedString
				
				self.labelTestoTradotto.text = self.textFromRegistration
				self.labelTestoTradotto.sizeToFit()
				NSLog("Il testo pronunciato è -> \(self.textFromRegistration)", 0)
			}
		}
		
		return
	}
	
	func askSpeechPermission(){
		//richesta autorizzazione al riconoscimento del messaggio vocale
		SFSpeechRecognizer.requestAuthorization { status in
			/* The callback may not be called on the main thread. Add an
			operation to the main queue to update the record button's state.
			*/
			OperationQueue.main.addOperation {
				switch status {
				case .authorized:
					self.recordButton.isEnabled = true
				case .denied:
					self.recordButton.isEnabled = false
					self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
				case .restricted:
					self.recordButton.isEnabled = false
					self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
				case .notDetermined:
					self.recordButton.isEnabled = false
					self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
				}
			}
		}
	}
	@IBAction func recordAudio(_ sender: UIButton) {
		if audioRecorder?.isRecording == false{
			playButton.isEnabled = false
			stopButton.isEnabled = true
			audioRecorder?.record()
			
		}
	}
	
	@IBAction func stopAudio(_ sender: UIButton) {
		stopButton.isEnabled = false
		playButton.isEnabled = true
		recordButton.isEnabled = true
		
		if audioRecorder?.isRecording == true {
			audioRecorder?.stop()
			recognizeFile(url: soundFileURL!)
			
			
		}else {
			audioPlayer?.stop()
		}
	}
	
	@IBAction func playAudio(_ sender: UIButton) {
		if audioRecorder?.isRecording == false {
			stopButton.isEnabled = true
			recordButton.isEnabled = false
			
			
			
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
		recordButton.isEnabled = true
		stopButton.isEnabled = false
		NSLog("Audio did finish playing", 0)
	}
	
	func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
		NSLog("Audio play decode error", 0)
	}
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		recordButton.setTitle("Record again", for: .normal)
		NSLog("Audio finish recording", 0)
	}
	
	
	func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
		NSLog("Audio record encode error", 0)
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
