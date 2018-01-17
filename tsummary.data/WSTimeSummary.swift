//
//  data.swift
//  tsummary
//
//  Created by Soporte on 01-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import Foundation


class WSTimeSummary: NSObject
{
    private var  _urlWebService : String = "https://timesummary.cariola.cl/WebApiCariola/ws/api.asmx/";

    private var  username: String
    private var  password: String
    private var credential: URLCredential!
    
    static let instance : WSTimeSummary = WSTimeSummary(username:"carlos_tapia", password:"Car.2711")
    
    init(username:String, password: String) {
        
        self.username = username
        self.password = password
    }
    
    func registrar(imei:String?,userName:String?,password:String?, callback: @escaping (Usuario?) -> Void)
    {
        let conn: URLSession =
        {
            let config = URLSessionConfiguration.ephemeral
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            return session
        }()
        
        let urlString = _urlWebService + "AutenticarUsuario"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
        
        var postData: String = ""
        postData.append("User=" + userName! + "&");
        postData.append("Pwrd=" + password! + "&");
        postData.append("IMEI=" + imei!);
        request.httpBody = postData.data(using: String.Encoding.utf8);
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = conn.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
                callback(nil)
            }

            //print(response)

            if (data != nil)
            {
                do{
                    var obj : Dictionary<String, AnyObject> =  try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, AnyObject>
                    if (obj["DatosUsuario"] != nil)
                    {
                        let dic: AnyObject = obj["DatosUsuario"]!
                        let id : Int32 = dic["AboId"] as! Int32
                        let nombre : String = dic["Nombre"] as! String
                        let grupo : String = dic["Grupo"] as! String
                        
                        let usuario: Usuario? = Usuario()
                        usuario?.Id = id
                        usuario?.Nombre=nombre
                        usuario?.Grupo = grupo
                        usuario?.IMEI = imei
                        callback(usuario)
                    }
                    else
                    {
                        callback(nil)
                    }
                }
                catch
                {
                    print("Error:\(error)")
                }
            }
        })
        task.resume()
    }
    
    
    func obtListDetalleHorasByCodAbogado(codigo: String, callback: @escaping ([Horas]?) -> Void, _ fechaDesde:Date?, _ fechaHasta:Date?)
    {
        var conn: URLSession = {
            let config = URLSessionConfiguration.ephemeral
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            return session
        }()
        
        let urlString = _urlWebService + "ObtenerHorasPorAbogado"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"

        
        var postData: String = ""
        postData.append("abo_id=" + codigo)
        request.httpBody = postData.data(using: String.Encoding.utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
     
        let task = conn.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
                print(error)
                callback(nil)
                return
            }
            
            if (data != nil)
            {
                do{
                    var horas = [Horas]()
                    let datos =  try JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                    for d  in datos
                    {
                        var hora = Horas()
                        hora.proyecto.pro_id =  d["pro_id"] as! Int32
                        hora.tim_correl  = d["tim_correl"] as! Int32
                        hora.tim_horas =  d["tim_horas"] as! Int
                        hora.tim_minutos = d["tim_minutos"] as! Int
                        hora.tim_asunto = d["tim_asunto"] as! String
                        hora.modificable = d["Modificable"]  as! Int == 1 ? true : false;
                        //hora.OffLine = d["OffLine"]  as! Int == 1 ? true : false;
                        hora.abo_id = d["abo_id"] as! Int
                        hora.tim_fecha_ing = d["tim_fecha_ing"] as! String
                        horas.append(hora)
                    }
                    callback(horas)
                }
                catch
                {
                    print("Error:\(error)")
                }
            }
        })
        task.resume()
    }
    
    
    func sincronizar(codigo: String, horas:String)
    {
        var conn: URLSession = {
            let config = URLSessionConfiguration.ephemeral
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            return session
        }()
        
        let urlString = _urlWebService + "SincronizacionData"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
        
        
        var postData: String = ""
        postData.append("abo_id=" + codigo + "&")
        postData.append("Horas=" + horas)
        request.httpBody = postData.data(using: String.Encoding.utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = conn.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
                print(error)
                //callback(nil)
                return
            }
            
        })
        task.resume()
    }
    
    func obtListProyectosByCodAbogado(codigo: String, callback: @escaping ([ClienteProyecto]?) -> Void)
    {
        
        var conn: URLSession = {
            let config = URLSessionConfiguration.ephemeral
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            return session
        }()
        
        let urlString = _urlWebService + "ObtenerClienteProyectoPorAbogado"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
        
        
        var postData: String = ""
        postData.append("piAbo=" + codigo + "&")
        postData.append("piCantidad=20")
        request.httpBody = postData.data(using: String.Encoding.utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = conn.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
                print(error)
                callback(nil)
                return
            }
            
            //print(response)
            
            if (data != nil)
            {
                do{
                    var proyectos = [ClienteProyecto]()
                    let datos =  try JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                    for d  in datos
                    {
                        let proyecto = ClienteProyecto()
                        proyecto.pro_id = d["pro_id"] as! Int32
                        proyecto.cli_nom = d["cli_nom"] as! String
                        proyecto.pro_nombre = d["pro_nombre"] as! String
                        proyecto.pro_idioma = d["Idioma"] as! String
                        proyectos.append(proyecto)
                    }
                    callback(proyectos)
                }
                catch
                {
                    print("Error:\(error)")
                }
            }
        })
        task.resume()
    }
    
    func guardar(hora: Horas, retorno: @escaping (Horas?) -> Void)
    {
        let conn: URLSession =
        {
            let config = URLSessionConfiguration.ephemeral
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            return session
        }()
    
        let urlString = _urlWebService + "GuardarInformacion"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
    
        var postData: String = ""
        postData.append("tim_correl=" +  String(hora.tim_correl) + "&")
        postData.append("pro_id=" + String(hora.proyecto.pro_id) + "&")
        postData.append("tim_fecha_ing=" + hora.tim_fecha_ing + "&")
        postData.append("tim_asunto=" + hora.tim_asunto + "&")
        postData.append("tim_horas=" + String(hora.tim_horas) + "&")
        postData.append("tim_minutos=" + String(hora.tim_minutos) + "&")
        postData.append("abo_id=" + String(hora.abo_id) + "&")
        postData.append("OffLine= " + String(hora.offline))
        request.httpBody = postData.data(using: String.Encoding.utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
        let task = conn.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
                retorno(nil)
                return
            }
            
            if (data != nil)
            {
                do{
                    let data =  try JSONSerialization.jsonObject(with: data!, options: []) as! AnyObject
                    hora.tim_correl = data["tim_correl"] as! Int32
                    retorno(hora)
                }
                catch
                {
                    print("Error:\(error)")
                }
            }
        })
        task.resume()
    }
    
    func eliminar(hora: Horas, retorno: @escaping (Horas?) -> Void)
    {
        let conn: URLSession =
        {
            let config = URLSessionConfiguration.ephemeral
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            return session
        }()
        
        let urlString = _urlWebService + "GuardarInformacion"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
        
        var postData: String = ""
        postData.append("tim_correl=" +  String(hora.tim_correl))
        request.httpBody = postData.data(using: String.Encoding.utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = conn.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
                retorno(nil)
                return
            }
            
            if (data != nil)
            {
                do{
                    let data =  try JSONSerialization.jsonObject(with: data!, options: []) as! AnyObject
                    retorno(hora)
                }
                catch
                {
                    print("Error:\(error)")
                }
            }
        })
        task.resume()
    }
}

extension WSTimeSummary: URLSessionDelegate
{
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        //print("got challenge")
        
        guard challenge.previousFailureCount == 0 else {
            print("too many failures")
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM else {
            
            if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
            {
                let credentials = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                challenge.sender?.use(credentials, for: challenge)
                completionHandler(.useCredential, credentials)
            }
            /*
            else
            {
                print("unknown authentication method \(challenge.protectionSpace.authenticationMethod)")
                challenge.sender?.cancel(challenge)
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            */
            return
        }
        
        let credentials = URLCredential(user: self.username, password: self.password, persistence: .permanent)
        challenge.sender?.use(credentials, for: challenge)
        completionHandler(.useCredential, credentials)
    }
}



