//
//  MenuViewController.swift
//  ARKitFaceExample
//
//  Created by Ishan Singh on 19/12/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UISearchBarDelegate {
        
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    
    @IBAction func LightDarkToggle(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            colorMode = .light
        case 1:
            
            colorMode = .dark
        default:
            
            colorMode = .light
        }
        setModes()
        
    }
    
    func setModes(){
        customizeSearchBar()
        searchBar.barTintColor = (colorMode == .light) ? .lightModeBackgroundColor : .darkModeBackgroundColor
        
        view.backgroundColor = (colorMode == .light) ? .lightModeBackgroundColor : .darkModeBackgroundColor
        
        
        collectionview.backgroundColor = (colorMode == .light) ? .lightModeBackgroundColor : .darkModeBackgroundColor
        FilterMenuCollectionView.reloadData()
        FilterMenuCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
       
    }
   
    
    
   
    var OccasionTypeName:[String] = GlobalData.UIImages.occasionImages
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
            setModes()
        // Do any additional setup after loading the view.
        
    }
    func customizeSearchBar() {
           
            
            if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                // Set the corner radius
                searchField.backgroundColor = (colorMode == .light) ? .lightmodeGrayColor : .darkmodeGrayColor
                searchField.textColor = (colorMode == .light) ? .lightModeTextColor : .darkModeTextColor
                searchField.layer.cornerRadius = 15 // Adjust the value as needed
                searchField.clipsToBounds = true
            }

            // You can also customize other properties of the search bar, such as its background color, text color, etc.
           
        }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    @IBAction func TopNavBar(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            OccasionTypeName = GlobalData.UIImages.occasionImages
        case 1:
            
             OccasionTypeName = GlobalData.UIImages.featureImages
        default:
            
             OccasionTypeName = GlobalData.UIImages.occasionImages
        }
        FilterMenuCollectionView.reloadData()
        FilterMenuCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    
    
    @IBOutlet weak var FilterMenuCollectionView: UICollectionView!
    
    
    
    
  
    // MARK: - Navigation
     /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MenuViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OccasionTypeName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = FilterMenuCollectionView.dequeueReusableCell(withReuseIdentifier: "OccasionTypeCell", for: indexPath) as! OccasionTypeCellCollectionViewCell
        cell.TypeImage.image = UIImage(named: OccasionTypeName[indexPath.row])
        cell.TypeLabel.text = OccasionTypeName[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.TypeImage.layer.cornerRadius = 30
        cell.backgroundColor = (colorMode == .light) ? .lightModeBackgroundColor : .darkModeBackgroundColor
        cell.TypeLabel.textColor = (colorMode == .light) ? .lightModeTextColor : .darkModeTextColor
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width)/2
        return CGSize(width: size, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ARScene", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let destinationVC = segue.destination as? ViewController,
              let selectedIndexPath = FilterMenuCollectionView.indexPathsForSelectedItems?.first {
               // Pass the selected occasion type to the SceneViewController
               destinationVC.selectedOccasionType = OccasionTypeName[selectedIndexPath.row]
           }
       }
    
    
    
    
}
