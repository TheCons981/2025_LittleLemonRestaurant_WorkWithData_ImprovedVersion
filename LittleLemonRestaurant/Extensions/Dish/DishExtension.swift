//
// Dish+Extension.swift



import Foundation
import CoreData


extension Dish {
    
    static func createDishesFrom(menuItems:[MenuItemStruct],
                                 _ context:NSManagedObjectContext) {
        for menuItem in menuItems {
            if exists(name: menuItem.title, context) ?? false {
                continue
            }
            
            let oneDish = Dish(context: context)
            oneDish.name = menuItem.title
            oneDish.size = menuItem.size ?? ""
            if let price = Float(menuItem.price) {
                oneDish.price = price
            }
            
            Dish.save(context)
        }
    }
    
    static func exists(name: String,
                       _ context:NSManagedObjectContext) -> Bool? {
        let request = Dish.request()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        request.predicate = predicate
        
        do {
            guard let results = try context.fetch(request) as? [Dish]
            else {
                return nil
            }
            return results.count > 0
        } catch (let error){
            print(error.localizedDescription)
            return false
        }
    }
    
}
