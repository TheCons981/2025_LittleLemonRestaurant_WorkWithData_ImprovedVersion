import Foundation
import CoreData


@MainActor
class DishModel: ObservableObject {
    
    @Published var menuItems = [MenuItem]()
    
    
    func reload(_ coreDataContext:NSManagedObjectContext) async {
        let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/littleLemonSimpleMenu.json")!
        let urlSession = URLSession.shared
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            let fullMenu = try JSONDecoder().decode(JSONMenu.self, from: data)
            menuItems = fullMenu.menu
            
            // populate Core Data
            Dish.deleteAll(coreDataContext)
            Dish.createDishesFrom(menuItems:menuItems, coreDataContext)
        }
        catch {
            print(error)
        }
        
        /*let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/littleLemonSimpleMenu.json")!
         let urlSession = URLSession.shared
         let task = urlSession.dataTask(with: url) { data, response, error in
         if let error = error {
         print("Errore: \(error)")
         return
         }
         guard let data = data else {
         print("Nessun dato ricevuto")
         return
         }
         do {
         let fullMenu = try JSONDecoder().decode(JSONMenu.self, from: data)
         // Esegui su MainActor (cioè thread principale)
         Task { @MainActor in
         self.menuItems = fullMenu.menu
         // Aggiorna Core Data sul main thread, se il context è main queue
         Dish.deleteAll(coreDataContext)
         Dish.createDishesFrom(menuItems: self.menuItems, coreDataContext)
         }
         } catch {
         print("Errore di decoding: \(error)")
         }
         
         }
         task.resume()*/
    }
}



func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
}


extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func itemsTask(with url: URL, completionHandler: @escaping (JSONMenu?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

