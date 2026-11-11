import UIKit

final class ViewControllerSwitcher {
    
    static let shared = ViewControllerSwitcher()
    private init() { }
    
    func presentNavigationController(from: UIViewController, _ vc: UIViewController) {
        let navigController = UINavigationController(rootViewController: vc)
        
        navigController.navigationBar.isHidden = false
        
        from.present(navigController, animated: true)
    }
}
