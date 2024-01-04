//
//  ProfileViewController.swift
//  ARKitFaceExample
//
//  Created by Ishan Singh on 29/12/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var headers = ["  Account", "  More", "  Support" ]
    var accounts = ["  My Account","  Payment History"]
    var morefeatures = ["  Be A Content Creator"]
    var support = ["  Privacy Policy", "  Terms And Condition", "  LogOut" ]
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var TableView: UITableView!
    
    func setModes(){
        view.backgroundColor = (colorMode == .light) ? .lightModeBackgroundColor : .darkModeBackgroundColor
        TableView.backgroundColor = (colorMode == .light) ? .lightModeBackgroundColor : .darkModeBackgroundColor
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerTableCells()
        setImage()
        setModes()
        NameLabel.text = User.shared.name
        profileImage.image = User.shared.profilePicture
    }
    
    func setImage()
    {
        // Replace "profileImageName" with the actual name of your profile image asset
            let profileImageName = "Bridal"
            
            // Set the profile image
            if let image = UIImage(named: profileImageName) {
                profileImage.image = image
                profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
                profileImage.clipsToBounds = true
            } else {
                // Default image or placeholder if the image is not found
                profileImage.image = UIImage(named: "Bridal")
            }
        
    }
    
    func registerTableCells(){
        TableView.register(UINib(nibName:"HeaderCell", bundle:nil ), forCellReuseIdentifier: "HeaderCell")
    }
    
    @IBAction func changeProfilePic(_ sender: Any) {
        self.showImagePicker()
    }
    
}
extension ProfileViewController: UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection based on section
                switch indexPath.section {
                case 0: // Accounts section
                    handleAccountsSelection(at: indexPath.row)
                case 2: // Support section
                        if indexPath.row == support.count - 1 {
                            // LogOut row is selected
                            handleLogout()
                        }
                default:
                    break
                }
    }
    // Helper method to handle selections in the "Accounts" section
    private func handleLogout(){
        
    }
        private func handleAccountsSelection(at index: Int) {
            switch index {
            case 0: // "My Account" row
                // Perform actions specific to "My Account"
                print("Selected My Account")
                showEditOptions()
                // You can navigate to another view controller or perform other actions here
            case 1: // "Payment History" row
                // Perform actions specific to "Payment History"
                print("Selected Payment History")
                // You can navigate to another view controller or perform other actions here
            default:
                break
            }
        }
    private func showEditOptions() {
           let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
               
           let editNameAction = UIAlertAction(title:"Name: \(User.shared.name)", style: .default) { _ in
               self.showEditFieldAlert(for: "Name") { updatedName in
                   // Update the user data
                   User.shared.name = updatedName
                   // Update UI or perform other actions as needed
                   self.NameLabel.text = updatedName
               }
           }
        
        
        let editDOBAction = UIAlertAction(title: "DOB: \(User.shared.dateOfBirth)", style: .default) { _ in
                    self.showDatePicker()
                }

        let editEmailAction = UIAlertAction(title: "Email: \(User.shared.email)", style: .default) { _ in
            self.showEditFieldAlert(for: "Email") { updatedEmail in
                if self.isValidEmail(updatedEmail) {
                    // Update the user data
                    User.shared.email = updatedEmail
                    // Update UI or perform other actions as needed
                    // Example: self.emailLabel.text = updatedEmail
                } else {
                    // Handle invalid email format
                    self.showValidationErrorAlert(message: "Invalid email format.")
                }
            }
        }

        let editPhoneAction = UIAlertAction(title: "Contact: \(User.shared.phoneNumber)", style: .default) { _ in
            self.showEditFieldAlert(for: "Phone Number") { updatedPhone in
                if self.isValidPhoneNumber(updatedPhone) {
                    // Update the user data
                    User.shared.phoneNumber = updatedPhone
                    User.shared.saveToUserDefaults()
                    // Update UI or perform other actions as needed
                    // Example: self.phoneLabel.text = updatedPhone
                } else {
                    // Handle invalid phone number format
                    self.showValidationErrorAlert(message: "Invalid phone number format.")
                }
            }
        }
        
            
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

           alertController.addAction(editNameAction)
           alertController.addAction(editDOBAction)
           alertController.addAction(editEmailAction)
           alertController.addAction(editPhoneAction)
           alertController.addAction(cancelAction)
           

           present(alertController, animated: true, completion: nil)
       }

       private func showEditFieldAlert(for field: String, completion: @escaping (String) -> Void) {
           let alert = UIAlertController(title: "Edit \(field)", message: "Enter new \(field):", preferredStyle: .alert)

           alert.addTextField { textField in
               textField.placeholder = "\(field)"
           }

           let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
               if let newText = alert.textFields?.first?.text {
                   // Pass the updated value to the completion handler
                   completion(newText)
               }
           }

           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           User.shared.saveToUserDefaults()
           alert.addAction(saveAction)
           alert.addAction(cancelAction)

           present(alert, animated: true, completion: nil)
       }
    
    private func showDatePicker() {
        print("Entering showDatePicker()")
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.sizeToFit()
        datePicker.maximumDate = Date() // Optional: Set a maximum date if needed

        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        alertController.view.addSubview(datePicker)
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            print("Done action executed")
            let selectedDate = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDate = dateFormatter.string(from: selectedDate)

            // Print before setting
            print("Before setting User.shared.dateOfBirth:", User.shared.dateOfBirth)

            // Update the user data
            User.shared.dateOfBirth = formattedDate

            // Print after setting
            print("After setting User.shared.dateOfBirth:", User.shared.dateOfBirth)

        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    private func showImagePicker() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }

        // UIImagePickerControllerDelegate method for handling the selected image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                // Update the user data with the new profile picture
                User.shared.profilePicture = selectedImage

                
                
                // Update UI or perform other actions as needed
                profileImage.image = selectedImage
                User.shared.saveToUserDefaults()
            }

            // Dismiss the image picker
            picker.dismiss(animated: true, completion: nil)
        }
    // Helper method to validate email format
    private func isValidEmail(_ email: String) -> Bool {
        // Implement your email validation logic here
        // For simplicity, a basic email format check is used in this example
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    // Helper method to validate phone number format
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // Implement your phone number validation logic here
        // For simplicity, a basic phone number format check is used in this example
        let phoneRegex = "^\\d{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }

    // Helper method to show a validation error alert
    private func showValidationErrorAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    //Tableview of main Scene
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return accounts.count
        case 1:
            return morefeatures.count
        case 2:
            return support.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        cell.titles.font = UIFont.systemFont(ofSize: 15)
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        if(colorMode == .dark){ cell.titles.textColor = UIColor.white}
        else {cell.titles.textColor = UIColor.black}
        
        switch indexPath.section {
        case
            0:
            cell.titles.text = accounts[indexPath.row]
        case 1:
            cell.titles.text = morefeatures[indexPath.row]
        case 2:
            cell.titles.text = support[indexPath.row]
            if(indexPath.row == support.count-1){ cell.titles.textColor = .red}
        default:
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        cell.titles.font = UIFont.boldSystemFont(ofSize: 20)
        cell.backgroundColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.white
        cell.titles.text = headers[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 40
        case 1:
            return 40
        case 2:
            return 40
        default:
            return 40
        }
    
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 20
        case 1:
            return 20
        case 2:
            return 20
        default:
            return 20
        }
    }
    
}
