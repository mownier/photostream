
public protocol BaseModulePresenter: class {

    var view: ModuleView! { set get }
    var wireframe: ModuleWireframe! { set get }
    
    associatedtype ModuleView
    associatedtype ModuleWireframe
}
