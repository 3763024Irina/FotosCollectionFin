import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Если используется SceneDelegate, то приложение будет работать с ним
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // Этот метод используется при создании новой сцены
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // Этот метод вызывается при удалении сцены
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Можно выполнить очистку, если это необходимо
    }
}
