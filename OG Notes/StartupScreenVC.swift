//
//  StartupScreenVC.swift
//  OG Notes
//
//  Created by Om Gandhi on 07/01/24.
//

import UIKit
import SDWebImage

class StartupScreenVC: UIViewController {

    @IBOutlet weak var imgView: SDAnimatedImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.traitCollection.userInterfaceStyle == .dark {
                    // User Interface is Dark
            let animatedLogo = SDAnimatedImage(named: "Notes Dark.gif")
            imgView.image = animatedLogo
            }
        else {
                    // User Interface is Light
            let animatedLogo = SDAnimatedImage(named: "Notes gif.gif")
            imgView.image = animatedLogo
                    
                }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // your code here
            let vc = self.storyboard?.instantiateViewController(identifier: "HomeNavigation")
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
                if self.traitCollection.userInterfaceStyle == .light {
                    // Code to execute in light mode
                    let animatedLogo = SDAnimatedImage(named: "Notes gif.gif")
                    self.imgView.image = animatedLogo
                    print("App switched to light mode")
                } else {
                    // Code to execute in dark mode
                    let animatedLogo = SDAnimatedImage(named: "Notes Dark.gif")
                    self.imgView.image = animatedLogo
                    print("App switched to dark mode")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    // your code here
                    let vc = self.storyboard?.instantiateViewController(identifier: "HomeNavigation")
                    UIApplication.shared.windows.first?.rootViewController = vc
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            })
        } else {
            
        }

        // Do any additional setup after loading the view.
    }

}
