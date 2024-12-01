//
//  PictureInPictureManager.swift
//  Picture-In-Picture
//
//  Created by Chayan on 26/11/24.
//

import UIKit
import AVFoundation
import AVKit

protocol PictureInPictureManagerDelegate: AnyObject {
    func willStartPictureInPicture()
    func willStopPictureInPicture()
}

extension PictureInPictureManagerDelegate {
    func willStartPictureInPicture() {}
    func willStopPictureInPicture() {}
}

class PictureInPictureManager: NSObject {
    
    var isActive: Bool {
        get {
            return pipVC?.isPictureInPictureActive ?? false
        }
    }
    
    var callVC: CallViewController?
    var pipVC: AVPictureInPictureController?
    var pipView: VideoPipView?
    weak var delegate: PictureInPictureManagerDelegate?
    
    static let shared = PictureInPictureManager()
    
    
    func setupPip(sourceView: UIView) {
        if let _ = pipVC {
            destroy()
        }
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            let callViewController = AVPictureInPictureVideoCallViewController();
            callViewController.preferredContentSize = CGSize(width: 9, height: 16)
            
            let pipContentSource = AVPictureInPictureController.ContentSource(activeVideoCallSourceView: sourceView, contentViewController: callViewController)
            
            let pipController = AVPictureInPictureController(contentSource: pipContentSource)
            pipController.canStartPictureInPictureAutomaticallyFromInline = true
            pipController.delegate = self
            pipVC = pipController
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        }
    }
    
    @objc func handleNotification(notification : NSNotification) {
        if notification.name == UIApplication.didBecomeActiveNotification {
            pipView?.isEnablePreview = true
            if !isActive {
                stopPiP()
            }
        } else if notification.name == UIApplication.didEnterBackgroundNotification {
            pipView?.isEnablePreview = false
        }
    }
    
    func startPIPWithView(view: UIView) {
        if let pipView = self.pipView {
            pipView.removeFromSuperview()
            self.pipView = nil
        }
        self.pipView = VideoPipView()
        view.addSubview(self.pipView!)
        self.pipView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pipView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.pipView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.pipView!.topAnchor.constraint(equalTo: view.topAnchor),
            self.pipView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func stopPiP() {
        if AVPictureInPictureController.isPictureInPictureSupported() {
            guard let pipVC = pipVC else { return }
            if pipVC.isPictureInPictureActive {
                pipVC.stopPictureInPicture()
            }
        }
    }
    
    func startPip() {
        if AVPictureInPictureController.isPictureInPictureSupported() {
            guard let pipVC = pipVC else { return }
            pipVC.startPictureInPicture()
        }
    }
    
    func destroy() {
        if AVPictureInPictureController.isPictureInPictureSupported() {
            stopPiP()
            pipVC?.contentSource = nil
            pipVC = nil
        }
    }
}

extension PictureInPictureManager: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        if AVPictureInPictureController.isPictureInPictureSupported() {
            let vc: AVPictureInPictureVideoCallViewController? = pictureInPictureController.contentSource?.activeVideoCallContentViewController
            guard let vc = vc else { return }
            startPIPWithView(view: vc.view)
        }
        delegate?.willStartPictureInPicture()
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        debugPrint("pictureInPictureControllerDidStartPictureInPicture")
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        delegate?.willStopPictureInPicture()
        debugPrint("pictureInPictureControllerWillStopPictureInPicture")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        debugPrint("pictureInPictureControllerDidStopPictureInPicture")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        debugPrint("failedToStartPictureInPictureWithError")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        debugPrint("restoreUserInterfaceForPictureInPictureStopWithCompletionHandler")
        completionHandler(true)
    }
}

