//
//  NewsFeedWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class NewsFeedWireframe: AnyObject {

    weak var newsFeedViewController: NewsFeedViewController!
    var appWireframe: AppWireframe!
    var newsFeedPresenter: NewsFeedPresenter!

    init() {
        let session = AuthSession()
        let service = NewsFeedServiceProvider(session: session)
        let interactor = NewsFeedInteractor(service: service)
        let presenter = NewsFeedPresenter()
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self

        self.newsFeedPresenter = presenter
    }

    func navigateCommentsInterface(_ shouldComment: Bool) {
        appWireframe.navigateCommentsModule(newsFeedViewController, shouldComment: shouldComment)
    }
}
