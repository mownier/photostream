//
//  MulltilineEditorView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol MultilineEditorScene: BaseModuleView {

    var presenter: MultilineEditorModuleInterface! { set get }
    
    func setupDefaultText(text: String)
}
