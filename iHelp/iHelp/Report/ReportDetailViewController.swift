//
//  ReportDetailViewController.swift
//  iHelp
//
//  Created by Tortora Roberto on 17/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class ReportDetailViewController: UITableViewController {

	@IBOutlet weak var progressViewAudioPlayed: UIProgressView!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        nameField.text = currentReport.name
        surnameField.text = currentReport.surname
        messageField.text = currentReport.message
        phoneNumberField.text = currentReport.phoneNumber
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func playAudio(_ sender: UIButton) {
		DispatchQueue.global().async {
			guard let url = self.currentReport.audioMessage?.fileURL else {
				print("error")
				return
			}
			
			do {
				try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
				try AVAudioSession.sharedInstance().setActive(true)
				NSLog("\nplay audio ricevuto...\n")
				
				self.player = try AVAudioPlayer(contentsOf: url)
				guard let player = self.player else { return }
				
				player.play()
				
				var progress : Float = 0
				for _ in 0..<10{
					progress = progress + 0.1
					NSLog("\(progress)")
					DispatchQueue.main.async {
						self.progressViewAudioPlayed.setProgress(progress, animated: true)
					}
					if self.progressViewAudioPlayed.progress != 1{
						sleep(UInt32(1))
					}
				}
				self.progressViewAudioPlayed.setProgress(0, animated: false)
				
			} catch let error {
				print(error.localizedDescription)
			}

		}
		
	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "show"? :
            NSLog(segue.destination.nibName!)
            NSLog(segue.destination.description)
            if (segue.destination.description.contains("MapViewController")) {
                let dstView = segue.destination as! MapViewController
                dstView.latitudine2 = currentReport.latitude!
                dstView.longitudine2 = currentReport.longitute!
                
            } else {
                let dstView = segue.destination as! ReportClinicalFolderViewController
                dstView.currentReport = currentReport
            }
        default :
            NSLog(segue.destination.nibName!)
            NSLog(segue.destination.description)
            if (segue.destination.description.contains("MapViewController")) {
                let dstView = segue.destination as! MapViewController
                dstView.latitudine2 = currentReport.latitude!
                dstView.longitudine2 = currentReport.longitute!
            } else {
                let dstView = segue.destination as! ReportClinicalFolderViewController
                dstView.currentReport = currentReport
            }
        }
    }
    
    
    @IBOutlet weak var progressAudioBar: UIProgressView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var surnameField: UILabel!
    @IBOutlet weak var messageField: UILabel!
    @IBOutlet weak var phoneNumberField: UILabel!
    
    var player: AVAudioPlayer?
    var currentReport: Report!
}
