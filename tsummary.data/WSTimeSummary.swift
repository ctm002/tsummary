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
    private var  _urlWebService : String = "http://timesummary.cariola.cl/WebApiCariola/ws/api.asmx/";//
    //private var  _urlWebService : String = "http://10.1.11.42/WebApiCariola/ws/api.asmx/";
    private var _urlHost: String  = "http://timesummary.cariola.cl";
   
    private var  username: String
    private var  password: String
    private var credential: URLCredential!
    
    static let Instance : WSTimeSummary = WSTimeSummary(username:"carlos_tapia", password:"Car.2711")
    
    init(username:String, password: String) {
        
        self.username = username
        self.password = password
    }
    
    func registrar(imei:String?,userName:String?,password:String?, callback: @escaping (Usuario?) -> Void)
    {
        var conn: URLSession =
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
                print(error)
                callback(nil)
            }

            print(response)

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
                        
                        var usuario: Usuario? = Usuario()
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
    
    
    func getListDetalleHorasByCodAbogado(codigo: String, callback: @escaping ([Horas]?) -> Void)
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
        
            //print(response)
            
            if (data != nil)
            {
                do{
                    var horas = [Horas]()
                    let datos =  try JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                    for d  in datos
                    {
                        var hora = Horas()
                        hora.pro_id =  d["pro_id"] as! Int32
                        hora.tim_correl  = d["tim_correl"] as! Int32
                        hora.tim_horas =  d["tim_horas"] as! Int32
                        hora.tim_minutos = d["tim_minutos"] as! Int32
                        hora.tim_asunto = d["tim_asunto"] as! String
                        hora.Modificable = d["Modificable"]  as! Int == 1 ? true : false;
                        //hora.OffLine = d["OffLine"]  as! Int == 1 ? true : false;
                        hora.abo_id = d["abo_id"] as! Int32
                        hora.tim_fecha_ing = DateFormatter().date(from: (d["tim_fecha_ing"] as! String))
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
}


extension WSTimeSummary: URLSessionDelegate
{
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("got challenge")
        
        guard challenge.previousFailureCount == 0 else {
            print("too many failures")
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM else {
            print("unknown authentication method \(challenge.protectionSpace.authenticationMethod)")
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let credentials = URLCredential(user: self.username, password: self.password, persistence: .permanent)
        challenge.sender?.use(credentials, for: challenge)
        completionHandler(.useCredential, credentials)
    }
}



