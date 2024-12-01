//
//  CallInvitationService.swift
//  Picture-In-Picture
//
//  Created by Chayan on 26/11/24.
//

import Foundation
import UIKit

class CallInvitationService {
    
    private static var sharedInstance: CallInvitationService?
    private let storyboard = UIStoryboard(name: "CallScreen", bundle: nil)
    
    weak var callVC: UIViewController?
    
    static func shared() -> CallInvitationService {
        if sharedInstance == nil {
            sharedInstance = CallInvitationService()
        }
        return sharedInstance!
    }

    func showCallView() {
        guard let vc = storyboard.instantiateViewController(withIdentifier: "callVC") as? CallViewController else {
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        currentViewController()?.present(vc, animated: true, completion: nil)
        self.callVC = vc
    }

    func dismissCallView() {
        guard let callVC = callVC else {
            return
        }
        callVC.dismiss(animated: true, completion: nil)
        self.callVC = nil
    }
}
