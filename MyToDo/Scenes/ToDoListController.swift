

import UIKit
import RealmSwift

class ToDoListController: UITableViewController {
  private var items: Results<ToDoItem>?
  private var itemsToken: NotificationToken?

  // MARK: - View controller life-cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    items = ToDoItem.all()

    if Realm.Configuration.defaultConfiguration.encryptionKey != nil {
      navigationItem.leftBarButtonItem?.title = "Decryt"
    }else{
        navigationItem.leftBarButtonItem?.title = "Encrypt"
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Set up a changes observer and act on changes to the Realm data
    itemsToken = items!.observe { [weak tableView] changes in
      guard let tableView = tableView else { return }

      switch changes {
      case .initial:
        tableView.reloadData()
      case .update(_, let deletions, let insertions, let updates):
        tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
      case .error: break
      }
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Invalidate the Observer so we don't keep getting updates
    itemsToken?.invalidate()
  }

  // MARK: - Actions

  @IBAction func addItem() {
    userInputAlert("Add Todo Item",isSecure: false) { text in
        
        guard  text != nil else{ return}
      ToDoItem.add(text: text!)
    }
  }

  func toggleItem(_ item: ToDoItem) {
    item.toggleCompleted()
  }

  func deleteItem(item: ToDoItem) {
    item.delete()
  }

  @IBAction func encryptRealm() {
    
    
    if navigationItem.leftBarButtonItem?.title == "Decryt"{
        DecrytwithPassword()
    }else{
        showSetPassword()
    }
    
    
  }

  // MARK: - Navigation
  func showSetPassword() {
    let list = storyboard!.instantiateViewController(withIdentifier: "SetupViewController") as! SetupViewController
    list.setPassword = true

    UIView.transition(with: view.window!,
                      duration: 0.33,
                      options: .transitionFlipFromRight,
                      animations: {
                        self.view.window!.rootViewController = list
                      },
                      completion: nil)
  }
    
    func DecrytwithPassword() {
        let list = storyboard!.instantiateViewController(withIdentifier: "SetupViewController") as! SetupViewController
        list.Decrytable = true
        
        UIView.transition(with: view.window!,
                          duration: 0.33,
                          options: .transitionFlipFromRight,
                          animations: {
                            self.view.window!.rootViewController = list
        },
                          completion: nil)
    }
}

// MARK: - Table Data Source

extension ToDoListController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoTableViewCell

    if let item = items?[indexPath.row] {
      cell.update(with: item)
      cell.didToggleCompleted = { [weak self] in
        self?.toggleItem(item)
      }
    }

    return cell
  }
}

// MARK: - Table Delegate

extension ToDoListController {
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }

    if let item = items?[indexPath.row] {
        
      deleteItem(item: item)
    }
  }
}
