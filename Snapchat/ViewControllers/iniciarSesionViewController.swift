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
import GoogleSignIn
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var googleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }

    @IBAction func IniciarSesion(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (user, error) in print("Intentando Iniciar Sesion")
            if error != nil {
                print("Se presento el siguiente error: \(error)")
                let alerta = UIAlertController(title: "Inicio de Sesion", message: "No se reconocio al usuario ingresado", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Crear Usuario", style: .default, handler: {(UIAlertAction) in self.performSegue(withIdentifier: "regSegue", sender: nil)
                })
                let btnCANCELOK = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
                alerta.addAction(btnOK)
                alerta.addAction(btnCANCELOK)
                self.present(alerta, animated: true, completion: nil)
            }else{
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    @IBAction func GoogleAuth(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func regTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "regSegue", sender: nil)
    }
    
    
   	 private func auth(result: AuthDataResult?, error: Error?){
        if error != nil {
            print("Se presento el siguiente error: \(error)")
        }else{
            print("Inicio de sesion exitoso")
            self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
        }
    }
    
}

extension iniciarSesionViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        Auth.auth().signIn(with: credential) { (result, error) in
            self.auth(result: result, error: error)
        }
    }
}
