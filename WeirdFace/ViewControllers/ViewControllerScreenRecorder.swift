//
//  ViewControllerScreenRecorder.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/25/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import ReplayKit

extension ViewController: RPPreviewViewControllerDelegate{
    
    //Start screen recording with replaykit and set buttons to appropriate icons
    func rpStartRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = true
        recorder.startRecording(withMicrophoneEnabled: true) { [unowned self] (error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                self.mainUIViewModel?.recording = true
                
                DispatchQueue.main.async {
                    self.stopRecordButton.isHidden = false
                    self.hideAllViewsAndButtonsForRecording()
                }
                
                
            }
        }
    }
    
    //Start screen recording with replaykit and set buttons to appropriate icons
    //Show preview window for user to decide to share/save/delete recording
    func rpStopRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = true
        recorder.stopRecording { [unowned self] (preview, error) in
            if let error = error {
                print("STOP REC ERROR")
                print(error.localizedDescription)
            } else {
                self.mainUIViewModel?.recording = false
                
                DispatchQueue.main.async {
                    self.restoreViewsAfterFinishedRecording()
                }
                
                if let unwrappedPreview = preview {
                    
                    unwrappedPreview.previewControllerDelegate = self
                    self.present(unwrappedPreview, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    //Dismiss preview view controller when user cancels/saves preview
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: {})
    }
    
    func hideAllViewsAndButtonsForRecording(){
        hideButtonsForSnapshot()
        hideSecondaryMenu()
        hideTattooSubMenus()
        hideImagePreview()
        resetButton.isHidden = true
        settingsButton.isHidden = true
        scrollMenu.isHidden = true
        modeSelectMenu.isHidden = true
    }
    
    func restoreViewsAfterFinishedRecording(){
        scrollMenu.isHidden = false
        resetButton.isHidden = false
        settingsButton.isHidden = false
        stopRecordButton.isHidden = true
    }
    
}

