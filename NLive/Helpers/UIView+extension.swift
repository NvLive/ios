//
//  UIView+extension.swift
//  nativeme
//
//  Created by Eliah Snakin on 06/06/2017.
//  Copyright © 2017 nikans.com. All rights reserved.
//

import UIKit
import SnapKit

class NibLoadedView: UIView {
    
    weak var loadedView: UIView!
    weak var containerView: UIView!
    
    init() {
        super.init(frame: CGRect())
        loadedView = fromNib()
        containerView = self
        
        awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadedView = fromNib()
        containerView = self
        
        awakeFromNib()
    }
}

extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        return view
    }
}
