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


	
	    override func viewDidLoad() {
        super.viewDidLoad()
			// Do any additional setup after loading the view.
            
            self.navigationItem.hidesBackButton = true
            let newBackButton : UIBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = newBackButton
            
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
				return
			}
			if result.isFinal {
				// Print the speech that has been recognized so far
				self.textFromRegistration = result.bestTranscription.formattedString
				NSLog("Il testo pronunciato è -> \(self.textFromRegistration)", 0)
			}
		}
		
		return
	}

    
	@IBAction func recordAudio(_ sender: UIButton) {
		if audioRecorder?.isRecording == false{
			audioRecorder?.record()
		}
	}
	
	@IBAction func stopAudio(_ sender: UIButton) {
		
		if audioRecorder?.isRecording == true {
			audioRecorder?.stop()
			recognizeFile(url: soundFileURL!)
		}else {
			audioPlayer?.stop()
		}
	}
	
	@IBAction func playAudio(_ sender: UIButton) {
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
                NSLog("View non caricaca")
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
