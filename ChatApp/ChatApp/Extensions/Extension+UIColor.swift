//
//  Extension+UIColor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 04.03.2021.
//

import UIKit

extension UIColor {
    static var banana: UIColor {
        UIColor(red: 255 / 255, green: 255 / 255, blue: 102 / 255, alpha: 1.0)
    }
    
    static var bananaHalf: UIColor {
        UIColor(red: 255 / 255, green: 255 / 255, blue: 102 / 255, alpha: 0.5)
    }
    
    static var blueStroke: UIColor {
        UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
    }
}

extension UIColor {
    struct ChooseThemeButtonView {
        struct Classic {
            static var leftViewColorGray: UIColor {
                UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
            }
            
            static var rightViewColorGreen: UIColor {
                UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
            }
            
            static var mainViewColorWhite: UIColor {
                UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
        
        struct Day {
            static var leftViewColorGray: UIColor {
                UIColor(red: 0.918, green: 0.922, blue: 0.929, alpha: 1)
            }
            
            static var rightViewColorBlue: UIColor {
                UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1)
            }
            
            static var mainViewColorWhite: UIColor {
                UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
        
        struct Night {
            static var leftViewColorDarkGray: UIColor {
                UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
            }
            
            static var rightViewColorGray: UIColor {
                UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
            }
            
            static var mainViewColorBlack: UIColor {
                UIColor(red: 0.024, green: 0.024, blue: 0.024, alpha: 1)
            }
        }
    }
}
