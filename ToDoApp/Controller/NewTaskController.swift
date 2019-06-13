//
//  NewTaskController.swift
//  ToDoApp
//
//  Created by Дмитрий Федоринов on 11/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import UIKit
import CoreLocation

class NewTaskController: UIViewController {

    var taskManager: TaskManager!
    var geocoder = CLGeocoder()
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var desriptionTextField: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    @IBAction func save() {
        let titleString = titleTextField.text!
        let locationString = locationTextField.text!
        let date = dateFormatter.date(from: dateTextField.text!)
        let descriptionString = desriptionTextField.text!
        let addressString = addressTextField.text!
        
        geocoder.geocodeAddressString(addressString) { [unowned self] (placemarks, error) in
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            let location = Location(name: locationString, coordinate: coordinate)
            let task = Task(title: titleString, description: descriptionString, date: date, location: location)
            self.taskManager.add(task: task)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
}
