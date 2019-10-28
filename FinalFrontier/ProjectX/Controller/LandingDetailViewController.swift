//
//  LandingDetailViewController.swift
//

import UIKit
import RxSwift

class LandingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let selectedCharacterVariable = Variable("User")
    
    
    var selectedCharacter: Observable<String> {
        return selectedCharacterVariable.asObservable()
    }
    
    var tableView: UITableView!
    private let headerId = "headerId"
    private let footerId = "footerId"
    private let cellIdentifier = "CupcakeItemCell"
    
    
    var transactionsList: [Transaction] = [Transaction]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                // self.view.hideToastActivity()
            }
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("selectedCharacterVariable : \(selectedCharacterVariable)")

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isTranslucent = false
        // view.backgroundColor = Constants.Colors.colorPrintexZero
        
        title = "Transactions"
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 100, width: displayWidth, height: displayHeight + barHeight))
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(CupcakeItemCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
    
        // self.navigationItem.title = "Your Transactions"
        
        // self.navigationController?.navigationBar.topItem?.title = "Your Transactions"
        self.navigationItem.title = "Your Transactions";
        
        /*
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100.0))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Your Transactions");
    
        navBar.setItems([navItem], animated: true);
        */

        
        let transactionOne: Transaction = Transaction(title: "Dinner at Momo's", transactionAmount: "$ 15.35", transactionDate: "10/20/2019")
        let transactionTwo: Transaction = Transaction(title: "Lunch at Pete's", transactionAmount: "$ 15.35", transactionDate: "10/20/2019")
        let transactionThree: Transaction = Transaction(title: "Wholefoods", transactionAmount: "$ 15.35", transactionDate: "10/20/2019")
        let transactionFour: Transaction = Transaction(title: "Safeway", transactionAmount: "$ 15.35", transactionDate: "10/20/2019")
        
        transactionsList.append(transactionOne)
        transactionsList.append(transactionTwo)
        transactionsList.append(transactionThree)
        transactionsList.append(transactionFour)
    }
    
    @IBAction func characterSelected(_ sender: UIButton) {
        guard let characterName = sender.titleLabel?.text else {
            return
        }
        selectedCharacterVariable.value = characterName
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transactionsList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CupcakeItemCell
        
        let transaction = self.transactionsList[indexPath.row]
        
        // create the attributed colour
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor.white];
        // create the attributed string
        let attributedString = NSAttributedString(string:  transaction.title, attributes: attributedStringColor)
        // Set the label
        
        // cell?.iconView.sd_setImage(with: URL(string: squash.title), placeholderImage: UIImage(named: Constants.AssetNames.kAssetIcon))
        
        // cell?.indexLabel.textColor = UIColor.gray
        // cell?.indexLabel.text = transaction.title
        
        cell?.titleLabel.textColor = UIColor.black
        cell?.titleLabel?.text = String()
        
        cell?.title2Label.textColor = UIColor.black
        cell?.title2Label.text = String(transaction.title)
        
        cell?.subtitleLabel.textColor = UIColor.gray
        cell?.subtitleLabel.text = String(transaction.transactionDate)
        
        cell?.subtitle2Label.textColor = UIColor.gray
        // cell?.subtitle2Label.text = String(squash.squashMatchTime)
        
        // var gameDateTime = "\(squash.squashMatchDate) \(squash.squashMatchTime)"
        // cell?.actionButton.setTitle(gameDateTime, for: UIControl.State.normal)
        
        cell?.subtitle3Label.textColor = UIColor.gray
        cell?.subtitle3Label.text = String(transaction.transactionAmount)
        
        cell?.backgroundColor = UIColor.clear
        cell?.layoutSubviews()
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        guard let cell = cell as? CupcakeItemCell else { return }
    }
    

    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
