//
//  apiModel.swift
//  Assignment4- phone contact app
//
//  Created by Administrator on 04/03/24.
//

import Foundation

struct Contacts: Codable {
    var firstName: String
    var lastName: String
    var avatarUrl: String
    var isFavourite: Bool
    var mobileNumber: String
    var email: String
    var id: String
}
