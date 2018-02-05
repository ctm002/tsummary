//
//  IViewList.swift
//  tsummary
//
//  Created by Soporte on 11-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import Foundation

protocol IListViewSemana {
    func setList(semana: [Dia])
}

protocol IViewHora {
    var idAbogado : Int { get set }
    var fechaHoraIngreso : String { get set }
    func setList(horas: [Hora])
}


protocol IListViewProyecto {
    var idAbogado : Int { get set }
    func setList(proyectos: [ClienteProyecto])
}

protocol IEditViewHora {
    var idHora : Int32 { get set }
    var proyectoId : Int32 { get set }
    var fechaHoraIngreso : Date { get set }
    var idAbogado : Int { get set }
    var horas : Int { get set }
    var minutos : Int { get set }
    var asunto : String { get set }
    var timCorrel: Int32 {get set }
    func setNombreProyecto(_ proyecto : ClienteProyecto)
    func bloquearBotones(_ estado: Bool)
}
