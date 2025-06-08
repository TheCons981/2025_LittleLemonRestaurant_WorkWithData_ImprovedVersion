import Foundation
import CoreData

@MainActor
class Model:ObservableObject {
    
    /*var restaurants = [
     RestaurantLocation(city: "Las Vegas",
     neighborhood: "Downtown",
     phoneNumber: "(702) 555-9898"),
     RestaurantLocation(city: "Los Angeles",
     neighborhood: "North Hollywood",
     phoneNumber: "(213) 555-1453"),
     RestaurantLocation(city: "Los Angeles",
     neighborhood: "Venice",
     phoneNumber: "(310) 555-1222"),
     RestaurantLocation(city: "Nevada",
     neighborhood: "Venice",
     phoneNumber: "(725) 555-5454"),
     RestaurantLocation(city: "San Francisco",
     neighborhood: "North Beach",
     phoneNumber: "(415) 555-1345"),
     RestaurantLocation(city: "San Francisco",
     neighborhood: "Union Square",
     phoneNumber: "(415) 555-9813")
     ]*/
    
    @Published var restaurants: [LocationStruct] = []
    @Published var reservation = ReservationStruct()
    @Published var displayingReservationForm = false
    @Published var temporaryReservation = ReservationStruct()
    @Published var followNavitationLink = false
    
    @Published var displayTabBar = true
    @Published var tabBarChanged = false
    @Published var tabViewSelectedIndex = Int.max {
        didSet {
            tabBarChanged = true
        }
    }
    
    @Published var restaurantsLoading = false
    func fetchRestaurants(_ coreDataContext:NSManagedObjectContext) async {
        
        let url = URL(string: "https://mocki.io/v1/07e6a206-f962-4156-8bf8-9c21773f1602")!
        let urlSession = URLSession.shared
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            let fetchedRestaurants = try JSONDecoder().decode([LocationStruct].self, from: data)
            restaurants = fetchedRestaurants
            
            // populate Core Data
            Location.deleteAll(coreDataContext)
            Location.saveAll(locations: restaurants, coreDataContext)
        }
        catch {
            print(error)
        }
        
    }
    
}
