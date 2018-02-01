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


class Session {
    var usuario: Usuario?
    
    class var shared: Session {
        struct Static {
            static let instance = Session()
        }
        return Static.instance
    }
}


