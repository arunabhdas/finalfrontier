//
//  SplashScreenViewController.swift
//

import UIKit
import RxSwift

class LandingViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var landingButton: UIButton!
    @IBOutlet weak var labelLabel: UILabel!
    
    @IBAction func landingButtonTapped(_ sender: UIButton) {
        
        
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "LandingDetailViewController") as! LandingDetailViewController
        
        
        
        detailVC.selectedCharacter.subscribe(onNext: { [weak self]  (character) in
            
            self?.labelLabel.text =  "\(character)"
            }).disposed(by: disposeBag)
        
        self.present(detailVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func skipButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "SplashToMainSegue", sender: self)
        
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "SplashToSignUpSegue", sender: self)
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "SplashToLoginSegue", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
