//
//  SinglePostScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol SinglePostScene: BaseModuleView {

    var presenter: SinglePostModuleInterface! { set get }
    var isLoadingViewHidden: Bool { set get }
    
    func reload()
    
    func didFetch(error: String?)
    func didLike(error: String?)
    func didUnlike(error: String?)
}
