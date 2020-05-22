//
//  UIImagePickerController+SupportedOrientations.swift
//  AppSegreteria
//
//  Created by Sama Alessandro on 24/10/16.
//  Copyright © 2016 Sama Alessandro. All rights reserved.
//

import UIKit

extension UIImagePickerController
{
	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		if IS_IPAD {
			return .landscape
		} else {
			return .portrait
		}
	}
    override open var shouldAutorotate: Bool{
        return true
    }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        if IS_IPAD {
		
			if UIApplication.shared.statusBarOrientation == .landscapeLeft{
				return .landscapeLeft
			}
			else if UIApplication.shared.statusBarOrientation == .landscapeRight{
				return .landscapeRight
			}
			
			return.unknown
		} else {
            return .portrait
        }
    }
}


