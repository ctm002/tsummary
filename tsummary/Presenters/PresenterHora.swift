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
    private var mEditViewHora:IEditViewHora!
    
    init(_ view: IViewHora) {
        self.mView = view
        self.mEditViewHora = nil
    }
    
    init(_ view: IEditViewHora)
    {
        self.mView = nil
        self.mEditViewHora = view
    }
    
    
    func buscarHoras(){

        let fecha : String =  self.mView!.getFechaActual()
        let codigo : Int = self.mView!.IdAbogado
        if let hrs = LocalStoreTimeSummary.instance.getListDetalleHorasByCodAbogadoAndFecha(codigo: String(codigo), fecha: fecha)
        {
            self.mView?.setList(horas: hrs)
        }
    }
    
    func buscar(){
        let id : Int32 = self.mEditViewHora!.IdHora
        if let objHora = LocalStoreTimeSummary.instance.getById(id)
        {
            self.mEditViewHora.Asunto = objHora.tim_asunto
            self.mEditViewHora.Minutos = objHora.tim_minutos
            self.mEditViewHora.Horas = objHora.tim_horas
            self.mEditViewHora.ProyectoId = objHora.proyecto.pro_id
            self.mEditViewHora.setNombreProyecto(objHora.proyecto)
            self.mEditViewHora.FechaIngreso = objHora.tim_fecha_ing
        }
    }
    
    func guardar()
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
            
            objHora.proyecto.pro_id = Int32(proyectoId)
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
    
    
    func eliminar(){
        let id: Int32  = self.mEditViewHora!.IdHora
        ControladorProyecto.instance.deleteById(id)
    }
    
}
