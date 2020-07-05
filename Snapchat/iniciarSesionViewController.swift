//
//  ViewController.swift
//  Snapchat
//
//  Created by Emerson on 7/4/20.
//  Copyright © 2020 Emerson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class iniciarSesionViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func IniciarSesion(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (user, error) in print("Intentando Iniciar Sesion")
            if error != nil {
                print("Se presento el siguiente error: \(error)")
            }else{
                print("Inicio de sesion exitoso")
            }
        }
    }
    
}

