//
//  Usuario.swift
//  tsummary
//
//  Created by Soporte on 01-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import Foundation
public class  Usuario {
    
    init() {
        self.mId=0
        self.mNombre=""
        self.mGrupo = ""
        self.mLoginName = ""
        self.mPassword=""
        self.mIMEI=""
        self.mDefault=0
    }
    
    private var mId : Int32
    var Id:Int32  { get{ return self.mId } set{ self.mId=newValue }}
    
    private var mNombre: String?
    var Nombre:String? { get{ return self.mNombre} set {self.mNombre=newValue }}
    
    private var mGrupo:String?
    var Grupo:String? { get {return self.mGrupo } set{ self.mGrupo=newValue }}
    
    private var mLoginName:String?
    var LoginName:String? {  get{ return self.mLoginName } set { self.mLoginName=newValue }}
    
    private var mPassword:String?
    var Password:String? { return self.mPassword }
    
    private var mIMEI:String?
    var  IMEI:String?  { get { return self.mIMEI } set { self.mIMEI = newValue }}
    
    private var mDefault:Int?
    var Default:Int?  { return self.mDefault }
}

public  class Cliente {

    init() {
        self.mcli_cod = 0
        self.mcli_nom=""
        self.mpro_id=0
    }
    
    private var mcli_cod:Int?
    public var cli_cod : Int? { get { return mcli_cod} set {mcli_cod = newValue} }
    
    private var mcli_nom:String?
    var cli_nom: String? { get { return mcli_nom} set { mcli_nom = newValue} }
    
    private var mpro_id: Int32?
    var pro_id: Int32? { get { return mpro_id} set {mpro_id = newValue} }
  
}


public class ClienteProyecto {
    
    init() {
        self.mcli_nom = ""
        self.mpro_id = 0
        self.mpro_nombre  = ""
        self.mpro_idioma = ""
    }
    
    private var mcli_nom: String
    public var cli_nom: String { get{return self.mcli_nom} set {self.mcli_nom=newValue} }
    
    private var mpro_id: Int32
    public var pro_id: Int32 { get{return self.mpro_id} set {self.mpro_id=newValue} }
    
    private var mpro_nombre: String
    public var pro_nombre: String { get{ return self.mpro_nombre} set {self.mpro_nombre=newValue} }
    
    private var  mpro_idioma: String
    public var pro_idioma: String { get{return self.mpro_idioma}  set{  self.mpro_idioma=newValue} }
}

enum Estados: Int
{
    case nuevo
    case actualizado
    case eliminado
}

public class Horas {
    let formatter = DateFormatter()
    
    
    init() {
        self.mtim_correl = 0
        self.mtim_asunto = ""
        self.mtim_horas = 0
        self.mtim_minutos = 0
        self.mabo_id = 0
        self.mModificable = false
        self.mOffLine = false
        self.mtim_fecha_ing = Date()
        self.mIdHora = 0
        self.mEstado = .nuevo
        self.mpro_id = 0
        self.proyecto = ClienteProyecto()
        formatter.locale = Locale(identifier: "es_CL")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
    }
    
    private var mEstado: Estados
    var Estado: Estados { get { return self.mEstado } set { self.mEstado = newValue}}
    
    private var mIdHora: Int32
    var IdHora: Int32 { get { return self.mIdHora } set { self.mIdHora = newValue}}
    
    private var mtim_correl:Int32
    var tim_correl: Int32 { get { return self.mtim_correl } set { self.mtim_correl = newValue} }
    
    private var mtim_fecha_ing: Date
    var tim_fecha_ing: String {
        get {
            
            if (self.mtim_fecha_ing != nil)
            {
                let strFechaIng : String = formatter.string(from: self.mtim_fecha_ing)
                return strFechaIng
            }
            return ""
        }
        set {
            
            if (newValue != nil)
            {
                let dtFechaIng : Date? = formatter.date(from:newValue)
                if (dtFechaIng != nil)
                {
                    self.mtim_fecha_ing = dtFechaIng!
                }
            }
        }
    }
    
    var tim_fecha_ing_hh_mm: String {
        get {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.locale = Locale(identifier: "es_CL")
            formatter.dateFormat = "HH:mm"
            let strFechaIng : String = formatter.string(from:mtim_fecha_ing)
            return strFechaIng
        }
    }
    
    private var mtim_asunto: String
    var tim_asunto: String { get { return self.mtim_asunto } set { self.mtim_asunto = newValue} }
    
    private var mtim_horas:Int
    var tim_horas:Int { get { return self.mtim_horas } set { self.mtim_horas=newValue} }
    
    private var mtim_minutos:Int
    var tim_minutos: Int { get { return self.mtim_minutos } set { self.mtim_minutos = newValue} }
    
    private var mabo_id:Int
    var  abo_id: Int { get { return self.mabo_id } set { self.mabo_id = newValue} }
    
    private var mModificable: Bool
    var  modificable: Bool { get { return self.mModificable } set { self.mModificable = newValue} }
    
    private var mOffLine: Bool
    var offline: Bool { get { return self.mOffLine } set { self.mOffLine = newValue} }
    
    
    private var mpro_id:Int32
    var pro_id: Int32 { get {return self.mpro_id} set {self.mpro_id = newValue} }
    
    /*
    private var mNombreProyecto: String
    var NombreProyecto: String { get{return self.mNombreProyecto} set {self.mNombreProyecto = newValue}}
    
    private var mNombreCliente: String
    var NombreCliente: String { get{return self.mNombreCliente} set {self.mNombreCliente = newValue}}
    */
    
    private var mProyecto: ClienteProyecto!
    var proyecto: ClienteProyecto {
        get {
            return self.mProyecto
        }
        set {
            self.mProyecto = newValue
        }
    }
}

public class Dia {
    
    init() {
        self.mNombre = ""
        self.mNro = 0
        self.mFecha = ""
    }
    
    private var mNombre:String
    var nombre:String { get { return self.mNombre } set { self.mNombre = newValue}}
    
    private var mNro:Int
    var nro: Int {get {return self.mNro} set {self.mNro = newValue}}

    private var mFecha: String
    var Fecha: String { get{return self.mFecha} set{ self.mFecha=newValue}}
}
