import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    return true
  }
    
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    
    if let secondary = secondaryViewController as? UINavigationController {
      if let recVC = secondary.topViewController as? RecordingViewController {
        if recVC.recording == nil {
          return true
        } else {
          return false
        }
      } else {
        return false
      }
    } else {
      return false
    }
  }
}

