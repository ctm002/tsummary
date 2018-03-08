import Foundation

public class DataStore
{
    static let instance = DataStore()
    
    init() {}
    
    static var horas : TbHora
    {
        get
        {
            return TbHora.instance
        }
    }
    
    static var proyectos : TbProyecto
    {
        get
        {
            return TbProyecto.instance
        }
    }
    
    static var usuarios : TbUsuario
    {
        get
        {
            return TbUsuario.instance
        }
    }
}
