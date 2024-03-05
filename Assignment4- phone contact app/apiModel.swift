//
//  apiModel.swift
//  Assignment4- phone contact app
//
//  Created by Administrator on 04/03/24.
//

import Foundation

struct Contacts: Decodable {
    let firstName: String
    let lastName: String
    let avatarUrl: String
    let isFavourite: Bool
    let mobileNumber: String
    let email: String
    let id: String
}
