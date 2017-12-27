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
        
        if let hrs = LocalStoreTimeSummary.instance.getListDetalleHorasByCodAbogadoAndFecha(codigo: String(codigo), fecha: fecha)
        {
            self.mView?.setList(horas: hrs)
        }
    }
    
    func save()
    {
        do {
            
            let id: Int32  = self.mEditViewHora!.IdHora
            
            var objHora : Horas

            if let objHoraTemp = ControladorProyecto.instance.getById(id) {
                objHora = objHoraTemp
                objHora.tim_correl = 0
                objHora.Estado = .nuevo
            }
            else
            {
                objHora = Horas()
                objHora.Estado = .actualizado
            }
            
            let proyectoId = self.mEditViewHora!.ProyectoId
            let fechaIngreso = self.mEditViewHora!.FechaIngreso
            let idAbogado = self.mEditViewHora!.IdAbogado
            let asunto = self.mEditViewHora!.Asunto
            let horas = self.mEditViewHora!.Horas
            let minutos = self.mEditViewHora!.Minutos
            
            objHora.pro_id = Int32(proyectoId)
            objHora.tim_fecha_ing = fechaIngreso
            objHora.abo_id = Int(idAbogado)
            objHora.tim_asunto = asunto
            objHora.tim_horas = Int(horas)
            objHora.tim_minutos = Int(minutos)
            
            objHora.OffLine = true
            let result : Bool = ControladorProyecto.instance.save(objHora)
            if (result == true){ print("operacion exitosa") }
 
        } catch let error {
            print(error)
        }
    }
}
