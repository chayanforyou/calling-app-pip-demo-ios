//
//  ViewController.swift
//  Picture-In-Picture
//
//  Created by Chayan on 26/11/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var callButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func callButtonClicked(_: UIButton) {
        if PictureInPictureManager.shared.isActive {
            PictureInPictureManager.shared.stopPiP()
        } else {
            CallInvitationService.shared().showCallView()
        }
    }
}

