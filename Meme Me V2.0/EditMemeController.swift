//
//  ViewController.swift
//  Meme Me V1.0
//
//  Created by António Ramos on 25/04/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import Foundation
import UIKit

class EditMemeController: MemeMeController {
    
    //MARK: Properties
    
    var meme: Meme!
    let verticalSpacing: CGFloat = 8
    let picker = UIPickerView()
    var toolbarForPicker = UIToolbar()
    var activeFont = "Impact"
    var arrayOfFonts = ["Futura-Bold", "GillSans-Bold", "Helvetica Bold", "Impact", "MarkerFelt-Wide", "KohinoorBangla-Semibold", "ArialRoundedMTBold", "ChalkboardSE-Bold"]
    var topTextFieldWasEdited: Bool = false
    var bottomTextFieldWasEdited: Bool = false
    var activeTextField: UITextField!
    let alertService = AlertService()
    
    //ToolBar & Buttons Outlets
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    //Custom NavBar & Buttons Outlets
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    //TextFields and ImageView Outlets
    
    @IBOutlet weak var imageMemeView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    //Constraints Outlets
    
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterYConstraint: NSLayoutConstraint!
    
    //MARK: View lifecycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        setupTextField(font: activeFont)
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.shareButton.isEnabled = false
        cancelButton(shouldReturn: true)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        if meme != nil {
            navBarTitle.title = "Edit Meme"
            cameraButton.isEnabled = false
            cameraButton.tintColor = .black
            albumButton.isEnabled = false
            albumButton.tintColor = .black
            
        } else {
            navBarTitle.title = "Meme Generator"
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
        
        if let meme = self.meme {

            setupTextField(font: meme.font)
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            imageMemeView.image = meme.originalImage
            updateConstraintsToImage(image: imageMemeView.image!)
            shareButton.isEnabled = true
            cancelButton(shouldReturn: false)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let image = imageMemeView.image else {return}
        DispatchQueue.main.async {
            self.updateConstraintsToImage(image: image)
        }
    }
    
    //MARK: Methods
    
    //Update width and height of the imageView based on the image size
    

    func updateConstraintsToImage(image: UIImage) {
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let screenMaxLenght = max(screenWidth, screenHeight)
        let navAndToolBarHeights = toolBar.frame.height + navigationBar.frame.height
        let viewWidth = UIScreen.main.bounds.width
        let widthProportion = viewWidth / image.size.width
        var viewHeight = UIScreen.main.bounds.height
        var heightProportion = viewHeight / image.size.height
        var paddingTotal: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let bottomPadding = view.safeAreaInsets.bottom
            let topPadding = view.safeAreaInsets.top
            paddingTotal = bottomPadding + topPadding
        }
        
        let extraHeight = UIApplication.shared.statusBarFrame.height + paddingTotal
        
        //move the center of the imageView based on the size of the screen
        
        if screenMaxLenght >= 812 && UIDevice.current.userInterfaceIdiom == .phone {
            self.imageViewCenterYConstraint.constant = -2
            self.logoCenterYConstraint.constant = -2
        } else {
            if image.size.width < image.size.height && UIDevice.current.orientation.isLandscape{
                self.imageViewCenterYConstraint.constant = -8
            } else {
                self.imageViewCenterYConstraint.constant = 0
            }
        }
        let barsHeight: CGFloat = navAndToolBarHeights + extraHeight
        
        if UIDevice.current.orientation.isPortrait {
            
            if widthProportion < heightProportion {
                //adjust imageView by width
                imageViewWidth.constant = viewWidth
                imageViewHeight.constant = image.size.height * widthProportion
                
            } else {
                // adjust imageView by height
                imageViewHeight.constant = viewHeight
                imageViewWidth.constant = image.size.width * heightProportion
            }
        } else {
            
            viewHeight = UIScreen.main.bounds.height - barsHeight
            heightProportion = viewHeight / image.size.height
            
            if widthProportion < heightProportion {
                //adjust imageView by width
                imageViewWidth.constant = viewWidth
                imageViewHeight.constant = image.size.height * widthProportion
                
            } else {
                // adjust imageView by height
                imageViewHeight.constant = viewHeight
                imageViewWidth.constant = image.size.width * heightProportion
            }
        }
    }
    
    //MARK: Objc method for observer - keyboardWillShowNotification
    
    @objc func keyboardWillChange(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else { return }
        
        // Get the keyboard frame from the user info
        
        let keyboardMinY = keyboardFrame.minY
        if keyboardMinY == UIScreen.main.bounds.maxY {
            view.frame.origin.y = 0
            return
        }
        
        let activeTextFieldMaxYOnScreen = activeTextField.frame.maxY + view.frame.origin.y
        if keyboardMinY < activeTextFieldMaxYOnScreen {
            view.frame.origin.y -= activeTextFieldMaxYOnScreen - keyboardMinY + verticalSpacing
        }
    }
    
    //MARK: Cancel button resets the textfields and imageview to default
    
    func cancelButton(shouldReturn: Bool) {
       
        if meme == nil {
        if shouldReturn {
            cancelButton.image = UIImage(named: "dismissShape")
        } else {
            cancelButton.image = UIImage(named: "cancelShape")
        }
        } else {
            cancelButton.image = UIImage(named: "dismissShape")
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        if meme == nil {
            if cancelButton.image == UIImage(named: "cancelShape") {
                setupTextField(font: "Impact")
                imageMemeView.image = nil
                topTextFieldWasEdited = false
                bottomTextFieldWasEdited = false
                cancelButton(shouldReturn: true)
                shareButton.isEnabled = false
                imageViewWidth.constant = 268
                imageViewHeight.constant = 150
            } else {
                dismiss(animated: true, completion: nil)
            }
        } else {
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: Call picker controller
    
    //Pick from album
    @IBAction func pickAnImage(_ sender: Any) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    //Pick from camera
    @IBAction func pickImageFromCamera(_ sender: Any) {
        presentPickerViewController(source: .camera)
    }
    
    //MARK: Change font button - UIPickerView
    
    @IBAction func changeFontPicker (_ sender: Any) {
        
        customPickerView()
        self.view.addSubview(picker)
        self.view.addSubview(toolbarForPicker)
        
    }
    
    //MARK: Share button
    
    @IBAction func activityView(_ sender: Any){
        if meme == nil {
            completionHandler(shouldAlsoAppend: true)
        } else {
            presentAlert()
        }
    }
    
    //MARK: Custom UIAlert made with a UIViewController
    
    func presentAlert() {
        
        let alertVC = alertService.alert(
            update: { [weak self]
                in
                self?.editAndReplaceMeme()
            },
            updateAndSave: { [weak self]
                in
                self?.completionHandler(shouldAlsoAppend: false)
            })
        
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: Save options
    
    //Make a screenshot out of a imageview frame
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageMemeView.frame.size, false, 0.0)
        let screenShotArea = CGRect(x: -imageMemeView.frame.minX,
                                    y: -imageMemeView.frame.minY,
                                    width: view.bounds.size.width,
                                    height: view.bounds.size.height
        )
        view.drawHierarchy(in: screenShotArea,
                           afterScreenUpdates: true
        )
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    //Sava image to photo album and if "shouldAlsoSave" the new meme will be added to the collection
    
    func completionHandler(shouldAlsoAppend: Bool) {
        
        let activityView = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityView.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        present(activityView, animated: true, completion: nil)
        
        activityView.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?,
            completed: Bool,
            arrayReturnedItems: [Any]?,
            error: Error?
            )
            in
            if completed {
                guard let activity = activityType else {return}
                switch activity {
                case .saveToCameraRoll:
                    if shouldAlsoAppend {
                    self.appendMemeToArray()
                    } else {
                    self.editAndReplaceMeme()
                    }
                    print("Saved")
                default:
                    print("The Meme was not saved")
                }
                return
            }
            if let shareError = error {
                print("error while sharing: \(shareError.localizedDescription)")
            }
            
        }
    }
    
    //Append new meme to the memes array
    
    func appendMemeToArray(){
        
        guard let topText = topTextField.text,
            let bottomText = bottomTextField.text,
            let image = imageMemeView.image
            else {return}
        
        let meme = Meme(topText: topText,
                        bottomText: bottomText,
                        font: activeFont,
                        originalImage: image,
                        editedImage: generateMemedImage())
        
        MemesList.shared.memes.append(meme)
        
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //Edited meme will be replaced at indexPath
    
    func editAndReplaceMeme() {
        
        var newMeme = self.meme
        
        newMeme?.topText = topTextField.text!
        newMeme?.bottomText = bottomTextField.text!
        newMeme?.font = activeFont
        newMeme?.editedImage = generateMemedImage()
        
        let index = MemesList.shared.memes.firstIndex(of: self.meme)!
        MemesList.shared.memes.remove(at: index)
        MemesList.shared.memes.insert(newMeme!, at: index)
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}

//MARK: Extensions

//MARK: PickerView Delegate

extension EditMemeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Get the image in the view
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageMemeView.image = image
            updateConstraintsToImage(image: image)
            cancelButton(shouldReturn: false)
            self.shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
}


//MARK: Textfield delegate and attributes


extension EditMemeController: UITextFieldDelegate {
    
    func initTextField(_ textField : UITextField, text : String, attribute : [NSAttributedString.Key : Any]) {
        textField.delegate = self
        textField.text = text
        textField.defaultTextAttributes = attribute
    }
    
    func setupTextField(font: String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white,
            .strokeColor : UIColor.black,
            .strokeWidth : -4,
            .font: UIFont(name: font, size: 40)!,
            .paragraphStyle: paragraphStyle
        ]
        
        initTextField(topTextField, text: "PICK", attribute: attributes)
        initTextField(bottomTextField, text: "A IMAGE", attribute: attributes)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        
        return true
    }
    
    //If the text fields have the initial value reset them to the new text
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //This loop is used to detect if the textfields were edited, if the user write "PICK" or "A IMAGE" after the first edit, the app will not delete the words
        
        let arrayOfWords: [String] = ["PICK","A IMAGE"]
        
        for word in arrayOfWords {
            if textField.text == word  {
                if topTextField.isEditing && topTextFieldWasEdited == false {
                    self.topTextFieldWasEdited = true
                    self.topTextField.text = ""
                } else if bottomTextField.isEditing && bottomTextFieldWasEdited == false {
                    self.bottomTextFieldWasEdited = true
                    self.bottomTextField.text = ""
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: UIPickerView Methods

extension EditMemeController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func customPickerView() {
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.showsSelectionIndicator = true
        picker.frame = CGRect(
            x: 0.0,
            y: UIScreen.main.bounds.size.height - 200,
            width: self.view.frame.width,
            height: 200)
        
        
        toolbarForPicker.barStyle = .blackTranslucent
        toolbarForPicker.tintColor = .white
        toolbarForPicker.frame = CGRect(
            x: 0.0,
            y: UIScreen.main.bounds.size.height - 200,
            width: UIScreen.main.bounds.size.width,
            height: 50)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                  target: nil,
                                                  action: nil)
        
        let toolBarPickerDone = UIBarButtonItem(image: UIImage(named: "toolbarPickerDone"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(onDoneButtonTapped))
        
        let toolbarTitle = UIBarButtonItem(title: "Font Style",
                                           style: .done,
                                           target: nil,
                                           action: nil)
        
        toolbarForPicker.items = [toolbarTitle, flexSpace, toolBarPickerDone]
    }
    
    
    //Dismiss the picker
    
    @objc func onDoneButtonTapped() {
        
        self.toolbarForPicker.removeFromSuperview()
        self.picker.removeFromSuperview()
    }
    
    //The number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayOfFonts.count
    }
    
    // Name of the font to return
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: arrayOfFonts[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    //Set the font to each textfield's
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.activeFont = "\(arrayOfFonts[row])"
        setupTextField(font: "\(arrayOfFonts[row])")
        
        self.view.endEditing(true)
    }
}



