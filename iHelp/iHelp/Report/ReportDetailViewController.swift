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
            guard let url = currentReport.audioMessage?.fileURL else {
                print("error")
                return
            }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                player = try AVAudioPlayer(contentsOf: url)
                guard let player = player else { return }
                
                player.play()
            } catch let error {
                print(error.localizedDescription)
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
