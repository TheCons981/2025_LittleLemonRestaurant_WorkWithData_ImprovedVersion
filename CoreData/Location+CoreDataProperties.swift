import Foundation
import CoreData


extension Location {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
    
    @NSManaged public var city: String?
    @NSManaged public var neighborhood: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var toCustomer: NSSet?
    @NSManaged public var toDessert: NSSet?
    @NSManaged public var toDish: NSSet?
    
}

extension Location : Identifiable {
    
    static func request() -> NSFetchRequest<NSFetchRequestResult> {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: Self.self))
        request.returnsDistinctResults = true
        request.returnsObjectsAsFaults = true
        return request
    }
    
    static func delete(with phoneNumber: String,
                       _ context:NSManagedObjectContext) -> Bool {
        let request = Location.request()
        
        let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        request.predicate = predicate
        
        do {
            guard let results = try context.fetch(request) as? [Dish],
                  results.count == 1,
                  let location = results.first
            else {
                return false
            }
            context.delete(location)
            return true
        } catch (let error){
            print(error.localizedDescription)
            return false
        }
    }
    
    static func deleteAll(_ context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Location.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
            try context.save()
        } catch {
            print("Errore durante la cancellazione: \(error)")
        }
    }
    
    
    static func save(_ context:NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    
    class func readAll(_ context:NSManagedObjectContext) -> [Location]? {
        let request = Location.request()
        request.sortDescriptors = [
            NSSortDescriptor(key: "city",
                             ascending: true,
                             selector:
                                #selector(NSString.localizedStandardCompare)
                            )
        ]
        
        do {
            guard let results = try context.fetch(request) as? [Location],
                  results.count > 0 else { return nil }
            return results
        } catch (let error){
            print(error.localizedDescription)
            return nil
        }
    }
    
}
