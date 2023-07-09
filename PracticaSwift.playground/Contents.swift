import Foundation

/*
 NUNCA HE TRABAJADO CON CLASES, Y VENGO DE VB.NET. ME CUESTA TODAVIA INTRODUCIR
 VARIABLES PUBLICAS ACCESIBLES PARA EL PROYECTO. POR ESO LAS HE PUESTO DONDE SE
 QUE NO ME FALLARIAN.
 */
var countIdBooking: Int = 0
var listBooking: [Reservation] = []
var listClient: [Client] = []
var clientBooking: [Client] = []


/// Struct para instanciar los clientes
struct Client: Equatable{
    let name: String
    let age: Int
    let height: Double
    
    init (name: String, age: Int, height: Double){
        self.name = name
        self.age = age
        self.height = height
    }
}

/// Struct para instanciar las Reservas
struct Reservation{
    let idReservation: Int
    let nameHotel: String = "Kamisama"
    let clientList:[Client]
    let days: Int
    let price: Double
    let breakfast: Bool
    
    init(idReservation: Int, clientList: [Client], days: Int, price: Double, breakfast: Bool){
        self.idReservation = idReservation
        self.clientList = clientList
        self.days = days
        self.price = price
        self.breakfast = breakfast
    }
}

/// Clase Principal con las Funciones de la aplicación
class HotelReservationManager{
           
        /// Crea un registro de los datos del cliente
    func addClient(name: String, age: Int, height: Double){
        // Buscamos en el listado de clientes para las reservas, que no exista otro cliente con los mismos datos
        do{
            let validate = ValidateError()
            try validate.validateClient(name: name, age: age, height: height)
            // Agregamos el cliente, si no existe en la lista de clientes para Reservas
            listClient.append(Client(name: name, age: age, height: height))
            clientBooking.append(Client(name: name, age: age, height: height))
        } catch ValidateError.ReservationError.ErrorClientDuplicate{
            print(ValidateError.ReservationError.ErrorClientDuplicate.errorDescription!)
        } catch {
        assertionFailure("Error desconocido, póngase en contacto con el administrador y rece")
        }
    }
    
    /// Crea una Reserva Nueva
    func addBooking(clientList: [Client], days: Int, breakfast: Bool){
        
        do{
            // Si el cliente no está en el listado de clientes Reservas, crear una nueva reserva
            countIdBooking += 1
            let validate = ValidateError()
            try validate.validateIDbooking(idBooking: countIdBooking)
            
            // Contar el numero de clientes
            let totalClient = clientBooking.count
            
            // Calcular el precio de la reserva
            let totalPrice: Double =  calcPrice(totalClient: totalClient, days: days , breakfast: breakfast)
            
            // Crear la Reserva
            listBooking.append(Reservation(idReservation: countIdBooking, clientList: clientBooking, days: days, price: totalPrice, breakfast: breakfast))
            
            // Borra la variable Temporal, con los clientes asociados a la reserva.
            clientBooking.removeAll()
            
            // Muestra la Reserva
            print("Nº Reserva: \(listBooking.last!.idReservation), Hotel: \(listBooking.last!.nameHotel), Días: \(listBooking.last!.days), Precio : \(listBooking.last!.price), Desayuno Incluído: \(listBooking.last!.breakfast)")
        }
        catch ValidateError.ReservationError.ErrorClientDuplicate{
            print(ValidateError.ReservationError.ErrorClientDuplicate.errorDescription!)
        }
        catch ValidateError.ReservationError.ErrorBookingExist {
            print(ValidateError.ReservationError.ErrorBookingExist.errorDescription!)
        }
        catch {
            assertionFailure("Error desconocido, póngase en contacto con el administrador y rece")
        }
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
        do {
            let validateBooking = ValidateError()
            try validateBooking.validateCancelBooking(idBooking: idReservation)
            // Si continua, existe una reserva con ese ID
            for (index,reservation) in listBooking.enumerated() {
                // Buscamos si se encuentra la reserva
                if reservation.idReservation == idReservation {
                    // Borramos la reserva
                    listBooking.remove(at: index)
                    countIdBooking -= 1
                }
            }
        }
        catch ValidateError.ReservationError.ErrorBookingNoExist {
            print(ValidateError.ReservationError.ErrorBookingNoExist.errorDescription!)
        }
        catch {
            assertionFailure("Error desconocido, póngase en contacto con el administrador y rece")
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

/// Clase para gestión de Errores
public class ValidateError{
    
    public enum ReservationError: LocalizedError {
        case ErrorClientDuplicate
        case ErrorBookingExist
        case ErrorBookingNoExist
        
    public var errorDescription: String? {
        switch self {
            case .ErrorClientDuplicate:
                return ("Cliente Duplicado")
            case .ErrorBookingExist:
                return ("Número de Reserva duplicado")
            case .ErrorBookingNoExist:
                return ("Número de Reserva NO existe")
            }
        }
    }
    
    /// Busca si alguno de los clientes facilitados, está presente en lista de clientes de reserva
    public func validateClient(name: String, age: Int, height: Double) throws{
        // Buscamos en el listado de clientes para las reservas, que no exista otro cliente con los mismos datos
        if (listClient.contains{ $0.name == name && $0.age == age && $0.height == height }) {
            throw ReservationError.ErrorClientDuplicate
        }
    }
    
       
    /// Busca si existe un ID en las reservas igual que el que acabamos de generar
    public func validateIDbooking(idBooking: Int) throws {
                
        // Iteramos por la Lista de reservas
        for reservation in listBooking {
            // Buscamos si se encuentra la reserva
            if reservation.idReservation == idBooking {
                throw ReservationError.ErrorBookingExist
            }
        }
    }
    
    /// Buscamos si existe una Reserva antes de Eliminarla
    public func validateCancelBooking(idBooking: Int) throws {
        
        // Iteramos por la Lista de reservas
        for reservation in listBooking {
            // Buscamos si se encuentra la reserva
            if reservation.idReservation == idBooking {
                return
            }
        }
        throw ReservationError.ErrorBookingNoExist
    }
}

///  Clase para ejecutar los Test
class testApp{
    
    func testAddReservartion(){
        // Creamos Clientes para la reserva
        let clientTest = HotelReservationManager()
        clientTest.addClient(name: "Cliente_1", age: 45, height: 180)
        clientTest.addClient(name: "Cliente_2", age: 46, height: 190)
        
        
        // Verificar Alta Nueva Reserva
        let test1 = HotelReservationManager()
        test1.addBooking(clientList: clientBooking, days: 3, breakfast: true)
        assert(countIdBooking == 1, "Contador debe incrementarse a 1")
        assert(listBooking.count == 1, "Tiene que existir la reserva creada")
        assert(listBooking[0].idReservation == 1, " El id de la Reserva tiene que ser 1")
        assert(listBooking[0].days == 3, "Los días tienen que ser igual a los de prueba")
        assert(listBooking[0].price == 150, "El precio tiene que ser igual al de prueba")
        assert(listBooking[0].breakfast == true, "El desayuno tiene que ser igual al de prueba")
        
        // Verificar que no existan varias reservas para el mismo cliente.
        let test2 = HotelReservationManager()
        test2.addClient(name: "Cliente_1", age: 45,height: 180) // APARECE MENSAJE EN LA TERMINAL INDICANDO CLIENTE DUPLICADO
        assert(clientBooking.count == 0, "El contador de clientes permanece 0, y no validó el cliente duplicado")
                
        // Verificar Alta Nuevas Reservas
        let test3 = HotelReservationManager()
        test3.addClient(name: "Cliente_3", age: 47,height: 200)
        test3.addBooking(clientList: clientBooking, days: 2, breakfast: false)
        assert(countIdBooking == 2, "Contador debe incrementarse a 2")
        assert(listBooking.count == 2, "Tiene que existir la reserva creada")
        assert(listBooking[1].idReservation == 2, " El id de la Reserva tiene que ser 2")
        assert(listBooking[1].days == 2, "Los días tienen que ser igual a la instancia")
        assert(listBooking[1].price == 40, "El precio tiene que ser igual a 20 * 1 * 2 * 1")
        assert(listBooking[1].breakfast == false, "El desayuno tiene que ser igual a la instancia")

        print ("---- testAddReservation CORRECTO ----")
    }
    
    
    func testCancelReservation(){
        assert(listBooking[1].idReservation == 2, " El id de la Reserva a borrar es 2 y existe")
        
        // Eliminar la reserva Número 2
        let test3 = HotelReservationManager()
        test3.cancelBooking(idReservation: 2)
                
        //Verificar que no exista
        assert(countIdBooking == 1, "Contador debe ser 1")
        assert(listBooking.count == 1, "Tiene que existir solo la primera reserva creada")
        
        //Verificar que devuelve un error al eliminar una reserva que no existe
        test3.cancelBooking(idReservation: 2) // APARECE MENSAJE EN LA TERMINAL INDICANDO QUE EL NUMERO DE RESERVA NO EXISTE
        print ("---- testCancelReservation CORRECTO ----")
    }
    
    func testReservationPrice(){
        let test1 = HotelReservationManager()
        test1.calcPrice(totalClient: 1, days: 1, breakfast: true)
        assert(test1.calcPrice(totalClient: 1, days: 1, breakfast: true) == 25, "20 * 1 * 1 * 1.25 = 25 ")
        assert(test1.calcPrice(totalClient: 1, days: 1, breakfast: false) == 20, "20 * 1 * 1 * 1 = 20 ")
        print ("---- testReservationPrice CORRECTO ----")
        
    /*
     NUNCA HE REALIZADO TEST, Y DESCONOZCO COMO ACTUAR A LA FINALIZACION, SI LIMPIAR LOS REGISTROS CREADOS, POR ESO HE DEJADO
     LA PRIMERA RESERVA CREADA
     */
        
    }
}

// main()
let test1 = testApp()
test1.testAddReservartion()
test1.testCancelReservation()
test1.testReservationPrice()
print("")
print ("*********************")
print (" LISTADO DE RESERVAS ")
print ("*********************")
let view1 = HotelReservationManager()
view1.viewBooking()
