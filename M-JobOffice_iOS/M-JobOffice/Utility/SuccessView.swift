//
//  SuccessView.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 30/10/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit

private let _shared = SuccessView()

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


class SuccessView: UIView {
	
	@IBOutlet weak var icon: UIImageView!
	
	var sview : SuccessView!
	var  background : UIView!
	
	class var shared: SuccessView {
		return _shared
	}

	
	static func show(onViewController viewController : UIViewController, isSucces : Bool){
		SuccessView.shared.show(onViewController: viewController, isSuccess: isSucces)
	}
	
    
    
    
	func show(onViewController viewController : UIViewController, isSuccess : Bool){
		
		sview = SuccessView.getNib(by: viewController)
		sview.layer.cornerRadius = 15
		
        //TODO finisci di mettere a posto icon
        if !isSuccess{
            self.icon.image = #imageLiteral(resourceName: "negative")
		}
        
		sview.center = viewController.view.center

		background = UIView()
		background.frame = viewController.view.frame
		background.backgroundColor = UIColor.black.withAlphaComponent(0.7)
		
		background.addSubview(sview)
		viewController.view.addSubview(background)
		
		background.alpha = 0
		sview.alpha = 0
		
		UIView.animate(withDuration: 0.4) {
			self.background.alpha = 1
			self.sview.alpha = 1
		}
	}
	
	func hide(){
		
		UIView.animate(withDuration: 0.3, animations: {
			self.background.alpha = 0
			self.sview.alpha = 0
		}) { (_) in
			self.background.removeFromSuperview()
			self.sview.removeFromSuperview()
		}
		
	}
	
	@IBAction func hideModal(_ sender: UIButton) {
		SuccessView.shared.hide()
	}
	
	static func getNib(by viewController : UIViewController) -> SuccessView{
		let nib = UINib(nibName: "SuccessView", bundle: nil).instantiate(withOwner: viewController, options: nil)[0] as! SuccessView
		return nib
	}
}
