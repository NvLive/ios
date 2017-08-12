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
        static let tintedMuted  = UIColor(r: 223, g: 236, b: 240)
        static let opposite     = UIColor.black
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
            background: UIColor(r: 0, g: 129, b: 204),
            font:       Font.Color.opposite,
            tint:       Font.Color.opposite
        )
        
        static let tintedTranslucent = Colors(
            background: UIColor(r: 0, g: 109, b: 197),
            font:       Font.Color.opposite,
            tint:       Font.Color.opposite
        )
        
        static let image = Colors(
            background: UIColor.clear,
            font:       Font.Color.opposite,
            tint:       Font.Color.opposite
        )
    }
    
    struct Table {
        static let separator = Color.Base.mutedMore
    }
    
    struct Severity {
        static let low      = Color.Base.success
        static let moderate = UIColor(r: 165, g: 216, b: 43)
        static let average  = Color.Base.warning
        static let elevated = UIColor(r: 255, g: 133, b: 77)
        static let high     = Color.Base.danger
        static let special  = UIColor(r: 133, g: 95, b: 246)
    }
    
    struct Base {
        static let danger   = UIColor(r: 255, g: 102, b: 99)
        static let warning  = UIColor(r: 255, g: 189, b: 85)
        static let success  = UIColor(r: 61, g: 213, b: 82)
        static let info     = UIColor(r: 0, g: 191, b: 255)
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
