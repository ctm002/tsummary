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
    let estado: Int
    let mensaje: String
    let token: String
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
    var expiredAt: Date?
    
    class var shared: SessionLocal
    {
        struct Static {
            static let instance = SessionLocal()
        }
        return Static.instance
    }
    
    func isExpired() -> Bool
    {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Santiago")!
        calendar.locale = Locale(identifier: "es_CL")
        
        let now: Date = Date()
        let minutes : Int = calendar.dateComponents([.minute], from: now, to: self.expiredAt!).minute ?? 0
        return (minutes <= 1)
    }
}

struct HoraJSON
{
    let estado: Int
    let mensaje: String
    let data: String
}

struct DataSend : Codable{
    let Fecha: String
    let Lista: [HoraTS]
}

struct HoraTS : Codable
{
    let tim_correl : Int32
    let pro_id : Int32
    let tim_fecha_ing: String
    let tim_asunto: String
    let tim_horas : Int
    let tim_minutos : Int
    let abo_id : Int32
    let OffLine : Bool
    let FechaInsert : String
    let Estado : Int
}

struct Response
{
    let estado: Int
    let mensaje: String
    let result : Bool
}


struct ParametrosBusquedaTS: Codable
{
    let AboId : Int32
    let FechaI : String
    let FechaF : String
    let tim_correl: Int32
}

