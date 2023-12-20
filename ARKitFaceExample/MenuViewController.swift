//
//  MenuViewController.swift
//  ARKitFaceExample
//
//  Created by Ishan Singh on 19/12/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    
    let OccasionTypeName:[String] = ["Bridal","Nude","Party","Men","Natural","Bridal","Nude","Party","Men","Natural"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    

   
     
    @IBOutlet weak var OccasionTypeCollectionView: UICollectionView!
    
    
    
  
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
        let cell = OccasionTypeCollectionView.dequeueReusableCell(withReuseIdentifier: "OccasionTypeCell", for: indexPath) as! OccasionTypeCellCollectionViewCell
        cell.TypeImage.image = UIImage(named: OccasionTypeName[indexPath.row])
        cell.TypeLabel.text = OccasionTypeName[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.TypeImage.layer.cornerRadius = 30
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width-20)/2
        return CGSize(width: size, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ARScene", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let destinationVC = segue.destination as? ViewController,
              let selectedIndexPath = OccasionTypeCollectionView.indexPathsForSelectedItems?.first {
               // Pass the selected occasion type to the SceneViewController
               destinationVC.selectedOccasionType = OccasionTypeName[selectedIndexPath.row]
           }
       }
    
}
