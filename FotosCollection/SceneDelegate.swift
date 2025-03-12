import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // Этот метод вызывается при создании сцены
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Получаем ссылку на windowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Создаем окно для сцены
        window = UIWindow(windowScene: windowScene)

        // Здесь создаем основной экран приложения
        let mainViewController = PhotoGalleryViewController()  // Замените на свой контроллер

        // Оборачиваем контроллер в навигационный контроллер
        let navigationController = UINavigationController(rootViewController: mainViewController)

        // Устанавливаем корневой контроллер
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    // Этот метод вызывается, когда сцена становится активной
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Здесь можно выполнить дополнительные действия при активации сцены
    }

    // Этот метод вызывается, когда сцена становится неактивной
    func sceneWillResignActive(_ scene: UIScene) {
        // Здесь можно выполнить действия при деактивации сцены
    }

    // Этот метод вызывается при переходе сцены в фоновый режим
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Здесь можно выполнить действия, когда сцена переходит в фоновый режим
    }
}

