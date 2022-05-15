//
//  OnBoardViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 14.04.2022.
//

import UIKit

class OnBoardViewController: UIViewController, OnboardDelegate {
    
    var swiftyOnboard: Onboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swiftyOnboard = Onboard(frame: view.frame)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
    }
    
    @objc func handleSkip() {
        //swiftyOnboard?.goToPage(index: 4, animated: true)
        let vc = CardLotViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        if index != 4 {
            swiftyOnboard?.goToPage(index: index + 1, animated: true)
        } else {
            let tabVC = TabBarViewController()
            let foregroundedScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
            let window = foregroundedScenes.map { $0 as? UIWindowScene }.compactMap { $0 }.first?.windows.filter { $0.isKeyWindow }.first
            guard let uWindow = window else { return }
            uWindow.rootViewController = tabVC
            UIView.transition(with: uWindow, duration: 0.3, options: [.transitionCrossDissolve], animations: {}, completion: nil)
        }
    }
}

extension OnBoardViewController: OnboardDataSource {
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: Onboard, atIndex index: Int) -> UIColor? {
        return Color.backgroundScreen.color
    }
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: Onboard) -> Int {
        return 5
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: Onboard, index: Int) -> OnboardPage? {
        let page = OnboardPage()
        page.imageView.image = OnboardingImages.getImage(index)
        page.title.text = OnboardingTitles.getTitle(index)
        page.subTitle.text = OnboardingDescriptions.getDescription(index)
        return page
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: Onboard) -> OnboardOverlay? {
        let overlay = OnboardOverlay()
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: Onboard, overlay: OnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.continueButton.tag = Int(position)
        
        if currentPage >= 0 && currentPage <= 3 {
            overlay.continueButton.setTitle("Далее", for: .normal)
            overlay.skipButton.setTitle("Пропустить", for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle("Начнем!", for: .normal)
            overlay.skipButton.isHidden = true
        }
    }
}
