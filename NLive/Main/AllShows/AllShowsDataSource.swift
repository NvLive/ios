//
//  AllShowsDataSource.swift
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


protocol AllShowsDelegate: class {
    func navigateTo(show: ShowStore)
}

class AllShowsDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override init() {
        super.init()
        
        store.subscribe(self) { subcription in
            subcription.select { state in state.dashboardState.shows }
        }
        
        let itemWidth = (UIScreen.main.bounds.width - 16 * 2) / 2 - 8
        let itemHeight = itemWidth / 16 * 9
        (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: itemWidth, height: itemHeight)
        (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = 8
    }
    
    weak var delegate: AllShowsDelegate? = nil
    
    var elementsToDisplay: Results<ShowStore>? = nil

    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    weak var collectionView: UICollectionView? = nil {
        didSet{
            reloadData()
        }
    }
    
    func reloadData() {
        guard collectionView != nil else { return }
        
        collectionView?.isScrollEnabled = false
        collectionView?.reloadData()
        collectionView?.layoutIfNeeded()
        heightConstraint.constant = collectionView?.contentSize.height ?? 0
        collectionView?.layoutIfNeeded()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elementsToDisplay?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllShowCell", for: indexPath) as! AllShowCell
        
        cell.showImage.image = nil
        if  let imageUrlString = elementsToDisplay?[indexPath.item].placeholderImageUrlString,
            let imageUrl = URL(string: imageUrlString) {
            Nuke.loadImage(with: imageUrl, into: cell.showImage)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let show = elementsToDisplay?[indexPath.item] {
            delegate?.navigateTo(show: show)
        }
    }
}


import ReSwift

extension AllShowsDataSource: StoreSubscriber {
    
    func newState(state: Results<ShowStore>?) {
        elementsToDisplay = state
        reloadData()
    }
}
