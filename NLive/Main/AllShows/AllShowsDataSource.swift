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


protocol AllShowsDelegate {
    
}

class AllShowsDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override init() {
        super.init()
        
        store.subscribe(self) { subcription in
            subcription.select { state in state.dashboardState.shows }
        }
    }
    
    var elementsToDisplay: Results<ShowStore>? = nil
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    weak var collectionView: UICollectionView? = nil {
        didSet{
            reloadData()
        }
    }
    
    func reloadData() {
        collectionView?.isScrollEnabled = false
        collectionView?.performBatchUpdates({[weak self] in
            self?.collectionView?.reloadData()
        }, completion: {[weak self] (succes) in
            self?.heightConstraint.constant = self?.collectionView?.contentSize.height ?? 0
            self?.collectionView?.layoutIfNeeded()
        })
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
}


import ReSwift

extension AllShowsDataSource: StoreSubscriber {
    
    func newState(state: Results<ShowStore>?) {
        elementsToDisplay = state
        reloadData()
    }
}
