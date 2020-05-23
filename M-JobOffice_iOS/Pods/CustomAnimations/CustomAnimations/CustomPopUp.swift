

import UIKit
public class CustomPopUp: UIView {

	private var popUp : UIView?
	private var view : UIView?
	override public func awakeFromNib() {
		//Other settings...
	}
	public func intialize (popUp : UIView,on view : UIView){
		self.popUp = popUp
		self.view = view
	}
	public func AnimateIn(){
		view!.addSubview(popUp!)
		popUp!.center = view!.center
		
		popUp!.transform = CGAffineTransform.init(scaleX: 2, y: 2)
		popUp!.alpha = 0
		
		UIView.animate(withDuration: 0.4, animations: {
			self.popUp!.alpha = 1
			self.popUp!.transform = CGAffineTransform.identity
		})

	}
	public func animateOut() {
		UIView.animate(withDuration: 0.4, animations: {
			self.popUp!.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
			self.popUp!.alpha = 0
		 }
			, completion: {(success) in
				self.popUp!.removeFromSuperview()
		})
	}
	
	/* Utilizzo :
	* 1 -> Assegnare classe alla view interessata da storyboard.
	* 2 -> Richiamare l'initialize mediante la view e, come parametro, passare la medesima view e la view sulla quale il popUp animato comparirà
	* 3 -> Richiamare il metodo AnimateIn() ogni volta che si vuole visualizzare il popUp.
	* 4 -> Richiamare il metodo AnimateOut() ogni volta che si vuole nascondere il popUp.
	*/

	//NOTA : È possinile, inoltre, apportare tutte le modifiche volute (es : cornerRadius) come ad una normalissima view.

}
