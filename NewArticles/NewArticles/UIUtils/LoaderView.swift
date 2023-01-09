//
//  LoaderView.swift
//  NewArticles
//
//  Created by Mayank Verma on 09/01/23.
//

import Foundation
import UIKit
import Lottie

final class Loader {
    
    var container: UIView = UIView()
    var loadingView: LottieAnimationView = LottieAnimationView()
    
    let window = UIApplication.shared.windows.first
    
    static let shared = Loader()
    
    private init() {
        initAnimation()
    }
    
    func initAnimation() {
        self.loadingView = LottieAnimationView(name: "353-newspaper-spinner")
        self.loadingView.loopMode = .loop
    }
    
    func startAnimating() {
        window?.isUserInteractionEnabled = false
        container.frame = window!.frame
        container.center = window!.center
        container.backgroundColor = .white.withAlphaComponent(0.6)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingView.center = window!.center
        loadingView.backgroundColor = .clear
   
        container.addSubview(loadingView)
        window!.addSubview(container)
        self.loadingView.play()
    }
    
    func stopAnimating() {
        window?.isUserInteractionEnabled = true
        self.loadingView.pause()
        container.removeFromSuperview()
    }
    
}
