
public protocol BaseModule: class {
    
    var presenter: ModulePresenter! { set get }
    var wireframe: ModuleWireframe! { set get }
    var view: ModuleView! { set get }
    
    init(view: ModuleView)
    
    associatedtype ModulePresenter
    associatedtype ModuleWireframe
    associatedtype ModuleView
}

public protocol BaseModuleInteractable: class {
    
    var interactor: ModuleInteractor! { set get }
    
    associatedtype ModuleInteractor
}

public protocol BaseModuleDelegate: class {
    
}

public protocol BaseModuleDelegatable: class {
    
    var delegate: ModuleDelegate? { set get }
    
    associatedtype ModuleDelegate
}

public protocol BaseModuleBuilder: class {
    
    func build(root: RootWireframe?)
}

public protocol BaseModuleInterface: class {
    
    func exit()
}

public protocol BaseModuleDependency: class {
    
}

public protocol BaseModuleWireframeDependency: class {
    
}
