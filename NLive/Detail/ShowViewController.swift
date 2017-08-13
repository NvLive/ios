//
//  ShowViewController.swift
//  NLive
//
//  Created by Eliah Snakin on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import UIKit
import Nuke

class ShowViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let show = show {
            configure(withShow: show)
        }
        let itemWidth =  UIScreen.main.bounds.width - 20 * 2.0
        let itemHeight = itemWidth / 16 * 9 + 37
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        scrollView.contentInset.bottom = 60
        reloadData()
    }
    
    var show: ShowStore? = nil
    
    private func configure(withShow show: ShowStore) {
        
        let imageUrlString = show.placeholderImageUrlString
        
        if  let imageUrlString = imageUrlString,
            let imageUrl = URL(string: imageUrlString) {
            Nuke.loadImage(with: imageUrl, into: imageView)
        }
        
        titleLabel.text = show.title
        descriptionLabel.text = show.descriptionString
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func reloadData() {
        guard collectionView != nil else { return }
        
        collectionView?.isScrollEnabled = false
        collectionView?.reloadData()
        collectionView?.layoutIfNeeded()
        collectionHeight.constant = collectionView?.contentSize.height ?? 0
        collectionView?.layoutIfNeeded()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return show?.broadcasts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : LastBroadcastCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastBroadcastCell", for: indexPath) as! LastBroadcastCell
        
        let broadcast = show?.broadcasts[indexPath.item]
        
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
}
