//
//  CustomLayout.swift
//  M-JobOffice
//
//  Created by Stage on 22/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit

class CustomLayout: UICollectionViewFlowLayout {

	let cellsPerRow: Int
	let height: CGFloat
	
	init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, height: CGFloat, sectionInset: UIEdgeInsets = .zero) {
		self.cellsPerRow = cellsPerRow
		self.height = height
		super.init()
		
		self.minimumInteritemSpacing = minimumInteritemSpacing
		self.minimumLineSpacing = minimumLineSpacing
		self.sectionInset = sectionInset
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepare() {
		super.prepare()
		
		guard let collectionView = collectionView else { return }
		let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.contentInset.left  + collectionView.contentInset.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
		let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
		itemSize = CGSize(width: itemWidth, height: height)
	}
	
	override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
		let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
		context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
		return context
	}
}
