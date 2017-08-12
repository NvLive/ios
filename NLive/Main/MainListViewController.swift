//
//  ViewController.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import UIKit

class MainListViewController: UIViewController {

    @IBOutlet weak var promoBroadcastView: UIImageView!
    @IBOutlet weak var lastBroadcastsCollection: UICollectionView!
    @IBOutlet weak var allShowsCollection: UICollectionView!
    
    @IBOutlet var lastBroadcastDataSource: LastBroadcastsDataSource!
    @IBOutlet var allShowsDataSource: AllShowsDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastBroadcastDataSource.collectionView = lastBroadcastsCollection
        allShowsDataSource.collectionView = allShowsCollection
    }
    
    
}


extension MainListViewController: AllShowsDelegate {
    
}

extension MainListViewController: LastBroadcastsDelegate {
   
}
