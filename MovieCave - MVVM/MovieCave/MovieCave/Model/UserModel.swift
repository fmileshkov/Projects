//
//  UserModel.swift
//  MovieCave
//
//  Created by Admin on 5.10.23.
//

import Foundation

struct UserRequestData: Codable {
    var requestToken: String
    var success: Bool
}

struct UserAccessData: Codable {
    var accessToken: String
    var accountId: String
    var success: Bool
}

struct UserModel: Codable {
    var username: String
    var lastLogIn: String?
    var validAcessToken: String?
    var userAccID: String?
}
