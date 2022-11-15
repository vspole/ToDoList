//
//  PhoneLoginViewModelTests.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList
import XCTest

class PhoneLoginViewModelTests: XCTestCase {
    var container: DependencyContainer!
    var dataComponent: DataComponent!
    var alertService: AlertService!
    var firebaseAuthService: MockFirebaseAuthService!
    var phoneViewModel: PhoneLoginView.ViewModel!
    var mainViewModel: MainView.ViewModel!
    
    override func setUpWithError() throws {
        container = DependencyContainer()
        firebaseAuthService = MockFirebaseAuthService(container: container)
        dataComponent = DataComponent(container: container)
        alertService = AlertService(container: container)
        container.components = [
            firebaseAuthService,
            dataComponent,
            alertService
        ]
        mainViewModel = .init(container: container)
        phoneViewModel = .init(container: container, mainViewModel: mainViewModel)
    }
    
    func test_formattedPhoneNumber() {
        let unformatedNumber = "(123)4567890"
        let formattedNumber = "+11234567890"
        
        // Arrange
        phoneViewModel.phoneNumber = unformatedNumber
        
        // Act
        XCTAssertEqual(phoneViewModel.formattedPhoneNumber, formattedNumber)
    }
    
    func test_isButtonDisabled() {
        // Arrange
        phoneViewModel.receivedVerificationID = false
        phoneViewModel.phoneNumber = ""
        
        // Act
        XCTAssertEqual(phoneViewModel.isButtonDisabled, true)
        
        // Arrange
        phoneViewModel.receivedVerificationID = false
        phoneViewModel.phoneNumber = "1234567890"
        
        // Act
        XCTAssertEqual(phoneViewModel.isButtonDisabled, false)
        
        // Arrange
        phoneViewModel.receivedVerificationID = true
        phoneViewModel.verificationCode = ""
        
        // Act
        XCTAssertEqual(phoneViewModel.isButtonDisabled, true)
        
        // Arrange
        phoneViewModel.receivedVerificationID = true
        phoneViewModel.verificationCode = "123456"
        
        // Act
        XCTAssertEqual(phoneViewModel.isButtonDisabled, false)
    }
    
    func test_buttonPressed() {
        // Arrange
        phoneViewModel.receivedVerificationID = false
        phoneViewModel.phoneNumber = "+11234567890"
        
        //Act
        phoneViewModel.buttonPressed()
        
        XCTAssertEqual(firebaseAuthService.requestOTPCallCount, 1)
        
        // Arrange
        phoneViewModel.receivedVerificationID = true
        phoneViewModel.verificationCode = "123456"
        
        //Act
        phoneViewModel.buttonPressed()
        
        XCTAssertEqual(firebaseAuthService.signInWithCodeCallCount, 1)
    }
}
