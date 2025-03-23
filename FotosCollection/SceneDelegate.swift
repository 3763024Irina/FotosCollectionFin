import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

   
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }

    
        window = UIWindow(windowScene: windowScene)

      
        let mainViewController = PhotoGalleryViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)

     
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

   
    func sceneDidBecomeActive(_ scene: UIScene) {
     
    }

   
    func sceneWillResignActive(_ scene: UIScene) {
       
    }

   
    func sceneDidEnterBackground(_ scene: UIScene) {
       
    }
}

