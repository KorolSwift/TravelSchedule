//
//  FontSize.swift
//  Tracker
//
//  Created by Ди Di on 11/06/25.
//

import UIKit


enum FontSize {
    static let size12: CGFloat = 12
    static let size17: CGFloat = 17
    static let size20: CGFloat = 20
    static let size24: CGFloat = 24
    static let size34: CGFloat = 34
}

extension UIFont {
    static let sfProDisplayRegular12 = UIFont(name: "SFProDisplay-Regular", size: FontSize.size12)
    static let sfProDisplayRegular17 = UIFont(name: "SFProDisplay-Regular", size: FontSize.size17)
    static let sfProDisplayRegular20 = UIFont(name: "SFProDisplay-Regular", size: FontSize.size20)
    static let sfProDisplayBold17 = UIFont(name: "SFProDisplay-Bold", size: FontSize.size17)
    static let sfProDisplayBold24 = UIFont(name: "SFProDisplay-Bold", size: FontSize.size24)
    static let sfProDisplayBold34 = UIFont(name: "SFProDisplay-Bold", size: FontSize.size34)
}

