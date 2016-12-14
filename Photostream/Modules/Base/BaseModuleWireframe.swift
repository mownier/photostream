
import UIKit

public protocol RootWireframe: class {
    
    var window: UIWindow! { set get }
}

public enum WireframeStyle {
    case unknown
    case push
    case present
    case attach
    case root
}

public struct WireframeEntryProperty {
    
    public var animated: Bool = true
    public var controller: UIViewController?
    public var parent: UIViewController?
}

public struct WireframeExitProperty {
    
    public var controller: UIViewController?
    public var animated: Bool = true
}

public protocol BaseModuleWireframe: class {
    
    var root: RootWireframe? { set get }
    var style: WireframeStyle! { set get }
    
    init(root: RootWireframe?)
    
    func enter(with property: WireframeEntryProperty)
    func exit(with property: WireframeExitProperty)
}

extension BaseModuleWireframe {
    
    public func enter(with property: WireframeEntryProperty) {
        guard let controller = property.controller,
            let parent = property.parent else {
            return
        }
        
        switch style! {
        case .push where parent.navigationController != nil:
            parent.navigationController!.pushViewController(controller, animated: property.animated)
        case .present:
            parent.present(controller, animated: property.animated, completion: nil)
        case .attach:
            parent.view.addSubview(controller.view)
            parent.addChildViewController(controller)
            controller.didMove(toParentViewController: parent)
        case .root where root != nil:
            root!.window.rootViewController = controller
        default:
            break
        }
    }
    
    public func exit(with property: WireframeExitProperty) {
        guard let controller = property.controller else {
            return
        }
        
        switch style! {
        case .push where controller.navigationController != nil:
            let _ = controller.navigationController!.popViewController(animated: property.animated)
        case .present:
            controller.dismiss(animated: property.animated, completion: nil)
        case .attach where controller.parent != nil:
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
            controller.didMove(toParentViewController: nil)
        default:
            break
        }
    }
}
