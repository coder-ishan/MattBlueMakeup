//
//  DemoViewController.swift
//  ARKitFaceExample
//
//  Created by Ishan Singh on 22/12/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func Occasion(_ sender: Any) {
        if let typeViewController = storyboard?.instantiateViewController(withIdentifier: "Type") {
                    navigationController?.pushViewController(typeViewController, animated: true)
                }
    }
    
    @IBAction func `Type`(_ sender: Any) {
        if let typeViewController = storyboard?.instantiateViewController(withIdentifier: "Occasion") {
                    navigationController?.pushViewController(typeViewController, animated: true)
                }
        
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
