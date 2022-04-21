//
//  AlertDisplayer.swift
//  Hive
//
//  Created by seintsan on 21/4/22.
//

import Foundation
import UIKit

protocol AlertDisplayer {
  func displayAlert(with title: String, message: String, actions: [UIAlertAction]?)
}

extension AlertDisplayer where Self: UIViewController {
  func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil, textField : String) {
    guard presentedViewController == nil else {
      return
    }
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    actions?.forEach { action in
      alertController.addAction(action)
    }
    if(!textField.isEmpty){
      alertController.addTextField { (textField) in
          // configure the properties of the text field
          textField.placeholder = "textField"
      }
    }
    present(alertController, animated: true)
  }
}
