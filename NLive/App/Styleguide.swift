//
//  Colors.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 10/07/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import UIKit


// 
// MARK: Color
//

struct Color {
    
    struct Background {
        static let base         = UIColor.white
        static let opposite     = UIColor(r: 52, g: 52, b: 52)
    }
    
    struct Navigation {
        struct Colors {
            let background: UIColor
            let font: UIColor
            let tint: UIColor
        }
        
        static let base = Colors(
            background: Color.Background.base,
            font:       Font.Color.base,
            tint:       UIColor(r: 36, g: 18, b: 0)
        )
        
        static let tinted = Colors(
            background: Base.info,
            font:       Font.Color.opposite,
            tint:       Font.Color.opposite
        )
    }
    
    struct Table {
        static let separator = Color.Base.mutedMore
    }
    
    struct Base {
        static let danger   = UIColor(r: 202, g: 8, b: 20)
        static let warning  = UIColor(r: 251, g: 112, b: 65)
        static let success  = UIColor(r: 34, g: 203, b: 145)
        static let info     = UIColor(r: 34, g: 203, b: 203) //RGB(199, 245, 245)
        static let mutedMore = UIColor(r: 200, g: 199, b: 204)
        static let muted    = UIColor(r: 131, g: 131, b: 131)
    }
    
    struct Border {
        static let muted    = Color.Base.mutedMore
    }
}


//
// MARK: Font
//

struct Font {
    
    enum Size: CGFloat {
        case small  = 14
        case normal = 17
        case large  = 25
        case giant  = 36
        
        var points: CGFloat {
            return self.rawValue
        }
    }
    
    struct Color {
        static let base      = UIColor.black
        static let opposite  = UIColor.white
        static let muted     = NLive.Color.Base.muted
    }
    
    static let smallRegular  = regular(ofSize: Size.small.points)
    static let normalRegular = regular(ofSize: Size.normal.points)
    static let normalMedium  = medium(ofSize: Size.normal.points)
    static let largeRegular  = regular(ofSize: Size.large.points)
    static let largeMedium   = medium(ofSize: Size.large.points)
    static let giantRegular  = regular(ofSize: Size.giant.points)
    static let giantMedium   = medium(ofSize: Size.giant.points)
    
    static func medium(ofSize size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    static func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
}


//
// MARK: Sizes
//

struct Sizes {
    
    struct Border {
        static let width: CGFloat = 0.5
    }
    
    struct View {
        static let cornerRadius: CGFloat = 5
    }
}
