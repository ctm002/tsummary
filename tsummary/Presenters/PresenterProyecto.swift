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
    
    
    func loadHorasByFecha(fecha: Date){
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy H:mm:ss"
        
        let horas = LocalStoreTimeSummary.Instance.getListDetalleHorasByFecha(codigo: 20, fecha:dateFormatter.string(from: fecha) )
    }
    }
