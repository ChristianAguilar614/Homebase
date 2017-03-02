//
//  colorfulNavigationController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/20/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import ChameleonFramework

class colorfulNavigationController: UINavigationController {

    
                //GradientColor(UIGradientStyle.TopToBottom, navigationBarAppearace.frame, [HexColor("FF5E3A"), HexColor("FF2A68")])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        //makes the frame which includes navbar and status bar
        let navBarRect = CGRect(
            x: navigationBar.frame.minX,
            y: UIApplication.shared.statusBarFrame.minY,
            width: navigationBar.frame.width,
            height: navigationBar.frame.height + UIApplication.shared.statusBarFrame.height)
        
        let mainColor = HexColor("5AD427")
        let mainGradient = GradientColor(UIGradientStyle.topToBottom, navBarRect, [UIColor(hexString: "A4E786"), UIColor(hexString: "5AD427")])
        
        self.navigationBar.barTintColor = mainColor
        
        UIApplication.shared.statusBarFrame.minY

        navigationBar.tintColor = UIColor(complementaryFlatColorOf: mainGradient)//.lightenByPercentage(20.0)
        navigationBar.barTintColor = mainGradient
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ContrastColorOf(mainGradient, true)]
        // navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: ContrastColorOf(mainColor, true), NSFontAttributeName: UIFont.systemFontOfSize(20.0)]
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = ContrastColorOf(mainColor, true)
        tabBarAppearance.barTintColor = mainColor.lighten(byPercentage: 0.05)
        
    }
    
    func generateAppTheme(){
        let navBarRect = CGRect(
            x: navigationBar.frame.minX,
            y: UIApplication.shared.statusBarFrame.minY,
            width: navigationBar.frame.width,
            height: navigationBar.frame.height + UIApplication.shared.statusBarFrame.height)
        
        let mainColor = RandomFlatColorWithShade(.light)
        let mainGradient = GradientColor(
            UIGradientStyle.topToBottom,
            navBarRect,
            [mainColor.darken(byPercentage: 0.2), mainColor]
        )
        
        self.navigationBar.barTintColor = mainColor
        
        UIApplication.shared.statusBarFrame.minY
        
        navigationBar.tintColor = UIColor(complementaryFlatColorOf: mainGradient).lighten(byPercentage: 0.2)
        navigationBar.barTintColor = mainGradient
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ContrastColorOf(mainGradient, true)]
        // navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: ContrastColorOf(mainColor, true), NSFontAttributeName: UIFont.systemFontOfSize(20.0)]
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor(complementaryFlatColorOf: mainGradient).lighten(byPercentage: 0.2)
        tabBarAppearance.barTintColor = mainColor.lighten(byPercentage: 0.1)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
