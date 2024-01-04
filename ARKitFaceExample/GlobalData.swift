//
//  GlobalData.swift
//  ARKitFaceExample
//
//  Created by Ishan Singh on 24/12/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import UIKit

enum ColorMode {
    case light
    case dark
}
extension UIColor {
    static let lightModeBackgroundColor = UIColor.white
    static let darkModeBackgroundColor = UIColor.black
    static let lightModeTextColor = UIColor.black
    static let darkModeTextColor = UIColor.white
    static let darkmodeGrayColor = UIColor.gray
    static let lightmodeGrayColor = UIColor.lightGray
    
    // Add more color constants as needed
}
var colorMode: ColorMode = .light// Default color mode is light
struct MakeupData{
    struct MakeupFilters {
        static var bridalMakeup: [String] = ["makeup", "makeup", "makeup"]
        
    }
    struct MakeupTutData{
        static var bridalTutorial: [String] = ["tutorial","tutorial","tutorial"]
    }
}

struct GlobalData{
    struct FilterImages{
        static var bridal: [String] = ["white","white","white","white","white","white","white","white","white"]
    }
    struct UIImages{
        static var occasionImages: [String] = ["Bridal","Nude","Party","Men","Natural","Bridal","Nude","Party","Men","Natural"]
        static var featureImages: [String] = ["Bridal","Bridal","Bridal","Bridal","Bridal","Bridal","Bridal","Bridal","Bridal","Bridal"]
        
    }
}
class User {
    static let shared = User() // Singleton instance

    var name: String = "John Doe"
    var dateOfBirth: String = "01/01/1990"
    var email: String = "john.doe@example.com"
    var phoneNumber: String = "+1234567890"
    var profilePicture: UIImage? // New property for profile picture

    private init() {
           // Load saved data from UserDefaults
           loadFromUserDefaults()
       }

       // Save data to UserDefaults
       func saveToUserDefaults() {
           let userDefaults = UserDefaults.standard
           userDefaults.set(name, forKey: "UserName")
           userDefaults.set(dateOfBirth, forKey: "UserDateOfBirth")
           userDefaults.set(email, forKey: "UserEmail")
           userDefaults.set(phoneNumber,forKey: "UserContact")
           // Convert the UIImage to Data before saving
                   if let profilePictureData = profilePicture?.pngData() {
                       userDefaults.set(profilePictureData, forKey: "UserProfilePicture")
                   }
           // Save other properties as needed
       }

       // Load data from UserDefaults
       private func loadFromUserDefaults() {
           let userDefaults = UserDefaults.standard
           name = userDefaults.string(forKey: "UserName") ?? name
           dateOfBirth = userDefaults.string(forKey: "UserDateOfBirth") ?? dateOfBirth
           email = userDefaults.string(forKey: "UserEmail") ?? email
           phoneNumber = userDefaults.string(forKey: "UserContact") ?? phoneNumber
           // Load profile picture data from UserDefaults and convert it back to UIImage
                   if let profilePictureData = userDefaults.data(forKey: "UserProfilePicture") {
                       profilePicture = UIImage(data: profilePictureData)
                   }
           
           // Load other properties as needed
       }
}



