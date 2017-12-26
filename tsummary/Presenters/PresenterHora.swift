//
//  PresenterProyecto.swift
//  tsummary
//
//  Created by Soporte on 12-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import Foundation

public class PresenterHora{
    
    private var mView: IViewHora?
    private var mEditViewHora:IEditViewHora?
    
    init(_ view: IViewHora) {
        self.mView = view
        self.mEditViewHora = nil
    }
    
    init(_ view: IEditViewHora)
    {
        self.mView = nil
        self.mEditViewHora = view
    }
    
    
    func buscar(){

        let fecha : String =  self.mView!.getFechaActual()
        let codigo : Int = self.mView!.IdAbogado
        
        if let hrs = LocalStoreTimeSummary.Instance.getListDetalleHorasByCodAbogadoAndFecha(codigo: String(codigo), fecha: fecha)
        {
            self.mView?.setList(horas: hrs)
        }
    }
    
    func save()
    {
        //let id  = self.mEditViewHora!.getIdHora()
        //let proyectoId = self.mEditViewHora!.getproyectoId()
        //let fechaIngreso = self.mEditViewHora!.getFechaIngreso()
    }
}
