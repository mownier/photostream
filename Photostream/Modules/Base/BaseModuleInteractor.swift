
public protocol BaseModuleInteractor: class {

    var output: Output? { set get }
    
    associatedtype Output
}

public protocol BaseModuleInteractorInput: class {
    
}

public protocol BaseModuleInteractorOutput: class {
    
}
