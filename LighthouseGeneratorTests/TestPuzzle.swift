//
//  TestPuzzle.swift
//  LighthouseGeneratorTests
//
//  Created by Hasan Edain on 9/15/24.
//

import XCTest
@testable import LighthouseGenerator

final class TestPuzzle: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertShip() throws {
        let puzzle = Puzzle.empty
        puzzle.placeShips()
        puzzle.placeLighthousesRandom()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
