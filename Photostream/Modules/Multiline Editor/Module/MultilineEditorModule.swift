//
//  MultilineEditorModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol MultilineEditorModuleInterface: BaseModuleInterface {

    func viewDidLoad()
    func cancel()
    func save(text: String)
}

protocol MultilineEditorDelegate: BaseModuleDelegate {
    
    func multilineEditorDidCancel()
    func multilineEditorDidSave(text: String)
}

protocol MultilineEditorBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, defaultText: String, delegate: MultilineEditorDelegate?)
}

class MultilineEditorModule: BaseModule {
    
    typealias ModuleView = MultilineEditorScene
    typealias ModulePresenter = MultilineEditorPresenter
    typealias ModuleWireframe = MultilineEditorWireframe
    
    var view: ModuleView!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension MultilineEditorModule: MultilineEditorBuilder {
    
    func build(root: RootWireframe?) {
        presenter = MultilineEditorPresenter()
        wireframe = MultilineEditorWireframe(root: root)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.wireframe = wireframe
    }
    
    func build(root: RootWireframe?, defaultText: String = "", delegate: MultilineEditorDelegate?) {
        build(root: root)
        presenter.delegate = delegate
        presenter.defaultText = defaultText
    }
}
