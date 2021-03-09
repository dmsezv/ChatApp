//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 08.03.2021.
//

import UIKit

class ThemesViewController: UIViewController {
    
    enum ThemeTypes: Int {
        case day = 0
        case night = 1
        case classic = 2
    }
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var themeClassicView: UIView!
    @IBOutlet weak var themeClassicLabel: UILabel!
    
    @IBOutlet weak var themeDayView: UIView!
    @IBOutlet weak var themeDayLabel: UILabel!
    
    @IBOutlet weak var themeNightView: UIView!
    @IBOutlet weak var themeNightLabel: UILabel!
    
    @IBAction func touchButtonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Drawing Constants
    
    let cornerRadiusThemeView: CGFloat = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupView()
    }
    
    private func setupView() {        
        setupThemeClassicView()
        setupThemeNightView()
        setupThemeDayView()
    }
    
    private func setupThemeNightView() {
        if let chooseThemeButtonView = ChooseThemeButtonView.instanceFromNib() {
            chooseThemeButtonView.configureThemeButtonView(.night,  parentBounds: themeDayView.bounds)
            themeNightView.addSubview(chooseThemeButtonView)
            themeNightView.tag = ThemeTypes.night.rawValue
            configureTheme(themeNightView)

            themeNightLabel.text = "Night"
            themeNightLabel.tag = ThemeTypes.night.rawValue
            configureTheme(themeNightLabel)
        }
    }
    
    private func setupThemeDayView() {
        if let chooseThemeButtonView = ChooseThemeButtonView.instanceFromNib() {
            chooseThemeButtonView.configureThemeButtonView(.day, parentBounds: themeDayView.bounds)
            themeDayView.addSubview(chooseThemeButtonView)
            themeDayView.tag = ThemeTypes.day.rawValue
            configureTheme(themeDayView)

            themeDayLabel.text = "Day"
            themeDayLabel.tag = ThemeTypes.day.rawValue
            configureTheme(themeDayLabel)
        }
    }
    
    private func setupThemeClassicView()  {
        if let chooseThemeButtonView = ChooseThemeButtonView.instanceFromNib() {
            chooseThemeButtonView.configureThemeButtonView(.classic,  parentBounds: themeDayView.bounds)
            themeClassicView.addSubview(chooseThemeButtonView)
            themeClassicView.tag = ThemeTypes.classic.rawValue
            configureTheme(themeClassicView)
            
            themeClassicLabel.text = "Classic"
            themeClassicLabel.tag = ThemeTypes.classic.rawValue
            configureTheme(themeClassicLabel)
        }
    }
    
    private func configureTheme(_ view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchThemeView(_ : )))
        view.addGestureRecognizer(tap)
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.blueStroke.cgColor
        view.layer.cornerRadius = cornerRadiusThemeView
        view.clipsToBounds = true
    }
    
    private func configureTheme(_ label: UILabel) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchThemeLabel(_ : )))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
    }
    
    private func select(_ view: UIView) {
        themeClassicView.layer.borderWidth = 0
        themeDayView.layer.borderWidth = 0
        themeNightView.layer.borderWidth = 0
        
        view.layer.borderWidth = 2
    }
    
    private func changeTheme(type: ThemeTypes) {
        
    }
}


//MARK: - Touches

extension ThemesViewController {
    @objc private func touchThemeView(_ sender: UITapGestureRecognizer) {
        if let view = sender.view {
            select(view)
        }
    }
    
    @objc private func touchThemeLabel(_ sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel {
            switch label.tag {
            case ThemeTypes.classic.rawValue:
                if let view = themeClassicView {
                    select(view)
                }
            case ThemeTypes.day.rawValue:
                if let view = themeDayView {
                    select(view)
                }
            case ThemeTypes.night.rawValue:
                if let view = themeNightView {
                    select(view)
                }
            default: break
            }
        }
    }
}
