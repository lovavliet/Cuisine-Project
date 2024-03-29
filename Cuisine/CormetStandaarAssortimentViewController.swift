//
//  CormetStandaarAssortimentViewController.swift
//  Cuisine
//
//  Created by Lois van Vliet on 24-01-17.
//  Copyright © 2017 Lois van Vliet. All rights reserved.
//
//
// for pickerview:
//  https://www.youtube.com/watch?v=_ADJxJ7pjRk#t=2.878095842


import UIKit
import Firebase

class CormetStandaarAssortimentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerTextField: UITextField!  
    @IBOutlet weak var inputPrice: UITextField!
    @IBOutlet weak var inputName: UITextField!
    let categories = ["Bread", "Dairy", "Drinks", "Fruits", "Salads", "Warm food", "Wraps", "Remaining Categories"]
    
    var picker = UIPickerView()
    
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        ref = FIRDatabase.database().reference()
        picker.dataSource = self
        picker.delegate = self
        
        pickerTextField.inputView = picker
    }
    
    
    //MARk: make pickerView:

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
       pickerTextField.text = categories[row]
        self.view.endEditing(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- function to save meals as a dish in Standard Assortiment
    @IBAction func saveMealButton(_ sender: Any) {
        
        if inputName.text != "" && inputPrice.text != ""{
            
            self.ref?.child("cormet").child("Standard Assortment").child(inputName.text!).child("name").setValue(inputName.text!)
            self.ref?.child("cormet").child("Standard Assortment").child(inputName.text!).child("price").setValue(inputPrice.text!)
            self.ref?.child("cormet").child("Standard Assortment").child(inputName.text!).child("likes").setValue(0)
            self.ref?.child("cormet").child("Standard Assortment").child(inputName.text!).child("categorie").setValue(pickerTextField.text!)
            
            inputName.text = ""
            inputPrice.text = ""

        } else{
            showAlert(titleAlert: "Empty box", messageAlert: "There is nothing to save")
        }
    }
    
    
    //MARK:- functions to show and hide keyboard.
    //reference:http://stackoverflow.com/questions/37825327/swift-3-nsnotificationcenter-keyboardwillshow-hide
    func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)? .cgRectValue{
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)? .cgRectValue{
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
   
 

}
