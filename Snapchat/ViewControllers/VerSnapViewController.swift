//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Emerson on 7/12/20.
//  Copyright © 2020 Emerson. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
import FirebaseStorage
import AVFoundation

class VerSnapViewController: UIViewController {

    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbln: UILabel!
    @IBOutlet weak var btnrep: UIButton!
    
    var snap = Snap()
    var reproducirAudio:AVPlayer?
    var audioURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if snap.descrip == snap.imagenID{
            lblMensaje.text = "Tipo Mensaje: Audio"
            imageView.isHidden = true
            lbln.isHidden = true
            print(snap.imagenURL)
        } else {
            btnrep.isHidden = true
            lblMensaje.text = "Mensaje: " + snap.descrip
            imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.snap.descrip == self.snap.imagenID{
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
            Storage.storage().reference().child("Audios").child("\(snap.imagenID).m4a").delete{ (error) in print("Se elimino la imagen correctamente")}
        } else {
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
            Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{ (error) in print("Se elimino la imagen correctamente")}
        }
    }
    @IBAction func reproducirTapped(_ sender: Any) {
        let url = URL(string: self.snap.imagenURL )
        let playerItem = AVPlayerItem(url: url!)
        reproducirAudio = AVPlayer(playerItem: playerItem)
        reproducirAudio?.play()
    }
}
