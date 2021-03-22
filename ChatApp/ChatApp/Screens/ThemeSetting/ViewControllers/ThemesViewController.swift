//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 08.03.2021.
//

import UIKit


class ThemesViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var themeClassicView: UIView!
    @IBOutlet weak var themeClassicLabel: UILabel!
    
    @IBOutlet weak var themeDayView: UIView!
    @IBOutlet weak var themeDayLabel: UILabel!
    
    @IBOutlet weak var themeNightView: UIView!
    @IBOutlet weak var themeNightLabel: UILabel!
    
    @IBAction func touchButtonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Delegate & Callback
    //я решил использовать singleton, поэтому здесь weak не нужен, тк класс не будет освобожден
    //но в другом случае weak помог бы избежать утечки памяти тк не итерировал бы счетчик ссылок
    //и благодаря тому, что он optional мы могли бы безопасно стучать в делегат
    var themePickerDelegate: ThemePickerDelegate?
    var themePickerCallback: ((ThemePicker.ThemeType) -> Void)?

    
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
        
        change(ThemePicker.shared.currentTheme.typeTheme)
    }
    
    private func setupThemeNightView() {
        if let chooseThemeButtonView = ChooseThemeButtonView.instanceFromNib() {
            chooseThemeButtonView.configureThemeButtonView(.night,  parentBounds: themeDayView.bounds)
            themeNightView.addSubview(chooseThemeButtonView)
            themeNightView.tag = ThemePicker.ThemeType.night.rawValue
            configureTheme(themeNightView)

            themeNightLabel.text = "Night"
            themeNightLabel.tag = ThemePicker.ThemeType.night.rawValue
            configureTheme(themeNightLabel)
        }
    }
    
    private func setupThemeDayView() {
        if let chooseThemeButtonView = ChooseThemeButtonView.instanceFromNib() {
            chooseThemeButtonView.configureThemeButtonView(.day, parentBounds: themeDayView.bounds)
            themeDayView.addSubview(chooseThemeButtonView)
            themeDayView.tag = ThemePicker.ThemeType.day.rawValue
            configureTheme(themeDayView)

            themeDayLabel.text = "Day"
            themeDayLabel.tag = ThemePicker.ThemeType.day.rawValue
            configureTheme(themeDayLabel)
        }
    }
    
    private func setupThemeClassicView()  {
        if let chooseThemeButtonView = ChooseThemeButtonView.instanceFromNib() {
            chooseThemeButtonView.configureThemeButtonView(.classic,  parentBounds: themeDayView.bounds)
            themeClassicView.addSubview(chooseThemeButtonView)
            themeClassicView.tag = ThemePicker.ThemeType.classic.rawValue
            configureTheme(themeClassicView)
            
            themeClassicLabel.text = "Classic"
            themeClassicLabel.tag = ThemePicker.ThemeType.classic.rawValue
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
    
    private func change(_ theme: ThemePicker.ThemeType) {
        themeClassicView.layer.borderWidth = 0
        themeDayView.layer.borderWidth = 0
        themeNightView.layer.borderWidth = 0
        
        switch theme {
        case .classic:
            contentView.backgroundColor = UIColor.ChooseThemeButtonView.Classic.rightViewColorGreen
            themeClassicView.layer.borderWidth = 2
        case .day:
            contentView.backgroundColor = UIColor.ChooseThemeButtonView.Day.rightViewColorBlue
            themeDayView.layer.borderWidth = 2
        case .night:
            contentView.backgroundColor = UIColor.ChooseThemeButtonView.Night.rightViewColorGray
            themeNightView.layer.borderWidth = 2
        }
        
        changeInApplication(theme)
    }
    
    private func changeInApplication(_ themeType: ThemePicker.ThemeType) {
        if let delegate = themePickerDelegate {
            delegate.changeThemeTo(themeType)
        }
        else if let callback = themePickerCallback {
            callback(themeType)
        }
    }
}


//MARK: - Touches

extension ThemesViewController {
    @objc private func touchThemeView(_ sender: UITapGestureRecognizer) {
        if let view = sender.view,
           let theme = ThemePicker.ThemeType(rawValue: view.tag) {
            change(theme)
        }
    }
    
    @objc private func touchThemeLabel(_ sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel,
           let theme = ThemePicker.ThemeType(rawValue: label.tag) {
            change(theme)
        }
    }
}
