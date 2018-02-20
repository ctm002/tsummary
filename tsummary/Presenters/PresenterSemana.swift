import Foundation

public class PresenterSemana
{
    private var mView : IListViewSemana!
    private var mFecha: Date!
    private var mCantidadDias: Int = 0
    
    public init()
    {
        self.mView = nil
        self.mCantidadDias = 14
        self.mFecha = Date()
    }
    
    init(view: IListViewSemana, cantidadDeDias cantidad: Int)
    {
        self.mView = view
        self.mCantidadDias = cantidad
        self.mFecha = Date()
    }
    
    public func mostrar()
    {
        let semana: [Dia] = Calendario.instance.obtDias()
        self.mView.setList(semana: semana)
    }
}
	
