import Foundation

protocol IListViewSemana {
    func setList(semana: [Dia])
}

protocol IViewHora {
    var idAbogado : Int { get set }
    var fechaHoraIngreso : String { get set }
    func setList(horas: [Hora])
}


protocol IListViewProyecto {
    var idAbogado : Int { get set }
    func setList(proyectos: [ClienteProyecto])
}

protocol IEditViewHora {
    var model : ModelController { get set }
    
    var idHora : Int32 { get set }
    var proyectoId : Int32 { get set }
    var fechaHoraIngreso : Date { get set }
    var idAbogado : Int { get set }
    var horas : Int { get set }
    var minutos : Int { get set }
    var asunto : String { get set }
    var timCorrelativo : Int32 { get set }
    func setNombreProyecto(_ model : ModelController)
}
