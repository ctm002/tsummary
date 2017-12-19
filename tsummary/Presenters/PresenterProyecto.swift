//
//  PresenterProyecto.swift
//  tsummary
//
//  Created by Soporte on 12-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import Foundation

public class PresenterHora{
    
    private var mView: IViewHora
    
    init(view: IViewHora) {
        self.mView = view
    }
    
    func buscar(){

        let fecha : String =  self.mView.getFechaActual()
        let codigo : Int = self.mView.getIdAbogado()
        
        if let hrs = LocalStoreTimeSummary.Instance.getListDetalleHorasByCodAbogadoAndFecha(codigo: String(codigo), fecha: fecha)
        {
            self.mView.setList(horas: hrs)
        }
    }
}
