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

        let fecha : String =  self.mView!.FechaIngreso
        let codigo : Int = self.mView!.IdAbogado
        if let hrs = DataBase.horas.getListDetalleHorasByCodAbogadoAndFecha(codigo: String(codigo), fecha: fecha)
        {
            self.mView?.setList(horas: hrs)
        }
    }
    
    func buscar(){
        let id : Int32 = self.mEditViewHora!.IdHora
        if let objHora : Horas = DataBase.horas.getById(id)
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
        do
        {
            let id: Int32  = self.mEditViewHora!.IdHora
            
            var detalleHora : Horas
            if let detalleHoraTemp = DataBase.horas.getById(id)
            {
                detalleHora = detalleHoraTemp
                detalleHora.tim_correl = 0
                detalleHora.Estado = .nuevo
            }
            else
            {
                detalleHora = Horas()
                detalleHora.Estado = .actualizado
            }
            
            let proyectoId = self.mEditViewHora!.ProyectoId
            let fechaIngreso = self.mEditViewHora!.FechaIngreso
            let idAbogado = self.mEditViewHora!.IdAbogado
            let asunto = self.mEditViewHora!.Asunto
            let cantHoras = self.mEditViewHora!.Horas
            let cantMinutos = self.mEditViewHora!.Minutos
            
            detalleHora.proyecto.pro_id = Int32(proyectoId)
            detalleHora.tim_fecha_ing = fechaIngreso
            detalleHora.abo_id = Int(idAbogado)
            detalleHora.tim_asunto = asunto
            detalleHora.tim_horas = Int(cantHoras)
            detalleHora.tim_minutos = Int(cantMinutos)
            detalleHora.OffLine = true
            
            let result : Bool = DataBase.horas.save(detalleHora)
            if (result == true){ print("operacion exitosa") }
 
        }
        catch let error {
            print(error)
        }
    }
    
    
    func eliminar(){
        let id: Int32  = self.mEditViewHora!.IdHora
        ControladorLogica.instance.deleteById(id)
    }
}
