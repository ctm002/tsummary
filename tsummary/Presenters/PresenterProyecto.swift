import UIKit

class PresenterProyecto {
    
    var mView: IListViewProyecto?
    
    init(_ view : IListViewProyecto)
    {
        self.mView = view
    }
    
    func obtListProyectos()
    {
        if let proyectos = DataBase.proyectos.obtListProyectos()
        {
            self.mView!.setList(proyectos: proyectos)
        }
    }
}
