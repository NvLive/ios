//
//  AllShowsDataSource.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import Foundation
import UIKit

protocol AllShowsDelegate {
    
}

class AllShowsDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    func numberOfItemsInSection() -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllShowCell", for: indexPath) as? AllShowCell else {
            fatalError()
        }
        
        return cell
    }

    
}
