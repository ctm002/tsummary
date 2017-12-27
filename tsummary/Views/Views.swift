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
    
    func setList(horas: [Horas])
    
    var IdAbogado : Int { get set }
    
    func getFechaActual() -> String
}


protocol IListViewProyecto {
    
    func setList(proyectos: [ClienteProyecto])
    
    var IdAbogado : Int { get set }
    
}

protocol IEditViewHora {
    var IdHora : Int32 { get set }
    var ProyectoId : Int32 { get set }
    var FechaIngreso : Date { get set }
    var IdAbogado : Int { get set }
    var Horas : Int { get set }
    var Minutos : Int { get set }
    var Asunto : String { get set }
    var TimCorrel: Int32 {get set }
}
