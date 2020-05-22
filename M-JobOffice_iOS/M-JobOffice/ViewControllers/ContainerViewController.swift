//
//  ContainerViewController.swift
//  M-JobOffice
//
//  Created by Stage on 30/01/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit
import MMDrawerController

class ContainerViewController: UIViewController {
	
	@IBOutlet weak var containerView: UIView!
	
	var drawer : MMDrawerController?
	var master : UIViewController?
	var detail : UIViewController?
	var noDrawer = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	func initializeSplit(by drawer : MMDrawerController, and detail : UIViewController){
		self.drawer = drawer
		self.detail = detail
	}
	
	func initialize(withoutDrawer master : UIViewController, detail : UIViewController){
		noDrawer = true
		self.master = master
		self.detail = detail
		
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "segueSplit"{
			let splitVC = segue.destination as! CustomSplitViewController
			if noDrawer{
				splitVC.viewControllers = [master!,detail!]
			}else{
				splitVC.viewControllers = [drawer!,detail!]
			}
		}
		noDrawer = false
	}
}
