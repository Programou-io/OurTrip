import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let newWindow = UIWindow(windowScene: windowScene)
        
        let controller = UIViewController()
        controller.view.backgroundColor = .red
        
        window = newWindow
        
        newWindow.rootViewController = controller
        newWindow.makeKeyAndVisible()
    }
}
