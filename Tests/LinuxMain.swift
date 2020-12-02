import XCTest

import DebooggerTests

var tests = [XCTestCaseEntry]()
tests += DebooggerTests.allTests()
XCTMain(tests)
