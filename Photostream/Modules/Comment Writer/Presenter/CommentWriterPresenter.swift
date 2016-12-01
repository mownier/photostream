//
//  CommentWriterPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 30/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentWriterPresenterInterface: BaseModulePresenter, BaseModuleInteractable, BaseModuleDelegatable {
    
    var postId: String! { set get }
}

class CommentWriterPresenter: CommentWriterPresenterInterface {

    typealias ModuleView = CommentWriterScene
    typealias ModuleInteractor = CommentWriterInteractorInput
    typealias ModuleWireframe = CommentWriterWireframeInterface
    typealias ModuleDelegate = CommentWriterDelegate
    
    weak var delegate: ModuleDelegate?
    weak var view: ModuleView!
    
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
    var postId: String!
}

extension CommentWriterPresenter: CommentWriterInteractorOutput {
    
    func interactorDidFinish(with comment: CommentWriterData) {
        view.didWrite(with: nil)
        delegate?.commentWriterDidFinish(with: comment)
    }
    
    func interactorDidFinish(with error: CommentServiceError) {
        view.didWrite(with: error.message)
        delegate?.commentWriterDidFinish(with: error)
    }
}

extension CommentWriterPresenter: CommentWriterModuleInterface {
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
    
    func writeComment(with content: String) {
        interactor.write(with: postId, and: content)
    }
}
