//
//  AudioViewController.swift
//  Snapchat
//
//  Created by Emerson on 7/12/20.
//  Copyright © 2020 Emerson. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class AudioViewController: UIViewController {

    @IBOutlet weak var btngrabar: UIButton!
    @IBOutlet weak var btnreproducir: UIButton!
    @IBOutlet weak var lblname: UITextField!
    @IBOutlet weak var btnAgregar: UIButton!
    
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    var imagenID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        btnreproducir.isEnabled = false
        btnAgregar.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = imagenID
        siguienteVC.imagenID = imagenID
    }
    
    @IBAction func actionGrabar(_ sender: Any) {
        if grabarAudio!.isRecording{
            grabarAudio?.pause()
            grabarAudio?.stop()
            btngrabar.setTitle("Grbar", for: .normal)
            btnreproducir.isEnabled = true
            btnAgregar.isEnabled = true
        }else{
            grabarAudio?.record()
            btngrabar.setTitle("Detener", for: .normal)
            btnreproducir.isEnabled = false
        }
    }
    @IBAction func actionReproducir(_ sender: Any) {
        do {
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            reproducirAudio!.volume = 1.0
            print("Reproduciendo")
        } catch {}
    }
    @IBAction func actionElegir(_ sender: Any) {
        self.btnAgregar.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("Audios")
        let audio = NSData(contentsOf: audioURL!)! as Data
        let cargarImagen = imagenesFolder.child("\(imagenID).m4a")
        cargarImagen.putData(audio, metadata: nil){(metadata, error) in
            if error != nil {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo", accion: "Aceptar")
                self.btnAgregar.isEnabled = true
                print("Ocurio un error al subir imagen: \(error)")
                return
            } else {
                cargarImagen.downloadURL(completion: {(url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen", accion: "Cancelar")
                        self.btnAgregar.isEnabled = true
                        print("Ocurrio un error al obtener informacion imagen: \(error)")
                        return
                    }
                    self.performSegue(withIdentifier: "ausegue", sender: url?.absoluteString)
                })
            }
        }
    }
    
    func configurarGrabacion() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session .setActive(true)
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("*******************")
            print(audioURL!)
            print("*******************")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings:settings)
            grabarAudio!.prepareToRecord()
            
            
        } catch let error as NSError {
            print(error)
        }
    }
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
}
