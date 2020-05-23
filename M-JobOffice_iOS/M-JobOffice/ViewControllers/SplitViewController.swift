

import UIKit
import MMDrawerController

class CustomSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .allVisible
        self.maximumPrimaryColumnWidth = 400
		self.delegate = self

        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return true
	}
	
    
}
