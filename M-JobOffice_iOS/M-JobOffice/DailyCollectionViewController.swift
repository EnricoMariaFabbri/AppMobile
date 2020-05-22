//
//  DailyCollectionViewController.swift
//  M-JobOffice
//
//  Created by Stage on 21/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit

private let DAILY_CELL_IDENTIFIER = "dailyCell"
private let DESCR_CELL_IDENTIFIER = "descriptionCell"
private let HEADER_CELL_IDENTIFIER = "headerCell"
private let GROUP_OF_ITEM = 3

class DailyCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CellChangerDelegate {
	

	var array: [WorkDay]?
	var selectedIndex: IndexPath?
	var countOfCell = 0
	let columnLayout = CustomLayout (
		cellsPerRow: GROUP_OF_ITEM,
		minimumInteritemSpacing: 10,
		minimumLineSpacing: 10,
		height: 220,
		sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
	)
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		collectionView?.collectionViewLayout = columnLayout
		array = getArray()
	}
	
	
//funzione di test
	func getArray() -> [WorkDay] {
		var array = [WorkDay]()
		for i in 0...30 {
			let day = WorkDay()
			day.number = i + 1
			day.descr = getDayNext()
			day.mod = "111111"
			day.morningE = "8"
			day.morningU = "13"
			day.afterE = "14"
			day.afterU = "17"
			day.oreDovute = 2
			day.oreEffettuate = 8
			day.oreDovute = 8
			day.oreEffettuate = 8
			day.debito = day.oreDovute! - day.oreEffettuate!
			day.ecc = "test"
			day.str = "test"
			day.turno = i
			day.giustificativi = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
			
			array.append(day)
		}
		return array
	}
	
	//func di test da cancellare poi
	var actualDay = 0
	var dayArray = ["L","Ma","Me","G","V","S","D"]
	func getDayNext() -> String { //makes infinite array, after D there is L
		var string = ""
		if actualDay <= dayArray.count - 1 {
			string = dayArray[actualDay]
			actualDay += 1
		} else {
			actualDay = 1
			return dayArray[0]
		}
		return string
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	func changeCell(bool: Bool) {
		let cell = (self.collectionView?.cellForItem(at: self.selectedIndex!) as? DailyCollectionViewCell)
		UIView.animate(withDuration: 0.3) {
			cell?.isSelected = !bool
		}
		
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DAILY_CELL_IDENTIFIER, for: indexPath) as! DailyCollectionViewCell
		cell.initialize(day: array![indexPath.row])
		return cell
    }
	
    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		
		if array![indexPath.row].descr != "D" {
			let vc = storyboard?.instantiateViewController(withIdentifier: "dettaglioCalendario") as! DettaglioCalendarioViewController
			vc.day = self.array![indexPath.row]
		
//			if selectedIndex != nil {
//				collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = #colorLiteral(red: 0.353084445, green: 0.6340804696, blue: 0.167444855, alpha: 1)
//				(collectionView.cellForItem(at: indexPath) as? DailyCollectionViewCell)?.greenDot.image = #imageLiteral(resourceName: "whiteDot")
//			}
//
			selectedIndex = indexPath
			
//			UIView.animate(withDuration: 0.2, animations: {
//				collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = #colorLiteral(red: 0.353084445, green: 0.6340804696, blue: 0.167444855, alpha: 1)
//				(collectionView.cellForItem(at: indexPath) as? DailyCollectionViewCell)?.greenDot.image = #imageLiteral(resourceName: "whiteDot")
//			})
			vc.cellDelegate = self
			presentDetailAnimated(vc: vc)
		} else {
			collectionView.cellForItem(at: indexPath)?.shake()
		}
	}

	private func presentDetailAnimated(vc: DettaglioCalendarioViewController) {
		
		UIView.animate(withDuration: 0.1, animations: {
			self.mm_drawerController.showDetailViewController(vc, sender: nil)
			
		}, completion: { (_) in
			
			UIView.animate(withDuration: 0.1, delay: 0, animations: {
				vc.arrowView.center.y = vc.arrowView.center.y + 30
				
			}, completion: {(_) in
				
				UIView.animateKeyframes(withDuration: 0.1, delay: 0, animations: {
					vc.arrowView.center.y = vc.arrowView.center.y - 30
					
				}, completion: {(_) in
					
					UIView.animate(withDuration: 0.1, delay: 0, animations: {
						vc.arrowView.center.y = vc.arrowView.center.y + 30
						
					}, completion: {(_) in
						
						UIView.animateKeyframes(withDuration: 0.1, delay: 0, animations: {
							vc.arrowView.center.y = vc.arrowView.center.y - 30
							
						}, completion: nil)
					})
				})
			})
		})
	}
	
	override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
		return true
	}
}
