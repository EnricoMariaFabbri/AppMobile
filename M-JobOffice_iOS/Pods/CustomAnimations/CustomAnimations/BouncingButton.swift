

import Foundation
import UIKit
public class BouncingButton : UIButton {
	private var bouncingButton : UIButton?
	
	override public func awakeFromNib() {
		//Other settings...
	}
	public func intialize (button : UIButton){
		bouncingButton = button
	}
	
	public func Bounce (){
		let bounds = bouncingButton!.bounds
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
			self.bouncingButton!.bounds = CGRect(x: bounds.origin.x - 10  , y: bounds.origin.y - 10, width: bounds.size.width + 20, height: bounds.size.height + 20)
		}, completion: {(success:Bool) in
			if success {
				UIView.animate(withDuration: 0.5, animations: {
					self.bouncingButton!.bounds = bounds
				})
			}
		})

	}
	
	/* Utilizzo : 
     * 1 -> Assegnare classe al bottone interessato da storyboard.
     * 2 -> Richiamare l'initialize mediante il bottone e, come parametro, passare il medesimo bottone.
     * 3 -> Richiamare il metodo Bounce() ogni volta che si vuole visualizzare l'animazione.
    */
	
	
	
	
	
}


