

import UIKit

private let FIELD_CELL = "fieldCell"
private let SPACE_TOMOVE: CGFloat = 20
private let ANIMATION_TIME: Double = 4

class DettaglioCalendarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
	
	@IBOutlet var height2ToHide: NSLayoutConstraint!
	
	@IBOutlet var viewBehindArrow: UIView!
	@IBOutlet var dayView: CustomDayView!
	@IBOutlet var afterULbl: UILabel!
	@IBOutlet var afterELbl: UILabel!
	@IBOutlet var mornULbl: UILabel!
	@IBOutlet var mornELbl: UILabel!
	@IBOutlet var modLbl: UILabel!
	@IBOutlet var weekdayLbl: UILabel!
	@IBOutlet var dayLbl: UILabel!
	@IBOutlet var table: UITableView!
	@IBOutlet var dot: UIImageView!
	@IBOutlet var arrowView: UIImageView!
	@IBOutlet var viewToHide: UIView!
	@IBOutlet var stack: UIStackView!
	
	var day: WorkDay?
	var isCollapsed = true
	var preHeightFirstView: CGFloat = 230
	var preHeightSecondView: CGFloat = 220
	var originSaved = CGPoint(x: 0,y: 278)
	var originTable = CGPoint(x: 0,y: 363)
	var cellDelegate: CellChangerDelegate?
	var timer: Timer?
	var upDirection = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.table.delegate = self
		self.table.dataSource = self
        table.rowHeight = UITableView.automaticDimension
		
		let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swiped(sender:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped(sender:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
		viewBehindArrow.addGestureRecognizer(swipeDown)
		viewBehindArrow.addGestureRecognizer(swipeUp)
	}
	

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setLabels()
		isCollapsed = true
	}
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		stopTimer()
	}
	
	func setLabels() {
		if day != nil {
			
			dayLbl.text = String(day!.number!)
			weekdayLbl.text = day!.descr!
			modLbl.text = day!.mod!
			mornELbl.text = day!.morningE!
			mornULbl.text = day!.morningU!
			afterELbl.text = day!.afterE!
			afterULbl.text = day!.afterU!
			dot.image = day!.descr! == "D" ? #imageLiteral(resourceName: "redDot") : #imageLiteral(resourceName: "Green dot")
			
		}
		if #available(iOS 10.0, *) {
			handleTimer()
		}
	}
	
	private func moveDown(view: UIView) {
		UIView.animate(withDuration: 0.1, delay: 0, animations: {
			view.center.y = view.center.y + SPACE_TOMOVE
			
		}, completion: {(_) in
			
			UIView.animateKeyframes(withDuration: 0.1, delay: 0, animations: {
				view.center.y = view.center.y - SPACE_TOMOVE
				
			}, completion: {(_) in
				
				UIView.animate(withDuration: 0.1, delay: 0, animations: {
					view.center.y = view.center.y + SPACE_TOMOVE
					
				}, completion: {(_) in
					
					UIView.animateKeyframes(withDuration: 0.1, delay: 0, animations: {
						view.center.y = view.center.y - SPACE_TOMOVE
						
					}, completion: nil)
				})
			})
		})
	}
	
	private func moveUp(view: UIView) {
		UIView.animate(withDuration: 0.1, delay: 0, animations: {
			view.center.y = view.center.y - SPACE_TOMOVE
			
		}, completion: {(_) in
			
			UIView.animateKeyframes(withDuration: 0.1, delay: 0, animations: {
				view.center.y = view.center.y + SPACE_TOMOVE
				
			}, completion: {(_) in
				
				UIView.animate(withDuration: 0.1, delay: 0, animations: {
					view.center.y = view.center.y - SPACE_TOMOVE
					
				}, completion: {(_) in
					
					UIView.animateKeyframes(withDuration: 0.1, delay: 0, animations: {
						view.center.y = view.center.y + SPACE_TOMOVE
						
					}, completion: nil)
				})
			})
		})
	}
	
	@available(iOS 10.0, *)
	func handleTimer() {
		DispatchQueue.main.async {
			self.timer = Timer.scheduledTimer(
				withTimeInterval: ANIMATION_TIME,
				repeats: true,
				block: { (timer) in
					if !self.upDirection {
						self.moveDown(view: self.arrowView)
					} else {
						self.moveUp(view: self.arrowView)
					}
			})
		}
	}
	
	func stopTimer() {
		if timer != nil {
			if timer!.isValid {
				self.timer?.invalidate()
			}
		}
	}
	
    @objc func swiped(sender: UIGestureRecognizer) {
		if let gesture = sender as? UISwipeGestureRecognizer {
			UIView.animate(withDuration: 0.3, animations: {
				switch gesture.direction {
					
				case .up:
					self.stopTimer() //stoppo il timer per evitare collisioni e dopo l'animazione lo ristarto
					if !self.isCollapsed {
						self.viewToHide.frame.size.height = 0
						self.dayView.frame.size.height = 0
						self.viewBehindArrow.frame.origin = CGPoint(x: self.viewBehindArrow.frame.origin.x, y: self.viewToHide.frame.origin.y)
						self.table.frame.origin = CGPoint(x: self.table.frame.origin.x, y: self.viewToHide.frame.origin.y + self.viewBehindArrow.frame.height)
						self.isCollapsed = true
					}
					
				case .down:
					self.stopTimer() //stoppo il timer per evitare collisioni e dopo l'animazione lo ristarto
					if self.isCollapsed {
						self.viewToHide.frame.size.height = self.preHeightFirstView
						self.dayView.frame.size.height = self.preHeightSecondView
						self.viewBehindArrow.frame.origin = self.originSaved
						self.table.frame.origin = self.originTable
						self.isCollapsed = false
					}
					
				default:
					break
				}
			}) { (_) in
				UIView.animate(withDuration: 0.2, animations: {
					switch gesture.direction  {
					case .up:
						
						self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
						self.upDirection = false
					case .down:
						
						self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
						self.upDirection = true
					default: break
					}
				}, completion: { _ in
					if #available(iOS 10.0, *) {
						self.handleTimer()
					}
				})
			}
		}
		cellDelegate?.changeCell(bool: !isCollapsed) //metodo per il colore della cella selected
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return WorkDay.getArrayFields().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FIELD_CELL, for: indexPath) as! FieldTableViewCell
		cell.initialize(descr: WorkDay.getArrayFields()[indexPath.row], row: indexPath.row, day: day!)
		return cell
	}


}
protocol CellChangerDelegate {
	func changeCell(bool: Bool) 
}
