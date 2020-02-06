//
//  Alerts.swift
//  HarryPotter_Yue Yang
//
//  Created by MacAir11 on 2020/2/4.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
