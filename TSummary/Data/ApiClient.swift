import Foundation
import JWTDecode

class ApiClient
{
    private var strURL : String = "https://docroom.cariola.cl/"
    private var  username: String!
    private var  password: String!
    private var credential: URLCredential!
    
    static let instance : ApiClient = ApiClient()
    
    init(userName:String, password: String)
    {
        self.username = userName
        self.password = password
    }
    
    init(){}
    
    func registrar(imei:String?, userName:String?, password:String?, callback: @escaping (SessionLocal?) -> Void)
    {
        let urlSession: URLSession = URLSession.shared
        let url = URL(string:self.strURL + "tokenmobile")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var postData: String = ""
        postData.append("{\"usuario\":\"" + userName! + "\"," );
        postData.append("\"imei\":\"" + imei! + "\"," );
        postData.append("\"password\":\"" + password! + "\"}");
        request.httpBody = postData.data(using: String.Encoding.utf8);
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if(error != nil)
            {
                print(error!.localizedDescription)
                callback(nil)
            }
            else
            {
                if (data != nil)
                {
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
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
                            if jsonwt.estado == 2
                            {
                               callback(nil)
                            }
                            else
                            {
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
                                
                                let cIdUsuario = jwt.claim(name: "IdUsuario")
                                if let idUsuario = cIdUsuario.integer
                                {
                                    usuario.idUsuario = idUsuario
                                }
                                
                                let cEmail = jwt.claim(name: "Email")
                                if let email = cEmail.string
                                {
                                    usuario.email = email
                                }
                                
                                usuario.password = password
                                usuario.imei = imei
                                usuario.loginName = userName
                                
                                SessionLocal.shared.expiredAt = jwt.expiresAt
                                SessionLocal.shared.token = jsonwt.token
                                SessionLocal.shared.usuario = usuario
                                
                                callback(SessionLocal.shared)
                            }
                            
                        }
                        catch
                        {
                            print("Error:\(error)")
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    func obtListDetalleHorasByCodAbogado(_ session: SessionLocal,_ fechaDesde: String,_ fechaHasta: String, callback: @escaping ([RegistroHora]?) -> Void)
    {
        let urlSession: URLSession = URLSession.shared
        let url = URL(string: self.strURL + "api/Horas/GetHorasByParameters")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
        request.setValue("bearer " + session.token!, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parametrosBusquedaTS = ParametrosBusquedaTS(
            AboId: (session.usuario?.id)!,
            FechaI: fechaDesde,
            FechaF: fechaHasta,
            tim_correl : 0
        )
        
        let jsonEncoder = JSONEncoder()
        do
        {
            let dataJSON = try jsonEncoder.encode(parametrosBusquedaTS)
            let strJSON: String = String(data: dataJSON, encoding:.utf8)!
            request.httpBody = strJSON.data(using: String.Encoding.utf8)
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
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        if (responseString == "")
                        {
                            callback(nil)
                        }
                        else
                        {
                            var horas = [RegistroHora]()
                            let dataJSON = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                            let estado = dataJSON["estado"] as? Int
                            if (estado != nil && estado == 1)
                            {
                                let aJSON = dataJSON["data"] as! [AnyObject]
                                for item in aJSON
                                {
                                    let hora = RegistroHora()
                                    hora.proyecto.id = item["pro_id"] as! Int32
                                    hora.tim_correl = item["tim_correl"] as! Int32
                                    hora.horasTrabajadas = item["tim_horas"] as! Int
                                    hora.minutosTrabajados = item["tim_minutos"] as! Int
                                    hora.asunto = item["tim_asunto"] as! String
                                    hora.modificable = item["nro_folio"] as! Int == 0 ? true : false;
                                    hora.abogadoId = item["abo_id"] as! Int
                                    hora.fechaHoraIngreso = Utils.toDateFromString(item["fechaInicio"] as! String, "yyyy-MM-dd'T'HH:mm:ss")!
                                    hora.fechaInsert = Utils.toDateFromString((item["tim_fecha_insert"] as! String), "yyyy-MM-dd'T'HH:mm:ss")!
                                    horas.append(hora)
                                }
                                callback(horas)
                            }
                            else
                            {
                                callback(nil)
                            }
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
        catch
        {
            
        }
    }
    
    func obtListProyectosByCodAbogado(_ session: SessionLocal, callback: @escaping ([ClienteProyecto]?) -> Void)
    {
        if let u = session.usuario
        {
            let urlSession: URLSession = URLSession.shared
            let sURL = "\(self.strURL)api/ClienteProyecto/getUltimosProyectoByAbogadoMob"
            let url = URL(string: sURL)
            let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("bearer " + session.token!, forHTTPHeaderField: "Authorization")
            
            var postData: String = ""
            postData.append("{\"abo_id\":" + String(u.id) + ",")
            postData.append("\"nombre\":\"\"}" )
            request.httpBody = postData.data(using: String.Encoding.utf8);
            
            let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if(error != nil)
                {
                    callback(nil)
                    return
                }
                
                if (data != nil)
                {
                    
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    if (responseString == "")
                    {
                        callback(nil)
                    }
                    else
                    {
                        do
                        {
                            var proyectos = [ClienteProyecto]()
                            let dataJSON = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                            let estado = dataJSON["estado"] as? Int
                            if estado != nil && estado == 1
                            {
                                let aJSON = dataJSON["data"] as! [AnyObject]
                                for item in aJSON
                                {
                                    let proyecto = ClienteProyecto()
                                    proyecto.id = item["pro_id"] as! Int32
                                    proyecto.codigoCliente = item["cli_cod"] as! Int
                                    proyecto.nombreCliente = item["nombreCliente"] as! String
                                    proyecto.nombre = item["nombreProyecto"] as! String
                                    proyecto.idiomaCliente = item["idioma"] as! String
                                    proyecto.estado = item["estado"] as! Int
                                    proyectos.append(proyecto)
                                }
                                callback(proyectos)
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
                }
            })
            task.resume()
        }
    }
    
    func guardar(hora: RegistroHora, responseOK: @escaping (RegistroHora) -> Void,  responseError: @escaping (RegistroHora) -> Void)
    {
        let urlSession: URLSession = URLSession.shared
        let sURL = "\(self.strURL)api/HorasMobile"
        let url = URL(string: sURL)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer " + SessionLocal.shared.token!, forHTTPHeaderField: "Authorization")
        
        let horaTS = HoraTS(
            tim_correl : hora.tim_correl,
            pro_id : hora.proyecto.id,
            tim_fecha_ing : Utils.toStringFromDate(hora.fechaHoraIngreso!),
            tim_asunto : hora.asunto,
            tim_horas : hora.horasTrabajadas,
            tim_minutos : hora.minutosTrabajados,
            abo_id : hora.abogadoId,
            OffLine : hora.offline,
            FechaInsert : Utils.toStringFromDate(hora.fechaInsert!),
            Estado : hora.estado.rawValue)
        
        let jsonEncoder = JSONEncoder()
        do
        {
            let jsonData = try jsonEncoder.encode(horaTS)
            let strJSON = String(data: jsonData, encoding: .utf8)!
            var postData: String = ""
            postData.append(strJSON)
            request.httpBody = jsonData // postData.data(using: .utf8)
            
            let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if(error != nil)
                {
                    responseError(hora)
                    return
                }
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                if (responseString == "")
                {
                    responseError(hora)
                }
                else
                {
                    do{
                        let dataJSON =  try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                        let horaJSON = dataJSON["data"] as AnyObject
                        hora.tim_correl = horaJSON["tim_correl"] as! Int32
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
        catch
        {
        
        }
    }
    
    func eliminar(hora: RegistroHora, responseOK: @escaping (RegistroHora) -> Void, responseError: @escaping (RegistroHora) -> Void)
    {
        let urlSession: URLSession = URLSession.shared
        let url = URL(string: self.strURL + "api/Horas/" + String(hora.tim_correl))
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "DELETE"
        request.setValue("bearer " + SessionLocal.shared.token!, forHTTPHeaderField: "Authorization")
        
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
                    let dataJSON =  try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                    let estado = dataJSON["estado"] as! Int32
                    if estado ==  1
                    {
                        responseOK(hora)
                    }
                    else
                    {
                        responseError(hora)
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

    func sincronizar(_ session: SessionLocal,_ dataSend: DataSend)
    {
        let urlSession: URLSession = URLSession.shared
        let url = URL(string: self.strURL + "/api/HorasMobile/Sincronizar")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer " + SessionLocal.shared.token!, forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        do
        {
            let jsonData = try jsonEncoder.encode(dataSend)
            let jsonString = String(data: jsonData, encoding: .utf8)
            var postData: String = ""
            postData.append(jsonString!)
            request.httpBody = postData.data(using:.utf8)
            
            let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if(error != nil)
                {
                    return
                }

                let result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                print(result)
            })
            task.resume()
        }
        catch
        {
            print("\(error)")
        }
    }
    
    func obtImagePerfilById(id: Int, callback: @escaping (String) -> Void)
    {
        let urlSession: URLSession = URLSession.shared
        let url = URL(string: self.strURL + "api/abogado/getImage")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60000)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer " + SessionLocal.shared.token!, forHTTPHeaderField: "Authorization")
        let postData: String = "{\"IdUsuario\":\(id)}"
        request.httpBody = postData.data(using:.utf8)
        
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil)
            {
                return
            }
            let result = data!.base64EncodedString(options: .endLineWithLineFeed)
            callback(result)
        })
        task.resume()
    }

}
