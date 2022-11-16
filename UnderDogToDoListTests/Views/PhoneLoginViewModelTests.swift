//
//  PhoneLoginViewModelTests.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList
import XCTest

class PhoneLoginViewModelTests: TestDependencyContainer {
    var phoneViewModel: PhoneLoginView.ViewModel!
    var mainViewModel: MainView.ViewModel!
    
    override func setUpWithError() throws {
        container = DependencyContainer().createTestDependencyContainer()
        mainViewModel = .init(container: container)
        phoneViewModel = .init(container: container, mainViewModel: mainViewModel)
    }
    
    func test_formattedPhoneNumber() {
        let unformatedNumber = "(123)4567890"
        let formattedNumber = "+11234567890"
        
        phoneViewModel.phoneNumber = unformatedNumber
        
        XCTAssertEqual(phoneViewModel.formattedPhoneNumber, formattedNumber)
    }
    
    func test_isButtonDisabled() {
        phoneViewModel.receivedVerificationID = false
        phoneViewModel.phoneNumber = ""
        
        XCTAssertEqual(phoneViewModel.isButtonDisabled, true)
        
        phoneViewModel.receivedVerificationID = false
        phoneViewModel.phoneNumber = "1234567890"
        
        XCTAssertEqual(phoneViewModel.isButtonDisabled, false)
        
        phoneViewModel.receivedVerificationID = true
        phoneViewModel.verificationCode = ""
        
        XCTAssertEqual(phoneViewModel.isButtonDisabled, true)
        
        phoneViewModel.receivedVerificationID = true
        phoneViewModel.verificationCode = "123456"
        
        XCTAssertEqual(phoneViewModel.isButtonDisabled, false)
    }
    
    func test_buttonPressed() {
        phoneViewModel.receivedVerificationID = false
        phoneViewModel.phoneNumber = "+11234567890"
        
        phoneViewModel.buttonPressed()
        
        XCTAssertEqual(container.mockFirebaseAuthService.requestOTPCallCount, 1)
        
        phoneViewModel.receivedVerificationID = true
        phoneViewModel.verificationCode = "123456"
        
        phoneViewModel.buttonPressed()
        
        XCTAssertEqual(container.mockFirebaseAuthService.signInWithCodeCallCount, 1)
    }
}
