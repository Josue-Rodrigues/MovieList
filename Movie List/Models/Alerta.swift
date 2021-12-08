//
//  Alerta.swift
//  Movie List
//
//  Created by Josue Herrera Rodrigues on 10/11/21.
//

import UIKit

class Alert {
    
    var title: String
    var message: String
    var button: String
    
    init(title: String, message: String, button: String) {
        
        self.title = title
        self.message = message
        self.button = button
    }
    
    func getAlert () -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let button = UIAlertAction(title: button, style: .cancel, handler: nil)
        
        alert.addAction(button)
        return alert
        
    }
}
