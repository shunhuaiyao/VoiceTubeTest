//
//  voicetubeTests.swift
//  voicetubeTests
//
//  Created by Yao Shun-Huai on 2021/5/16.
//

import XCTest
@testable import voicetube

class voicetubeTests: XCTestCase {
    
    var viewModel: ViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIsCounterFinished() {
        let expected = 0
        let count = 10
        viewModel.startTimer(from: count)
        sleep(UInt32(count + 1))
        XCTAssertTrue(viewModel.timerCountRelay.value == expected, "Timer is finished.")
    }
    
    func testCounterState() {
        let expectedCounting: ViewModel.TimerState = .resumed
        let expectedFinished: ViewModel.TimerState = .suspended
        let count = 10
        viewModel.startTimer(from: count)
        sleep(UInt32(count/2))
        XCTAssertTrue(viewModel.timerStateRelay.value == expectedCounting, "Timer is counting.")
        sleep(UInt32(count/2 + 2))
        XCTAssertTrue(viewModel.timerStateRelay.value == expectedFinished, "Timer is finished.")
    }
    
    func testVideosCount() {
        let expectedEmpty = 0
        let expectedFetched = 3
        viewModel.getVideosCache()
        if viewModel.isFetchedRelay.value {
            XCTAssertTrue(viewModel.videosRelay.value.count == expectedEmpty, "The initial count is 0")
        } else {
            XCTAssertTrue(viewModel.videosRelay.value.count == expectedFetched, "The count of videos is 3")
        }
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
