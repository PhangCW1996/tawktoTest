//
//  User+CoreDataProperties.swift
//  tawktoTest
//
//  Created by Superman on 15/11/2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int32
    @NSManaged public var login: String?
    @NSManaged public var siteAdmin: Bool
    @NSManaged public var note: String?
    @NSManaged public var avatarUrl: String?
    
    internal class func getAllUsers(with stack: CoreDataStack) -> [User]{
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        let sortById = NSSortDescriptor(key: (\User.id)._kvcKeyPathString!, ascending: true)
        userFetch.sortDescriptors = [sortById]
        do {
            let managedContext = stack.managedContext
            let results = try managedContext.fetch(userFetch)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return []
    }
    
    internal class func searchUsers(keyword: String, with stack: CoreDataStack) -> [User]{
        // Search user by login name using LIKE
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        let sortById = NSSortDescriptor(key: (\User.id)._kvcKeyPathString!, ascending: true)
        userFetch.sortDescriptors = [sortById]
        userFetch.predicate = NSPredicate(format: "login LIKE[c] %@",
                                        argumentArray: ["\(keyword)*"])
        do {
            let managedContext = stack.managedContext
            let results = try managedContext.fetch(userFetch)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return []
    }
    
    internal class func createOrUpdate(item: UserModel, with stack: CoreDataStack) {
        let newsItemID = item.id
        var currentNewUser: User? // Entity name
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        if let newsItemID = newsItemID {
         
            let newsItemIDPredicate = NSPredicate(format: "%K == %i", (\User.id)._kvcKeyPathString!, newsItemID)
            userFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newsItemIDPredicate])
        }
        do {
            let results = try stack.managedContext.fetch(userFetch)
            if results.isEmpty {
                // user not found, create a new.
                currentNewUser = User(context: stack.managedContext)
                if let userID = newsItemID {
                    currentNewUser?.id = Int32(userID)
                }
            } else {
                // user found, use it.
                currentNewUser = results.first
            }
            currentNewUser?.update(item: item)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }

    internal func update(item: UserModel) {
        self.login = item.login
        self.siteAdmin = item.siteAdmin ?? false
    }

    internal func addOrUpdateNote(note: String) {
        self.note = note
    }
}

extension User : Identifiable {

}
