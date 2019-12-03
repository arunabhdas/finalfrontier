import UIKit

class MasterViewController: UITableViewController {

  let recordings = Recording.defaultRecordings()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destVC = segue.destination as? UINavigationController,
      let recordingVC = destVC.topViewController as? RecordingViewController,
      let indexPath = self.tableView.indexPathForSelectedRow {
      let recording = recordings[indexPath.row]
      recordingVC.recording = recording
    }
  }
  
  // MARK: - Table View
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recordings.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let recording = recordings[indexPath.row]
    
    cell.textLabel?.text = recording.title
    cell.detailTextLabel?.text = recording.subtitle
    
    return cell
  }
}

