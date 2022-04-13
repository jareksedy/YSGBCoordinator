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
    var notifier: Notifier?
    
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
    
    func notifyUser() {
        let content = notifier?.makeNotificationContent(title: "Вернись в приложение!",
                                                        subtitle: "Вернись в приложение, кому сказано!",
                                                        body: "Вернись в приложение, будь человеком!",
                                                        badge: nil)
        
        let trigger = notifier?.makeIntervalNotificatioTrigger(timeInterval: 10, repeats: false)
        
        notifier?.notify(content: content!, trigger: trigger!)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notifier = Notifier()
        notifier?.requestAuthorization(options: [.alert, .sound])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController()
        
        loginCoordinator = LoginCoordinator(navigationController: window?.rootViewController as! UINavigationController)
        loginCoordinator?.start()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        hideContent()
        notifyUser()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        showContent()
    }
}

