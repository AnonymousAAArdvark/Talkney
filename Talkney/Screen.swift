//
//  Screen.swift
//  Talkney
//
//  Created by Andrew Yang on 11/10/24.
//

import Foundation

enum Screen: Hashable {
    case createAccount
    case signIn
    case emailVerification(email: String)
    case home
}
