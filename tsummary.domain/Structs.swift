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

struct HoraJSON
{
    let estado: Int
    let mensaje: String
    let data: String
}


struct Data {
    let tim_correl : Int32
    let pro_id : Int32
    let tim_fecha_ing: String
    let tim_asunto: String
    let tim_horas: Int
    let tim_minutos: Int
    let abo_id: Int
    let offLine: Bool
    let fechaInsert: String
}
