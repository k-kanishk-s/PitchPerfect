//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Singh, Kanishk on 6/25/16.
//  Copyright © 2016 Singh, Kanishk. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var audioRecorder:AVAudioRecorder!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        stopRecordingButton.enabled = false
    }
    
    
    @IBAction func recordAudio(sender: AnyObject) {
        print("A button was pressed")
        setUIState(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordedName = "recordedVoice.wav"
        let pathArray = [dirPath, recordedName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        print("Done recording")
        setUIState(false)
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }

    func setUIState(isRecording: Bool) {
        recordingLabel.text = isRecording ? "Recording" : "Tap to record"
        recordButton.enabled = !isRecording
        stopRecordingButton.enabled = isRecording
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished recording")
        if (flag) {
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving failed")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

