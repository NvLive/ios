//
//  ViewController.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import UIKit
import ReSwift
import RealmSwift
import Nuke
import Timepiece

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet var promoView: UIView!
    @IBOutlet weak var promoBroadcastView: UIImageView!
    @IBOutlet weak var promoTitleLabel: UILabel!
    @IBOutlet weak var promoCreateTimeLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lastBroadcastsCollection: UICollectionView!
    @IBOutlet weak var allShowsCollection: UICollectionView!
    
    @IBOutlet var lastBroadcastDataSource: LastBroadcastsDataSource!
    @IBOutlet var allShowsDataSource: AllShowsDataSource!
    
    let dispatcher = DashboardDispatcher()
    
    fileprivate var featuredBroadcast: BroadcastStore? = nil {
        didSet {
            guard featuredBroadcast != nil else {
                stackView.removeArrangedSubview(promoView)
                promoView.removeFromSuperview()
                isFeaturedDisplayed = false
                return
            }
            
            if !isFeaturedDisplayed {
                stackView.insertArrangedSubview(promoView, at: 0)
            }
            
            let imageUrlString = featuredBroadcast!.placeholderImageUrlString ?? featuredBroadcast!.show.first?.placeholderImageUrlString
            
            if  let imageUrlString = imageUrlString,
                let imageUrl = URL(string: imageUrlString) {
                Nuke.loadImage(with: imageUrl, into: promoBroadcastView)
            }
            
            promoTitleLabel.text = featuredBroadcast!.title
            promoCreateTimeLabel.text = featuredBroadcast!.startDate.timeString(in: .short)
        }
    }
    private var isFeaturedDisplayed = true
    
    
    @IBAction func featuredTapActionWithGesture(_ sender: Any) {
        store.dispatchOnMain(StreamAction.activate(broadcast: self.featuredBroadcast))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastBroadcastDataSource.collectionView = lastBroadcastsCollection
        allShowsDataSource.collectionView = allShowsCollection
        scrollView.contentInset.bottom = 44
        
        store.subscribe(self) { subcription in
            subcription.select { state in state.dashboardState.featuredBroadcasts }
        }
        
        dispatcher.fetchShows()
        dispatcher.fetchCurrent()
        dispatcher.fetchLast()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension DashboardViewController: StoreSubscriber {
    
    func newState(state: Results<BroadcastStore>?) {
        featuredBroadcast = state?.first
    }
}

extension DashboardViewController: AllShowsDelegate {
    
}

extension DashboardViewController: LastBroadcastsDelegate {
   
}