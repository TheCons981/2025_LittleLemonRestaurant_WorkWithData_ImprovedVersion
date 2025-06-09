import Foundation
import CoreData


@MainActor
class LocationViewModel: ObservableObject {
    
    @Published var restaurants = [LocationStruct]()
    @Published var searchText = "";
    @Published var scrollPosition: Int? = nil
    
    func fetchRestaurants(_ coreDataContext:NSManagedObjectContext) async {
        
        let url = URL(string: "https://mocki.io/v1/07e6a206-f962-4156-8bf8-9c21773f1602")!
        let urlSession = URLSession.shared
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            let fetchedRestaurants = try JSONDecoder().decode([LocationStruct].self, from: data)
            restaurants = fetchedRestaurants.sorted { $0.city < $1.city }
            
            // populate Core Data
            Location.deleteAll(coreDataContext)
            Location.saveAll(locations: restaurants, coreDataContext)
            
        }
        catch {
            print(error)
        }
    }
    
    //getFromCoreDataAndMap
    func getRestaurants(_ coreDataContext:NSManagedObjectContext) async -> Void {
        let locations = Location.readAll(coreDataContext)
        restaurants = locations?.map { location in
            Location.mapToRestaurantLocationObject(location: location)
        } ?? []
    }
    
    var filteredRestaurants: [LocationStruct] {
        if searchText.isEmpty {
            return restaurants
        } else {
            return restaurants.filter { $0.city.localizedCaseInsensitiveContains(searchText) || $0.neighborhood.localizedCaseInsensitiveContains(searchText) ||
                $0.phoneNumber.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}




