//
//  ShowViewController.swift
//  NLive
//
//  Created by Eliah Snakin on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import UIKit
import Nuke

class ShowViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let show = show {
            configure(withShow: show)
        }
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
