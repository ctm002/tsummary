import Foundation
import JWTDecode

class ApiClient: NSObject
{
    private var strURL : String = "https://docroom.cariola.cl/"
    
    private var  username: String
    private var  password: String
    private var credential: URLCredential!
    
    static let instance : ApiClient = ApiClient(username:"carlos_tapia", password:"Car.2711")
    
    init(username:String, password: String) {
        
        self.username = username
        self.password = password
    }
    
    func registrar(imei:String?,userName:String?,password:String?, callback: @escaping (SessionLocal?) -> Void)
    {
        let urlSession: URLSession = URLSession.shared
        let url = URL(string:self.strURL + "tokenmobile")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        
        var postData: String = ""
        postData.append("{\"usuario\":\"" + userName! + "\"," );
        postData.append("\"imei\":\"" + imei! + "\"," );
        postData.append("\"password\":\"" + password! + "\"}");
        request.httpBody = postData.data(using: String.Encoding.utf8);
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if(error != nil)
            {
                callback(nil)
            }
            
            if (data != nil)
            {
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print(responseString)
                if (responseString == "")
                {
                    callback(nil)
                }
                else
                {
                    do
                    {
                        let usuario: Usuario = Usuario()
                        let jsonwt = try JSONDecoder().decode(JWT.self, from: data!)
                        
                        let jwt = try decode(jwt: jsonwt.token)
                        
                        let cNombre = jwt.claim(name: "Nombre")
                        if let nombre = cNombre.string{
                            usuario.nombre=nombre
                        }
                        
                        let cPerfil = jwt.claim(name: "Perfil")
                        if let perfil = cPerfil.string{
                            usuario.perfil = perfil
                        }
                        
                        let cIdAbogado = jwt.claim(name: "AboId")
                        if let idAbogado = cIdAbogado.integer {
                            usuario.id = Int32(idAbogado)
                        }
                        
                        let cGrupo = jwt.claim(name: "Grupo")
                        if let grupo = cGrupo.string
                        {
                            usuario.grupo = grupo
                        }
                        
                        usuario.password = password
                        usuario.imei = imei
                        usuario.loginName = userName
                        
                        SessionLocal.shared.token = jsonwt.token
                        SessionLocal.shared.usuario = usuario
                        callback(SessionLocal.shared)
                    }
                    catch
                    {
                        print("Error:\(error)")
                    }
                }
            }
        })
        task.resume()
    }
    
    
    func obtListDetalleHorasByCodAbogado(_ session: SessionLocal,_ fechaDesde: String,_ fechaHasta: String, callback: @escaping ([Hora]?) -> Void)
    {
        let urlSession: URLSession = URLSession.shared
        let sURL : String = "\(self.strURL)api/Horas/GetHorasByParameters?AboId=\(session.usuario?.id)&FechaI=\(fechaDesde)&FechaF=\(fechaHasta)"
        let url = URL(string: "\(sURL)")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5000)
        request.httpMethod = "GET"
        request.setValue("bearer \(session.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
                callback(nil)
                return
            }
            
            if (data != nil)
            {
                do
                {
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                    if (responseString != "")
                    {
                        var horas = [Hora]()
                        let dataJSON = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                        let aJSON = dataJSON["data"] as! [AnyObject]
                        for item in aJSON
                        {
                            let hora = Hora()
                            hora.proyecto.id = item["pro_id"] as! Int32
                            hora.tim_correl = item["tim_correl"] as! Int32
                            hora.horasTrabajadas = item["tim_horas"] as! Int
                            hora.minutosTrabajados = item["tim_minutos"] as! Int
                            hora.asunto = item["tim_asunto"] as! String
                            hora.modificable = item["nro_folio"] as! Int == 0 ? true : false;
                            hora.abogadoId = item["abo_id"] as! Int
                            hora.fechaHoraIngreso = Utils.toDateFromString(item["fechaInicio"] as! String, "yyyy-MM-dd'T'HH:mm:ss")!
                            hora.fechaInsert = Utils.toDateFromString((item["tim_fecha_insert"] as! String), "yyyy-MM-dd'T'HH:mm:ss.SSS")!
                            horas.append(hora)
                        }
                        callback(horas)
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
    
    func obtListProyectosByCodAbogado(_ session: SessionLocal, callback: @escaping ([ClienteProyecto]?) -> Void)
    {
        let urlSession: URLSession = URLSession.shared
        let sURL = "\(self.strURL)api/ClienteProyecto/getUltimosProyectoByAbogado?AboId=\(session.usuario?.id)"
        let url = URL(string: sURL)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.setValue("bearer \(session.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
                callback(nil)
                return
            }
            
            if (data != nil)
            {
                do
                {
                    var proyectos = [ClienteProyecto]()
                    let dataJSON = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                    let aJSON = dataJSON["data"] as! [AnyObject]
                    for item in aJSON
                    {
                        let proyecto = ClienteProyecto()
                        proyecto.id = item["pro_id"] as! Int32
                        proyecto.codigoCliente = item["cli_cod"] as! Int
                        proyecto.nombreCliente = item["nombreCliente"] as! String
                        proyecto.nombre = item["nombreProyecto"] as! String
                        proyecto.idiomaCliente = item["idioma"] as! String
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
    
    func guardar(hora: Hora, responseOK: @escaping (Hora) -> Void,  responseError: @escaping (Hora) -> Void)
    {
        let urlSession: URLSession = URLSession.shared
        let url = URL(string: self.strURL + "GuardarInformacion")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        
        var postData: String = ""
        postData.append("tim_correl=" +  String(hora.tim_correl) + "&")
        postData.append("pro_id=" + String(hora.proyecto.id) + "&")
        postData.append("tim_fecha_ing=" + Utils.toStringFromDate(hora.fechaHoraIngreso,"yyyy-MM-dd HH:mm:ss") + "&")
        postData.append("tim_asunto=" + hora.asunto + "&")
        postData.append("tim_horas=" + String(hora.horasTrabajadas) + "&")
        postData.append("tim_minutos=" + String(hora.minutosTrabajados) + "&")
        postData.append("abo_id=" + String(hora.abogadoId) + "&")
        postData.append("OffLine= " + String(hora.offline) + "&")
        postData.append("FechaInsert=" +  Utils.toStringFromDate(hora.fechaInsert!))
        request.httpBody = postData.data(using: String.Encoding.utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer \(SessionLocal.shared.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
                responseError(hora)
                return
            }
            
            if (data != nil)
            {
                do{
                    let data =  try JSONSerialization.jsonObject(with: data!, options: []) as! AnyObject
                    hora.tim_correl = data["tim_correl"] as! Int32
                    responseOK(hora)
                }
                catch
                {
                    print("Error:\(error)")
                }
            }
        })
        task.resume()
    }
    
    func eliminar(hora: Hora, responseOK: @escaping (Hora) -> Void, responseError: @escaping (Hora) -> Void)
    {
        let urlSession: URLSession = URLSession.shared
        
        let url = URL(string: self.strURL + "GuardarInformacion")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        
        var postData: String = ""
        postData.append("tim_correl=" +  String(hora.tim_correl))
        request.httpBody = postData.data(using: String.Encoding.utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer \(SessionLocal.shared.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
                responseError(hora)
                return
            }
            
            if (data != nil)
            {
                do
                {
                    let data =  try JSONSerialization.jsonObject(with: data!, options: []) as! AnyObject
                    responseOK(hora)
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


/*
 extension ApiClient: URLSessionLocalDelegate
 {
 
 func urlSessionLocal(_ SessionLocal: URLSessionLocal, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSessionLocal.AuthChallengeDisposition, URLCredential?) -> Void) {
 
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
 
 return
 }
 
 let credentials = URLCredential(user: self.username, password: self.password, persistence: .permanent)
 challenge.sender?.use(credentials, for: challenge)
 completionHandler(.useCredential, credentials)
 }
 }
 */
