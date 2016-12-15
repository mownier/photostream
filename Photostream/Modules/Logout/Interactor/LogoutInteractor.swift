//
//  LogoutInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol LogoutInteractorInput: BaseModuleInteractorInput {
    
    func logout()
}

protocol LogoutInteractorOutput: BaseModuleInteractorOutput {
    
    func didLogoutFail(with error: AuthenticationServiceError)
    func didLogoutOk()
}

protocol LogoutInteractorInterface: BaseModuleInteractor {
    
    var service: AuthenticationService! { set get }
    
    init(service: AuthenticationService)
}

class LogoutInteractor: LogoutInteractorInterface {
    
    typealias Output = LogoutInteractorOutput
    
    weak var output: Output?
    
    var service: AuthenticationService!
    
    required init(service: AuthenticationService) {
        self.service = service
    }
}

extension LogoutInteractor: LogoutInteractorInput {
    
    func logout() {
        service.logout { (error) in
            guard error == nil else {
                self.output?.didLogoutFail(with: error!)
                return
            }
            
            self.output?.didLogoutOk()
        }
    }
}
