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
import CloudKit
import CoreLocation
import MapKit

class SOSViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate {
    
	var audioPlayer: AVAudioPlayer?
	var audioRecorder: AVAudioRecorder?
	var soundFileURL: URL?
	var textFromRegistration : String = ""
    var heartRate: Double = 0.0
    let healthManager:HealthKitManager = HealthKitManager()
	@IBOutlet weak var progressView: UIProgressView!
	@IBOutlet weak var cancelButton: UIButton!
    
    //variabili localizzazione
    var locationManager = CLLocationManager()
    var altitudine2:CLLocationDistance = 0.0
    var velocita2:CLLocationSpeed = 0.0
    var latitudine2:CLLocationDegrees = 0.0
    var longitudine2:CLLocationDegrees = 0.0
	
    override func viewDidLoad() {
        super.viewDidLoad()
            // Do any additional setup after loading the view.
        
            DispatchQueue.main.async(execute: { () -> Void in
                self.runLocalizzazione()
                print("++++++++++++ \(self.latitudine2)")
                print("++++++++++++ \(self.longitudine2)")
            })
        
			//set radius cancelButton
			cancelButton.layer.masksToBounds = true
			cancelButton.layer.cornerRadius = 42
			cancelButton.contentEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
		
            self.navigationItem.hidesBackButton = true
            let newBackButton : UIBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = newBackButton
			let fileManager = FileManager.default
			
			let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
			
			soundFileURL = dirPaths[0].appendingPathComponent("recordedAudio.caf")
			
			let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
			                      AVEncoderBitRateKey: 8,
			                      AVNumberOfChannelsKey: 1,
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

			
			DispatchQueue.global().async {
				
				self.recordAudio()
				
			}
			
            
           
            DispatchQueue.global().async(execute: { () -> Void in
                self.heartRate = self.healthManager.getTodaysHeartRates()!
                print("\nbattito ricevutoooooooooo in SOS  \(self.heartRate)")
                
            })
            
            
            
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        back()
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
                print("++++++++++++ \(self.latitudine2)")
                print("++++++++++++ \(self.longitudine2)")
                CloudKitManager.saveReport(latitudine: 2, longitudine: 2, velocity: 33, audioMessage: self.soundFileURL!, message: self.textFromRegistration, heartRate: self.heartRate)
				return
			}
			if result.isFinal {
				// Print the speech that has been recognized so far
				self.textFromRegistration = result.bestTranscription.formattedString
                
				NSLog("Speech text is -> \(self.textFromRegistration)", 0)
				NSLog("URL file: \(String(describing: self.soundFileURL))", 0)
				
                    print("++++++++++++ \(self.latitudine2)")
                    print("++++++++++++ \(self.longitudine2)")
                    self.textFromRegistration = result.bestTranscription.formattedString

					CloudKitManager.saveReport(latitudine: self.latitudine2, longitudine: self.longitudine2, velocity: 33, audioMessage: self.soundFileURL!, message: self.textFromRegistration, heartRate: self.heartRate)
                
				
				
/*                self.runLocalizzazione()
                print("+++++++++++++2 \(self.getLatitudine())")
                print("+++++++++++++2 \(self.longitudine2)")
                CloudKitManager.saveReport(latitudine: Double(self.latitudine2), longitudine: Double(self.longitudine2), velocity: 33)
                
				NSLog("Speech text is -> \(self.textFromRegistration)", 0)
				NSLog("URL file: \(String(describing: self.soundFileURL))", 0)*/
 
			}
		}
		
		return
	}

    
	func recordAudio() {
		
		if audioRecorder?.isRecording == false{
			
				audioRecorder?.record()
			
			
			NSLog("Audio is recording", 0)
			progressView.setProgress(0, animated: true)

			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
				self.stopAudioRecording(saveParameter: true)
			}
			DispatchQueue.global().async {
				var progress : Float = 0
				for _ in 0..<10{
					progress = progress + 0.1
					NSLog("update progress view", 0)
					DispatchQueue.main.async {
						self.progressView.setProgress(progress, animated: true)
					}
					sleep(1)
				}
			}
			
		}
		
	}
	
	func updateProgressBar(){
		var progress : Float = 0
		for _ in 0..<10{
			progress = progress + 0.1
			NSLog("update progress view", 0)
			DispatchQueue.main.async {
				self.progressView.setProgress(progress, animated: true)
			}
			sleep(1)
		}
	}
	
	func stopAudioRecording(saveParameter: Bool) {
		
		if saveParameter == true{
			if audioRecorder?.isRecording == true {
				audioRecorder?.stop()
				recognizeFile(url: soundFileURL!)
			}
			else if saveParameter == false{
				NSLog("DELETING RECORDING", 0)
				audioRecorder?.stop()
				audioRecorder?.deleteRecording()
			}
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

	func getAudioURL() -> URL{
	//	let audioAsset = CKAsset(fileURL: soundFileURL!)
			return self.soundFileURL!
	}
	
	func getRecognizedText() -> String{
		NSLog("Messaggio preso da SOSViewController ---> \(self.textFromRegistration)", 0)
		return self.textFromRegistration
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
			self.stopAudioRecording(saveParameter: false)
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
	
	
    func runLocalizzazione(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    /*
     geolocalizza la mappa su dove sei
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        
        //estraggo le informazioni
        let altitudine = userLocation.altitude
        let velocita = userLocation.speed
        let latitudine = userLocation.coordinate.latitude
        let longitudine = userLocation.coordinate.longitude
        
        self.setVelocita(velocita)
        self.setLongitudine(longitudine)
        self.setLatitudine(latitudine)
        locationManager.stopUpdatingLocation()
    }
    
    /*
     settaggio dei dati di locazione attuali (live)
     */
    func setLatitudine(_ lati: CLLocationDegrees){
        self.latitudine2 = lati

    }
    func setLongitudine(_ long: CLLocationDegrees){
        self.longitudine2 = long
    }
    func setVelocita(_ velo: CLLocationSpeed){
        self.velocita2 = velo
    }
    
   }
