
import UIKit

class CreditsViewController: UIViewController {


	@IBOutlet weak var txtEmail: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

		txtEmail.tintColor = UIColor(red:0.58, green:0.96, blue:0.30, alpha:1.00)
		txtEmail.isEditable = false
		txtEmail.dataDetectorTypes = .all
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
