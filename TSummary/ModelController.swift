    //
//  ModelController.swift
//  tsummary
//
//  Created by OTRO on 05-02-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import Foundation
struct ModelController
{
    var id : Int32
    var idAbogado : Int32
    var fechaHoraInicio : Date
    var idProyecto : Int32
    var nombreProyecto : String
    var nombreCliente : String
    var horaInicio : String
    var horaFin : String
    var horaTotal : String
    var asunto : String
    var correlativo: Int32
    var modificable : Bool
    var offline : Bool
    
    init(id: Int32, abogadoId: Int32, fechaHoraInicio: Date)
    {
        self.id = id
        self.idAbogado = abogadoId
        self.fechaHoraInicio = fechaHoraInicio
        self.horaInicio = "00:00"
        self.horaFin = "00:00"
        self.horaTotal = "00:00"
        self.asunto = ""
        self.correlativo = 0
        self.modificable = true
        self.offline = false
        self.idProyecto = 0
        self.nombreProyecto = ""
        self.nombreCliente = ""
    }
    
    init(id: Int32, abogadoId: Int32, fechaHoraInicio: Date,
         idProyecto: Int32, nombreProyecto: String, nombreCliente: String, horaInicio: String, horaFin: String, horaTotal: String,
         asunto: String, correlativo : Int32, modificable: Bool, offline: Bool) {
        
        self.init(id: id, abogadoId: abogadoId, fechaHoraInicio: fechaHoraInicio)
        self.horaInicio = horaInicio
        self.horaFin = horaFin
        self.horaTotal = horaTotal
        self.asunto = asunto
        self.correlativo = correlativo
        self.modificable = modificable
        self.offline = offline
        self.idProyecto = idProyecto
        self.nombreProyecto = nombreProyecto
        self.nombreCliente = nombreCliente
    }
}
