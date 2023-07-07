import Foundation

var countIdBooking: Int = 0
var listBooking: [Reservation] = []

/// Struct para instanciar los clientes
struct Client{
    let name: String
    let age: Int
    let height: Double
}

/// Struct para instanciar las Reservas
struct Reservation{
    let idReservation: Int
    let nameHotel: String = "Kamisama"
    let clientList:[String]
    let days: Int
    let price: Double
    let breakfast: Bool
    
    init(idReservation: Int, clientList: [String], days: Int, price: Double, breakfast: Bool){
        self.idReservation = idReservation
        self.clientList = clientList
        self.days = days
        self.price = price
        self.breakfast = breakfast
    }
}

/// Clase Principal con las Funciones de la aplicación
class HotelReservationManager{

    /// Crea una Reserva Nueva
    func addBooking(clientList: [String], days: Int, breakfast: Bool){
        
        // Ver que no existan otras reservas con esos clientes. Si existen, salir
        if searchClient(clientList: clientList) == true {
            print ("Ya existe una reserva para alguno de los cliente")
        } else {
            
            // Si no hay reservas a su nombre, crear un nuevo ID
            countIdBooking += 1
            
            // Contar el numero de clientes
            let totalClient = clientList.count
            
            // Calcular el precio de la reserva
            let totalPrice: Double =  calcPrice(totalClient: totalClient, days: days , breakfast: breakfast)
            
            // Crear la Reserva
            listBooking.append(Reservation(idReservation: countIdBooking, clientList: clientList, days: days, price: totalPrice, breakfast: breakfast))
        }
        
    }
    
    /// Busca si alguno de los clientes facilitados, está presente en alguna reserva
    func searchClient(clientList: [String]) -> Bool {
        var isInclude: Bool = false
        
        // Iteramos por la Lista de reservas
        for reservation in listBooking {
            // iteramos por la lista de clientes
            for client in reservation.clientList {
                // Realizamos la comparación mediante contains y un closures, que nos devolverá un booleano
                isInclude = clientList.contains{elemento in return client.contains(elemento)}
            }
        }
        return isInclude
    }
    
    /// Calcula el precio de la habitación
    func calcPrice(totalClient: Int, days: Int ,  breakfast: Bool) -> Double{
        let priceRoom: Double = 20
        let priceBreakfastYes: Double = 1.25
        let priceBreakfastNo: Double = 1
        var totalPrice: Double = 0
        
        // Se aplica incremento, en función de si ha escogido la opción de Desayuno
        if breakfast == true {
            totalPrice = Double(totalClient) * priceRoom * Double(days) * priceBreakfastYes
         } else {
            totalPrice = Double(totalClient) * priceRoom * Double(days) * priceBreakfastNo       }
       
       return totalPrice
    }
    
    /// Cancela una reserva
    func cancelBooking(idReservation: Int){
        // Verificamos si existe una reserva con ese ID
        for (index,reservation) in listBooking.enumerated() {
            // Buscamos si se encuentra la reserva
            if reservation.idReservation == idReservation {
                // Borramos la reserva
                listBooking.remove(at: index)
               } else {
                print("No existe ninguna reserva con Número \(idReservation)")
            }
        }
       
    }
    
    // Obtiene un listado de Reservas
    func viewBooking(){
        // Iteramos sobre la lista, imprimiendo la información de las reservas
        for reservation in listBooking {
            print("Nº Reserva: \(reservation.idReservation), Hotel: \(reservation.nameHotel), Días: \(reservation.days), Precio : \(reservation.price), Desayuno Incluído: \(reservation.breakfast)")
            
            for client in reservation.clientList {
                print("Nombre de los clientes: \(client)")
            }
        }
    }
    
}


///  Clase para ejecutar los Test
class testApp{
    func testAddReservartion(){
        
    }
    
    func testCancelReservation(){
        
    }
    
    func testReservationPrice(){
        
    }
}

func Start(){
    // Crear Reservas
    let test1 = HotelReservationManager()
    test1.addBooking(clientList: ["Oscar"], days: 1, breakfast: false)
    
    let test2 = HotelReservationManager()
    test2.addBooking(clientList: ["Oscar","Juan"], days: 2, breakfast: true)
    
    let test3 = HotelReservationManager()
    test3.addBooking(clientList: ["Esther","Laura","Elena"], days: 3, breakfast: false)
    
    // Visualizar Reservas
    test1.viewBooking()
    
}

Start()



struct startApp {
    
    enum optionApp: Int {
        case add = 1
        case cancel = 2
        case list = 3
        case quit = 4
    }
    
    public var optionSelect: String? = nil
    
    func menuApp() ->Void {
        print("\u{001B}")
        print("FrontOffice Kamisama Hotel")
        print("--------------------------")
        print("\(optionApp.add.rawValue). Agregar Reserva")
        print("\(optionApp.cancel.rawValue). Cancelar Reserva")
        print("\(optionApp.list.rawValue). Listado de Reservas")
        print("\(optionApp.quit.rawValue). Salir del programa")
        print("--------------------------")
        print("Seleccione una de las opciones:")
        // optionSelect = readLine()
    }
}
