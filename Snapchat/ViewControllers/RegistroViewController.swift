//
//  RegistroViewController.swift
//  Snapchat
//
//  Created by Emerson on 7/12/20.
//  Copyright © 2020 Emerson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase

class RegistroViewController: UIViewController {

    @IBOutlet weak var usuarioTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resgisterTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.usuarioTextField.text!, password: self.passTextField.text!, completion: {(user, error) in
            print("Intentando crear un usuario")
            if error != nil {
                print("Se presento el sisguiente error al crear el usuario: \(error)" )
                let alerta = UIAlertController(title: "Creacion de Usuario", message: "No se pudo crear el usuario", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in self.performSegue(withIdentifier: "registerSegue", sender: nil)
                })
                alerta.addAction(btnOK)
            } else {
                print("El suario fue creado exitosamente")
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in self.performSegue(withIdentifier: "registerSegue", sender: nil)
                })
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
            }
        })
    }
    @IBAction func backTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "registerSegue", sender: nil)	
    }
    
}
