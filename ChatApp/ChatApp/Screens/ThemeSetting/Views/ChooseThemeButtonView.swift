//
//  ChooseThemeButtonView.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 08.03.2021.
//

import UIKit

typealias ThemeColors = UIColor.ChooseThemeButtonView

class ChooseThemeButtonView: UIView {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
        
    // MARK: - Drawing Constraints
    
    let cornerRadiusViewDialog: CGFloat = 10
    let maskedCornersRightView: CACornerMask = [
        .layerMaxXMinYCorner,
        .layerMinXMaxYCorner,
        .layerMinXMinYCorner
    ]
    let maskedCornersLeftView: CACornerMask = [
        .layerMaxXMaxYCorner,
        .layerMinXMinYCorner,
        .layerMaxXMinYCorner
    ]
    
    func configureThemeButtonView(_ type: ChooseThemeButtonViewType) {
        leftView.layer.cornerRadius = cornerRadiusViewDialog
        leftView.layer.maskedCorners = maskedCornersLeftView
        rightView.layer.cornerRadius = cornerRadiusViewDialog
        rightView.layer.maskedCorners = maskedCornersRightView
        
        switch type {
        case .classic: configureClassic()
        case .day: configureDay()
        case .night: configureNight()
        }
    }
    
    func configureThemeButtonView(_ type: ChooseThemeButtonViewType, parentBounds: CGRect) {
        configureThemeButtonView(type)
        frame = parentBounds
    }

    private func configureClassic() {
        backgroundColor = ThemeColors.Classic.mainViewColorWhite
        leftView.backgroundColor = ThemeColors.Classic.leftViewColorGray
        rightView.backgroundColor = ThemeColors.Classic.rightViewColorGreen
    }
    
    private func configureDay() {
        backgroundColor = ThemeColors.Day.mainViewColorWhite
        leftView.backgroundColor = ThemeColors.Day.leftViewColorGray
        rightView.backgroundColor = ThemeColors.Day.rightViewColorBlue
    }
    
    private func configureNight() {
        backgroundColor = ThemeColors.Night.mainViewColorBlack
        leftView.backgroundColor = ThemeColors.Night.leftViewColorDarkGray
        rightView.backgroundColor = ThemeColors.Night.rightViewColorGray
    }
}

extension ChooseThemeButtonView {
    enum ChooseThemeButtonViewType {
        case classic, day, night
    }
    
    static func instanceFromNib() -> ChooseThemeButtonView? {
        return UINib(nibName: String(describing: ChooseThemeButtonView.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ChooseThemeButtonView
    }
}
