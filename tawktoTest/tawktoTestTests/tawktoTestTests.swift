//
//  tawktoTestTests.swift
//  tawktoTestTests
//
//  Created by Superman on 14/11/2022.
//

import XCTest
import CoreData
@testable import tawktoTest

class tawktoTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCreateUser(){
        let newsItemID = 1000
        let context = AppDelegate.sharedAppDelegate.coreDataStack.privateMOC
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        
        let newsItemIDPredicate = NSPredicate(format: "%K == %i", (\User.id)._kvcKeyPathString!, newsItemID)
        userFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newsItemIDPredicate])
        do {
            let results = try context.fetch(userFetch)
            
            // 1 If True equal userId not exist then can proceed to create
            XCTAssertTrue(results.isEmpty)
            
            // 2
            expectation(
              forNotification: .NSManagedObjectContextDidSave,
              object: context) { _ in
                return true
            }

            // 3
            context.perform {
                let userModel = UserModel.init(id: newsItemID, login: "TestName")
                User.createOrUpdate(item: userModel, with: context)
                XCTAssertNotNil(userModel)
            }

            // 4
            waitForExpectations(timeout: 2.0) { error in
              XCTAssertNil(error, "Save did not occur")
            }
            
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func testFetchUserById() {
      //When
      let userId = 1
        
      let context = AppDelegate.sharedAppDelegate.coreDataStack.privateMOC
      let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
       
      fetchRequest.predicate =  NSPredicate(format: "%K == %i", (\User.id)._kvcKeyPathString!, userId)
      let result = try? context.fetch(fetchRequest)
      let finalProduct1 = result?.first
      //Then
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(Int(finalProduct1?.id ?? 0), userId)

    }

}
