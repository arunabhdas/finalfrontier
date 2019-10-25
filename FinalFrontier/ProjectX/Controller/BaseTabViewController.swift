//
//  BaseTabViewController.swift
//

import UIKit


class BaseTabViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    
    
    func push(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupUI() {
        
    }
    
    func setupData() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupData()
        setupUI()
        
    }
    // MARK: - Logout
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func signOutTapped() {
        
        let alertController: UIAlertController = UIAlertController(title: "Select Action", message: "Please make your selection", preferredStyle: .actionSheet)
        // perhaps use action.title here
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
            popoverController.delegate = self
            
        }
        
        alertController.addAction(UIAlertAction(title: Constants.GlobalTitles.kFirstNewGameTitle, style: .default, handler: { (action) in
            self.handleNavButtonTapped()
        }))
        
        alertController.addAction(UIAlertAction(title: Constants.GlobalTitles.kAlertControllerDismiss, style: .default, handler: { (action) in
        }))
        
        alertController.addAction(UIAlertAction(title: Constants.GlobalTitles.kAlertControllerLogout, style: .default, handler: { (action) in
            //execute some code when this option is selected
            
            do {
                self.resetDefaults()
                self.dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: \(signOutError.localizedDescription)")
            }
        }))
        
        self.present(alertController, animated: true) {
            //code to execute once the alert is showing
        }
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - handleNavButtonTapped - Override in sub-class
    func handleNavButtonTapped() {
        
    }
    
}

