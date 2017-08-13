//
//  LastBroadcastsDataSource.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import Foundation
import UIKit
import ReSwift
import RealmSwift
import Nuke
import Timepiece

protocol LastBroadcastsDelegate: class {
    func navigateTo(broadcast: BroadcastStore)
}

class LastBroadcastsDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override init() {
        super.init()
        
        store.subscribe(self) { subcription in
            subcription.select { state in state.dashboardState.lastBroadcasts }
        }
    }
    
    weak var delegate: LastBroadcastsDelegate? = nil
    
    var elementsToDisplay: Results<BroadcastStore>? = nil
    
    weak var collectionView: UICollectionView? = nil {
        didSet{
            configurePagedLayout()
        }
    }
    
    var itemWidth: CGFloat = 0
    var itemHeight: CGFloat = 0
    var itemSpacing: CGFloat = 8
    var collectionMargin:CGFloat = 16
    var currentPage = 0
    
    func configurePagedLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2.0
        itemHeight = itemWidth / 16 * 9 + 64
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        
        collectionView!.collectionViewLayout = layout
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func reloadData() {
        collectionView?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elementsToDisplay?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : LastBroadcastCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastBroadcastCell", for: indexPath) as! LastBroadcastCell

        let broadcast = elementsToDisplay?[indexPath.item]
        
        cell.broadcastTitleLabel.text = broadcast?.title
        cell.createTimeLabel.text = broadcast?.startDate.timeString(in: .short)
        
        cell.broadcastImage.image = nil
        
        let imageUrlString = broadcast?.placeholderImageUrlString ?? broadcast?.show.first?.placeholderImageUrlString
        
        if  let imageUrlString = imageUrlString,
            let imageUrl = URL(string: imageUrlString) {
            Nuke.loadImage(with: imageUrl, into: cell.broadcastImage)
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.height)
    }
    
  
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(itemWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView!.contentSize.width  )
        var newPage = Float(0)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? currentPage + 1 : currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        currentPage = Int(newPage)
        
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let broadcast = elementsToDisplay?[indexPath.item] {
            delegate?.navigateTo(broadcast: broadcast)
        }
    }
    
}

extension LastBroadcastsDataSource: StoreSubscriber {
    
    func newState(state: Results<BroadcastStore>?) {
        elementsToDisplay = state
        reloadData()
    }
}

