import Foundation

struct ReservationStruct {
  var restaurant:LocationStruct
  var customerName:String
  var customerEmail:String
  var customerPhoneNumber:String
  var reservationDate:Date
  var party:Int
  var specialRequests:String
  var id = UUID()
  
  init(restaurant:LocationStruct = LocationStruct(),
       customerName: String = "",
       customerEmail: String = "",
       customerPhoneNumber: String = "",
       reservationDate:Date = Date(),
       party:Int = 1,
       specialRequests:String = "") {
    self.restaurant = restaurant
    self.customerName = customerName
    self.customerEmail = customerEmail
    self.customerPhoneNumber = customerPhoneNumber
    self.reservationDate = reservationDate
    self.party = party
    self.specialRequests = specialRequests
  }
  
}

