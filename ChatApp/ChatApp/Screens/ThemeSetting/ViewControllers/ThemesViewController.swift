//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 08.03.2021.
//

import UIKit

class ThemesViewController: UIViewController {
    
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
        if let chooseThemeButtonView = ChooseThemeButtonView.inctanceFromNib() {
            chooseThemeButtonView.frame = themeNightView.bounds
            chooseThemeButtonView.configureThemeButtonView(type: .night)
            themeNightView.addSubview(chooseThemeButtonView)
            themeNightView.layer.cornerRadius = cornerRadiusThemeView
            themeNightView.clipsToBounds = true
            themeNightLabel.text = "Night"
        }
    }
    
    private func setupThemeDayView() {
        if let chooseThemeButtonView = ChooseThemeButtonView.inctanceFromNib() {
            chooseThemeButtonView.frame = themeDayView.bounds
            chooseThemeButtonView.configureThemeButtonView(type: .day)
            themeDayView.addSubview(chooseThemeButtonView)
            themeDayView.layer.cornerRadius = cornerRadiusThemeView
            themeDayView.clipsToBounds = true
            themeDayLabel.text = "Day"
        }
    }
    
    private func setupThemeClassicView()  {
        if let chooseThemeButtonView = ChooseThemeButtonView.inctanceFromNib() {
            chooseThemeButtonView.frame = themeClassicView.bounds
            chooseThemeButtonView.configureThemeButtonView(type: .classic)
            themeClassicView.addSubview(chooseThemeButtonView)
            themeClassicView.layer.cornerRadius = cornerRadiusThemeView
            themeClassicView.clipsToBounds = true
            themeClassicLabel.text = "Classic"
        }
    }
}
