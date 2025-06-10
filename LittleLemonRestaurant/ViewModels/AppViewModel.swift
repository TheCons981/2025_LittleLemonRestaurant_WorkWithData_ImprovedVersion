import Foundation
import CoreData

@MainActor
class AppViewModel:ObservableObject {

    //@Published var restaurants: [LocationStruct] = []
    //@Published var reservation = ReservationStruct()
    //@Published var displayingReservationForm = false
    
    //@Published var displayTabBar = true
    @Published var tabBarChanged = false
    @Published var tabViewSelectedIndex = Int.max {
        didSet {
            tabBarChanged = true
        }
    }
}
