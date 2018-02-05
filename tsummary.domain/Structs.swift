//
//  Structs.swift
//  tsummary
//
//  Created by OTRO on 30-01-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import Foundation
struct JWT: Decodable
{
    let token:String
}

struct User: Decodable
{
    let Nombre: String
    let Perfil: String
    let AboId: String
    let exp: Int32
    let iss: String
    let aud: String
}


class SessionLocal {
    
    var usuario: Usuario?
    var token: String?
    
    class var shared: SessionLocal {
        struct Static {
            static let instance = SessionLocal()
        }
        return Static.instance
    }
    
}


