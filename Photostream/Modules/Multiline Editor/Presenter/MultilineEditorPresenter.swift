//
//  MultilineEditorPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol MultilineEditorPresenterInterface: BaseModulePresenter, BaseModuleDelegatable {
    
    var defaultText: String { set get }
}

class MultilineEditorPresenter: MultilineEditorPresenterInterface {

    typealias ModuleView = MultilineEditorScene
    typealias ModuleWireframe = MultilineEditorWireframeInterface
    typealias ModuleDelegate = MultilineEditorDelegate
    
    weak var delegate: ModuleDelegate?
    weak var view: ModuleView!
    var wireframe: ModuleWireframe!
    var defaultText: String = ""
}

extension MultilineEditorPresenter: MultilineEditorModuleInterface {
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
    
    func viewDidLoad() {
        view.setupDefaultText(text: defaultText)
    }
    
    func cancel() {
        delegate?.multilineEditorDidCancel()
        exit()
    }
    
    func save(text: String) {
        delegate?.multilineEditorDidSave(text: text)
        exit()
    }
}
