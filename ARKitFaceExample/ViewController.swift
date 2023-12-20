/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController, ARSessionDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    var selectedOccasionType: String?
    var selectedCell: FilterViewARCollectionViewCell?
    
    
    var
filterImages:[String] = ["white","white","white","white","white","white","white","white","white"]
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterImages.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterViewARCollectionViewCell else {
            return
        }

        if selectedCell == cell {
            // Deselect the cell
            selectedCell = nil
        } else {
            // Deselect the previously selected cell
            selectedCell?.contentView.backgroundColor = UIColor.clear

            // Select the tapped cell
            selectedCell = cell
            selectedCell?.contentView.backgroundColor = UIColor.white
            texturedFace.updateButtonType("makeup")
            resetTracking()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilterViewARCollectionViewCell
        cell.filterImage.image = UIImage(named: filterImages[indexPath.row])
        cell.filterImage.layer.cornerRadius = 40
        cell.indexPath = indexPath // Set the indexPath property
        cell.contentView.layer.cornerRadius = 40

        // Set the initial background color based on the selectedCell
        cell.contentView.backgroundColor = (selectedCell == cell) ? UIColor.white : UIColor.clear

        return cell
    }


   
    let texturedFace = TexturedFace()
    @IBAction func infoBtn(_ sender:  UIButton) {
        
            print("tap")
            // Call the changeTexture method
        texturedFace.updateButtonType("tutorial")
        resetTracking()
    }
    
    
    // MARK: Outlets

    @IBOutlet var sceneView: ARSCNView!


    // MARK: Properties
    
    var faceAnchorsAndContentControllers: [ARFaceAnchor: VirtualContentController] = [:]
    
    var selectedVirtualContent: VirtualContentType! {
        didSet {
            guard oldValue != nil, oldValue != selectedVirtualContent
                else { return }
            
            // Remove existing content when switching types.
            for contentController in faceAnchorsAndContentControllers.values {
                contentController.contentNode?.removeFromParentNode()
            }
            
            // If there are anchors already (switching content), create new controllers and generate updated content.
            // Otherwise, the content controller will place it in `renderer(_:didAdd:for:)`.
            for anchor in faceAnchorsAndContentControllers.keys {
                let contentController = selectedVirtualContent.makeController()
                if let node = sceneView.node(for: anchor),
                let contentNode = contentController.renderer(sceneView, nodeFor: anchor) {
                    node.addChildNode(contentNode)
                    faceAnchorsAndContentControllers[anchor] = contentController
                }
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        performSegue(withIdentifier: "MenuScene", sender: nil)
    }
    
   

    
    
    
    
    
    // MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        // Set the initial face content.
        
        selectedVirtualContent = VirtualContentType.texture
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // AR experiences typically involve moving the device without
        // touch input for some time, so prevent auto screen dimming.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // "Reset" to run the AR session for the first time.
        resetTracking()
    }

    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
    
    /// - Tag: ARFaceTrackingSetup
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        if #available(iOS 13.0, *) {
            configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        }
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        faceAnchorsAndContentControllers.removeAll()
       
    }
    
    // MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Auto-hide the home indicator to maximize immersion in AR experiences.
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    // Hide the status bar to maximize immersion in AR experiences.
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
/*
extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let contentType = VirtualContentType(rawValue: item.tag)
            else { fatalError("unexpected virtual content tag") }
        selectedVirtualContent = contentType
    }
}
*/
extension ViewController: ARSCNViewDelegate {
        
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        // If this is the first time with this anchor, get the controller to create content.
        // Otherwise (switching content), will change content when setting `selectedVirtualContent`.
        DispatchQueue.main.async {
            let contentController = self.selectedVirtualContent.makeController()
            if node.childNodes.isEmpty, let contentNode = contentController.renderer(renderer, nodeFor: faceAnchor) {
                node.addChildNode(contentNode)
                self.faceAnchorsAndContentControllers[faceAnchor] = contentController
            }
        }
    }
    
    /// - Tag: ARFaceGeometryUpdate
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let contentController = faceAnchorsAndContentControllers[faceAnchor],
            let contentNode = contentController.contentNode else {
            return
        }
        
        contentController.renderer(renderer, didUpdate: contentNode, for: anchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        faceAnchorsAndContentControllers[faceAnchor] = nil
    }
}

