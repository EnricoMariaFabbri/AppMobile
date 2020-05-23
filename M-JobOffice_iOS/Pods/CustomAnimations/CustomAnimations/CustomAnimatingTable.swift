

import Foundation
import UIKit

public class CustomAnimatingTable : UITableView{
	
	private var animatedTable : UITableView?
	
	override public func awakeFromNib() {
		//Other settings...
	}
	public func intialize (tableView : UITableView){
		animatedTable = tableView
	}
	
	
	public func AnimateTable(){
		animatedTable!.reloadData()
		let cells = animatedTable!.visibleCells
		let tableViewHeight = animatedTable!.bounds.size.height
		for cell in cells{
			cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
		}
		var delayCounter = 0
		for cell in cells{
			UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
				cell.transform = CGAffineTransform.identity
			}, completion: nil)
			delayCounter += 1
		}

	}
	
	/* Utilizzo :
	* 1 -> Assegnare classe alla table interessata da storyboard.
	* 2 -> Richiamare l'initialize mediante la table e, come parametro, passare la medesima table.
	* 3 -> Richiamare il metodo Bounce() ogni volta che si vuole visualizzare l'animazione (ad esempio nel ViewDidAppear()).
	*/
	
	//NOTA : Se ci si trova in UITableViewController non è possibile assegnare tale classe alla tableView di defualt, dunque sarà necessario copiare e incollare il metodo AnimatedTable() all'interno della classe e richiamarlo quando si desidera
	

}
