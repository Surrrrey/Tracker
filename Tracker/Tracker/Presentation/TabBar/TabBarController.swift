import UIKit

final class TabBarController: UITabBarController {
    
    let trackersImage = UIImage(systemName: "record.circle.fill")
    let statisticImage = UIImage(systemName: "hare.fill")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTabBar()
    }
    
    private func configTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .whiteDay
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.isTranslucent = false
        
        tabBar.backgroundColor = .whiteDay
        tabBar.tintColor = .ypBlue
        
        let trackersVC = TrackersViewController()
        let navC = UINavigationController(rootViewController: trackersVC)
        let statisticVC = StatisticViewController()
        
        navC.tabBarItem = UITabBarItem(title: "Трекеры",
                                             image: trackersImage?.withTintColor(.ypGray).withRenderingMode(.alwaysOriginal),
                                             selectedImage: trackersImage)
        
        statisticVC.tabBarItem = UITabBarItem(title: "Статистика",
                                              image: statisticImage?.withTintColor(.ypGray).withRenderingMode(.alwaysOriginal),
                                              selectedImage: statisticImage)

        self.viewControllers = [navC, statisticVC]
    }
}
