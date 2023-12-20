/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Displays the 3D face mesh geometry provided by ARKit, with a static texture.
*/

import ARKit
import SceneKit
class TexturedFace: NSObject, VirtualContentController {
    
    var contentNode: SCNNode?
    var currentTextureIndex: Int = 0
    static var buttontype : String = "makeup"
    var textureImages = ["videomakeup"] // Add the names of your texture images
    let tutImages = ["makeuptut1"]
    
    
    func updateButtonType(_ newButtonType: String) {
        TexturedFace.buttontype = newButtonType
        print("info")
        print(TexturedFace.buttontype)
       }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
           guard let sceneView = renderer as? ARSCNView,
               anchor is ARFaceAnchor else { return nil }
           
           
           let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
           let material = faceGeometry.firstMaterial!
           
           // Use the current texture
        if(TexturedFace.buttontype=="makeup"){
            material.diffuse.contents = UIImage(named: textureImages[currentTextureIndex])
            material.transparency = 0.5
            material.lightingModel = .physicallyBased
        }
        else{
            material.diffuse.contents = UIImage(named: tutImages[currentTextureIndex])
            material.transparency = 1
            material.lightingModel = .physicallyBased
        }
         
           
           contentNode = SCNNode(geometry: faceGeometry)
         
           return contentNode
       }
    
    /// - Tag: ARFaceGeometryUpdate
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
}


