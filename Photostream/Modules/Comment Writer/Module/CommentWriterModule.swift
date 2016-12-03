//
//  CommentWriterModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 30/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentWriterDelegate: BaseModuleDelegate {
    
    func commentWriterDidFinish(with comment: CommentWriterData?)
    func keyboardWillMoveUp(with delta: KeyboardFrameDelta)
    func keyboardWillMoveDown(with delta: KeyboardFrameDelta)
}

protocol CommentWriterModuleInterface: BaseModuleInterface {
    
    func writeComment(with content: String)
    func addKeyboardObserver()
    func removeKeyboardObserver()
}

protocol CommentWriterBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, postId: String)
}

class CommentWriterModule: BaseModule, BaseModuleInteractable {

    typealias ModuleView = CommentWriterScene
    typealias ModuleInteractor = CommentWriterInteractor
    typealias ModulePresenter = CommentWriterPresenter
    typealias ModuleWireframe = CommentWriterWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension CommentWriterModule: CommentWriterBuilder {
    
    func build(root: RootWireframe?) {
        let service = CommentServiceProvider(session: AuthSession())
        interactor = CommentWriterInteractor(service: service)
        presenter = CommentWriterPresenter()
        wireframe = CommentWriterWireframe(root: root)
        
        interactor.output = presenter
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.view = view
        presenter.wireframe = wireframe
    }
    
    func build(root: RootWireframe?, postId: String) {
        build(root: root)
        presenter.postId = postId
    }
}
