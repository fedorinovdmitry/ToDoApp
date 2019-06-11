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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var desriptionTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
        
    }
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
}
