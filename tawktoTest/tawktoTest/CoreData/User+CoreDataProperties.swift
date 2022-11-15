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
    
    @NSManaged public var name: String?
    @NSManaged public var blog: String?
    @NSManaged public var company: String?
    
    @NSManaged public var following: Int32
    @NSManaged public var followers: Int32
    
    internal class func getAllUsers(with stack: CoreDataStack) -> [User]{
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        let sortById = NSSortDescriptor(key: (\User.id)._kvcKeyPathString!, ascending: true)
        userFetch.sortDescriptors = [sortById]
        do {
            if Thread.isMainThread{
                print("main")
            }else{
                print("off main")
            }
            
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
    
    internal class func getUserById(item: UserModel, with context: NSManagedObjectContext) -> User?{
        let newsItemID = item.id
        var currentNewUser: User? // Entity name
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        
        if let newsItemID = newsItemID {
            let newsItemIDPredicate = NSPredicate(format: "%K == %i", (\User.id)._kvcKeyPathString!, newsItemID)
            userFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newsItemIDPredicate])
        }
        do {
            let results = try context.fetch(userFetch)
            if !results.isEmpty {
                // user found, use it.
                currentNewUser = results.first
            }
            return currentNewUser
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return currentNewUser
    }
    
    internal class func createOrUpdate(item: UserModel, with context: NSManagedObjectContext) {
        let newsItemID = item.id
        var currentNewUser: User? // Entity name
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        
        if let newsItemID = newsItemID {
            let newsItemIDPredicate = NSPredicate(format: "%K == %i", (\User.id)._kvcKeyPathString!, newsItemID)
            userFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newsItemIDPredicate])
        }
        do {
            let results = try context.fetch(userFetch)
            if results.isEmpty {
                // user not found, create a new.
                currentNewUser = User(context: context)
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
        self.avatarUrl = item.avatarUrl
    }
    
    internal func updateUserDetail(item: UserModel) {
        self.login = item.login
        self.siteAdmin = item.siteAdmin ?? false
        self.avatarUrl = item.avatarUrl
        
        self.name = item.name
        self.company = item.company
        self.blog = item.blog
        self.following = Int32(item.following ?? 0)
        self.followers = Int32(item.followers ?? 0)
    }

    internal func addOrUpdateNote(note: String) {
        self.note = note
    }
}

extension User : Identifiable {

}
