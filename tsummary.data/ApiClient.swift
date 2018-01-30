import Foundation
import JWTDecode

class ApiClient: NSObject
{
    private var strURL : String = "https://docroom.cariola.cl/";
    
    private var  username: String
    private var  password: String
    private var credential: URLCredential!
    
    static let instance : ApiClient = ApiClient(username:"carlos_tapia", password:"Car.2711")
    
    init(username:String, password: String) {
        
        self.username = username
        self.password = password
    }
    
    func registrar(imei:String?,userName:String?,password:String?, callback: @escaping (Usuario?) -> Void)
    {
        let sesion: URLSession = URLSession.shared
        let url = URL(string:self.strURL + "token")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
        
        var postData: String = ""
        postData.append("{\"usuario\":\"" + userName! + "\"," );
        postData.append("\"password\":\"" + password! + "\"}");
        request.httpBody = postData.data(using: String.Encoding.utf8);
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = sesion.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if(error != nil)
            {
                callback(nil)
            }
            
            if (data != nil)
            {
                do
                {
                    let usuario: Usuario? = Usuario()
                    let jsonwt = try JSONDecoder().decode(JWT.self, from: data!)
                    
                    let jwt = try decode(jwt: jsonwt.token)
                    let clainNombre = jwt.claim(name: "Nombre")
                    if let nombre = clainNombre.string{
                        usuario?.Nombre=nombre
                    }
                    
                    let clainPerfil = jwt.claim(name: "Perfil")
                    if let perfil = clainPerfil.string{
                        usuario?.Perfil = perfil
                    }
                    
                    let clainIdAbogado = jwt.claim(name: "AboId")
                    if let idAbogado = clainIdAbogado.integer {
                        usuario?.Id = Int32(idAbogado)
                    }
                    
                    usuario?.Token = jsonwt.token
                    callback(usuario)
                }
                catch
                {
                    print("Error:\(error)")
                }
            }
        })
        task.resume()
    }
    
    
    func obtListDetalleHorasByCodAbogado(_ usuario: Usuario,_ fechaDesde: String,_ fechaHasta: String, callback: @escaping ([Horas]?) -> Void)
    {
        let sesion: URLSession =  URLSession.shared
        
        let strURL : String = "https://docroom.cariola.cl/api/Horas/GetHorasByParameters?"
        let parameters : String = "AboId=\(usuario.Id)&FechaI=\(fechaDesde)&FechaF=\(fechaHasta)"
        let url = URL(string: "\(strURL)\(parameters)")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5000)
        request.httpMethod = "GET"
        request.setValue("bearer \(usuario.Token)",forHTTPHeaderField: "Authorization")
        
        let task = sesion.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
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
                        let hora = Horas()
                        hora.proyecto.pro_id =  d["pro_id"] as! Int32
                        hora.tim_correl  = d["tim_correl"] as! Int32
                        hora.tim_horas =  d["tim_horas"] as! Int
                        hora.tim_minutos = d["tim_minutos"] as! Int
                        hora.tim_asunto = d["tim_asunto"] as! String
                        hora.modificable = d["nro_folio"] as! Int == 0 ? true : false;
                        hora.abo_id = d["abo_id"] as! Int
                        hora.tim_fecha_ing = Utils.toDateFromString(d["fechaInicio"] as! String, "yyyy-MM-dd'T'HH:mm:ss")!
                        hora.fechaInsert = Utils.toDateFromString((d["tim_fecha_insert"] as! String), "yyyy-MM-dd'T'HH:mm:ss.SSS")!
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
    
    func obtListProyectosByCodAbogado(usuario: Usuario, callback: @escaping ([ClienteProyecto]?) -> Void)
    {
        let sesion: URLSession = URLSession.shared
        
        let url = URL(string: "https://docroom.cariola.cl/api/ClienteProyecto/getUltimosProyectoByAbogado?AboId=" + String(usuario.Id))
        
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5000)
        request.httpMethod = "GET"
        request.setValue("bearer \(usuario.Token)",forHTTPHeaderField: "Authorization")
        
        let task = sesion.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
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
                    let datos =  try JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                    for d  in datos
                    {
                        let proyecto = ClienteProyecto()
                        proyecto.pro_id = d["pro_id"] as! Int32
                        proyecto.cli_cod = d["cli_cod"] as! Int
                        proyecto.cli_nom = d["nombreCliente"] as! String
                        proyecto.pro_nombre = d["nombreProyecto"] as! String
                        proyecto.pro_idioma = d["idioma"] as! String
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
    
    func guardar(_ hora: Horas, _ retorno: @escaping (Horas?) -> Void)
    {
        let sesion: URLSession = URLSession.shared
        
        let url = URL(string: self.strURL + "GuardarInformacion")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
        
        var postData: String = ""
        postData.append("tim_correl=" +  String(hora.tim_correl) + "&")
        postData.append("pro_id=" + String(hora.proyecto.pro_id) + "&")
        postData.append("tim_fecha_ing=" + Utils.toStringFromDate(hora.tim_fecha_ing,"yyyy-MM-dd HH:mm:ss") + "&")
        postData.append("tim_asunto=" + hora.tim_asunto + "&")
        postData.append("tim_horas=" + String(hora.tim_horas) + "&")
        postData.append("tim_minutos=" + String(hora.tim_minutos) + "&")
        postData.append("abo_id=" + String(hora.abo_id) + "&")
        postData.append("OffLine= " + String(hora.offline) + "&")
        postData.append("FechaInsert=" +  Utils.toStringFromDate(hora.fechaInsert!))
        request.httpBody = postData.data(using: String.Encoding.utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = sesion.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
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
        let sesion: URLSession = URLSession.shared
        
        let url = URL(string: self.strURL + "GuardarInformacion")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
        
        var postData: String = ""
        postData.append("tim_correl=" +  String(hora.tim_correl))
        request.httpBody = postData.data(using: String.Encoding.utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = sesion.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
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


/*
 extension ApiClient: URLSessionDelegate
 {
 
 func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
 
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

struct JWT: Decodable
{
    let token:String
}

struct User: Decodable
{
    let Nombre: String
    let Perfil: String
    let AboId: String
    let exp: Int32
    let iss: String
    let aud: String
}

