//
//  BroadcastViewController.swift
//  NLive
//
//  Created by Eliah Snakin on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import UIKit
import Nuke

class BroadcastViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentsTitle: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let broadcast = broadcast {
            configure(withBroadcast: broadcast)
        }
        
        scrollView.contentInset.bottom = 60
    }
    
    var broadcast: BroadcastStore? = nil
    
    private func configure(withBroadcast broadcast: BroadcastStore) {
        
        let imageUrlString = broadcast.placeholderImageUrlString ?? broadcast.show.first?.placeholderImageUrlString
        
        if  let imageUrlString = imageUrlString,
            let imageUrl = URL(string: imageUrlString) {
            Nuke.loadImage(with: imageUrl, into: imageView)
        }
        
        showLabel.text = broadcast.show.first?.title
        titleLabel.text = broadcast.title
        descriptionLabel.text = broadcast.descriptionString
        contentsTitle.text = broadcast.contents
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
