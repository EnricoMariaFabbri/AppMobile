

import UIKit

class DatiFiscaliContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		add(viewController: datiFiscaliContainerIpad)
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBOutlet var viewContainer: UIView!
	
	private lazy var datiFiscaliContainerIpad: ContainerViewController = {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let container = storyboard.instantiateViewController(withIdentifier: "containerVC") as! ContainerViewController
		let left = storyboard.instantiateViewController(withIdentifier: "dati") as! DatiFiscaliViewController
		let right = storyboard.instantiateViewController(withIdentifier: "ComponenteNucleoViewController") as! ComponenteNucleoViewController
		let navigationDetail = UINavigationController(rootViewController: right)
		navigationDetail.isNavigationBarHidden = true
		container.initialize(withoutDrawer: left, detail : right)
		return container
	} ()
	
    func add(viewController: UIViewController, direction : UISwipeGestureRecognizer.Direction? = nil) {
        addChild(viewController)
		
		// Add Child View as Subview
		viewContainer.addSubview(viewController.view)
		// Configure Child View
		viewController.view.frame = viewContainer.bounds
		if direction != nil{
            if direction! == UISwipeGestureRecognizer.Direction.right {
				viewController.view.frame.origin.x = viewController.view.frame.origin.x - viewController.view.frame.size.width
				UIView.animate(withDuration: 0.4) {
					viewController.view.frame.origin.x = viewController.view.frame.origin.x + viewController.view.frame.size.width
				}
			} else {
				viewController.view.frame.origin.x = viewController.view.frame.origin.x + viewController.view.frame.size.width
				UIView.animate(withDuration: 0.4) {
					viewController.view.frame.origin.x = viewController.view.frame.origin.x - viewController.view.frame.size.width
				}
			}
			
		}
		
		viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		// Notify Child View Controller
        viewController.didMove(toParent: self)
	}
}
