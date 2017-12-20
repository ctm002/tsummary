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
    
    func getIdAbogado() -> Int
    
    func getFechaActual() -> String
}


protocol IListViewProyecto {
    
    func setList(proyectos: [ClienteProyecto])
    
    func getIdAbogado() -> Int
    
}
