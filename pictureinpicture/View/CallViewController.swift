//
//  CallViewController.swift
//  Picture-In-Picture
//
//  Created by Chayan on 26/11/24.
//

import UIKit

class CallViewController: UIViewController {

    @IBOutlet var layProfile: UIView!
    @IBOutlet var callState: UILabel!
    @IBOutlet var controls: UIView!
    @IBOutlet var minimizeButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var switchCameraButton: UIButton!
    @IBOutlet var endButton: UIButton!
    @IBOutlet var remoteVideoView: UIView!
    @IBOutlet var localVideoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUi()
    }

    // MARK: UI functions

    private func initializeUi() {
        // Buttons
        let buttonStack = [muteButton,
                           cameraButton,
                           switchCameraButton]
        
        for button in buttonStack {
            let normalButtonImage = button?.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
            let selectedButtonImage = button?.image(for: .selected)?.withRenderingMode(.alwaysTemplate)
            button?.setImage(normalButtonImage, for: .normal)
            button?.setImage(selectedButtonImage, for: .selected)
            button?.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            button?.tintColor = .white
        }
        
        // Set scale type for hang-off
        endButton?.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        
        // Apply ronded corner to Local Video View
        localVideoView.backgroundColor = .black
        localVideoView.layer.cornerRadius = 9.0
        localVideoView.layer.masksToBounds = true
        localVideoView.layer.zPosition = 1;
        
        PictureInPictureManager.shared.delegate = self
        PictureInPictureManager.shared.setupPip(sourceView: view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleHomePressEvent), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func handleHomePressEvent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            if PictureInPictureManager.shared.callVC == nil,
                PictureInPictureManager.shared.isActive {
                PictureInPictureManager.shared.callVC = self
                self.dismiss(animated: false)
            }
        }
    }
    
    // MARK: Button Click Event
    
    @IBAction func minimizeButtonClicked(_: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            PictureInPictureManager.shared.startPip()
            PictureInPictureManager.shared.callVC = self
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func endButtonClicked(_: UIButton) {
        self.endMeeting()
    }
    
    private func endMeeting() {
        DispatchQueue.main.async {
            self.callState.text = "Call Ended"
            self.layProfile.isHidden = false
            self.minimizeButton.isHidden = true
            self.remoteVideoView.isHidden = true
            self.localVideoView.isHidden = true
            self.controls.isHidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800)) {
            PictureInPictureManager.shared.callVC = nil
            PictureInPictureManager.shared.destroy()
            CallInvitationService.shared().dismissCallView()
        }
    }
}


// MARK: PiPObserver

extension CallViewController: PictureInPictureManagerDelegate {
    func willStopPictureInPicture() {
        if let meetingVC = PictureInPictureManager.shared.callVC,
           PictureInPictureManager.shared.isActive
        {
            PictureInPictureManager.shared.stopPiP()
            currentViewController()?.present(meetingVC, animated: false)
            PictureInPictureManager.shared.callVC = nil
        }
    }
}
