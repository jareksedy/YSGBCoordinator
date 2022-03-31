//
//  AppDelegate.swift
//  YSGBCoordinator
//
//  Created by Ярослав on 24.03.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var loginCoordinator: LoginCoordinator?
    var appSwitcherView: UIView?
    
    func createScreenshotOfCurrentContext() -> UIImage? {
        UIGraphicsBeginImageContext(self.window?.screen.bounds.size ?? CGSize())
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        self.window?.layer.render(in: currentContext)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func applyGaussianBlur(on image: UIImage, withBlurFactor blurFactor : CGFloat) -> UIImage? {
        guard let inputImage = CIImage(image: image) else {
            return nil
        }
        
        let gaussianFilter = CIFilter(name: "CIGaussianBlur")
        gaussianFilter?.setValue(inputImage, forKey: kCIInputImageKey)
        gaussianFilter?.setValue(blurFactor, forKey: kCIInputRadiusKey)
        
        guard let outputImage = gaussianFilter?.outputImage else {
            return nil
        }
        
        return UIImage(ciImage: outputImage)
    }
    
    func hideContent(){
        let blurredImage = applyGaussianBlur(on: createScreenshotOfCurrentContext() ?? UIImage(), withBlurFactor: 4.5)

        appSwitcherView = UIImageView(image: blurredImage)
        self.window?.addSubview(appSwitcherView!)
    }
    
    func showContent(){
        appSwitcherView?.removeFromSuperview()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController()
        
        loginCoordinator = LoginCoordinator(navigationController: window?.rootViewController as! UINavigationController)
        loginCoordinator?.start()
        
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        hideContent()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        showContent()
    }
}

