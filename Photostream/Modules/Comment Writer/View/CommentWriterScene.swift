//
//  CommentWriterScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 30/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentWriterScene: BaseModuleView {

    var presenter: CommentWriterModuleInterface! { set get }
    
    func didWrite(with error: String?)
    
    func keyboardWillMove(with handler: inout KeyboardHandler)
}
