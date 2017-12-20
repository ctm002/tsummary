import UIKit

class PresenterProyecto {

    
    var mView: IListViewProyecto
    
    init(view: IListViewProyecto) {
        self.mView = view
    }
    
    func getListProyectos()
    {
        if let proyectos = LocalStoreTimeSummary.Instance.getListProyectos()
        {
            self.mView.setList(proyectos: proyectos)
        }
    }
}
