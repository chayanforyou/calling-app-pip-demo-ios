//
//  CallDefines.swift
//  Picture-In-Picture
//
//  Created by Chayan on 26/11/24.
//

import Foundation
import UIKit

func currentViewController() -> UIViewController? {
    let window: UIWindow?
    if #available(iOS 13.0, *) {
        window = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first { $0.isKeyWindow }
    } else {
        window = UIApplication.shared.keyWindow
    }
    
    let vc = window?.rootViewController
    return currentViewController(vc)
}

func currentViewController(_ vc :UIViewController?) -> UIViewController? {
   if vc == nil {
      return nil
   }
   if let presentVC = vc?.presentedViewController {
      return currentViewController(presentVC)
   }
   else if let tabVC = vc as? UITabBarController {
      if let selectVC = tabVC.selectedViewController {
          return currentViewController(selectVC)
       }
       return nil
    }
    else if let naiVC = vc as? UINavigationController {
       return currentViewController(naiVC.visibleViewController)
    }
    else {
       return vc
    }
 }
