//
//  TableViewController.swift
//  CoreDataFun2
//
//  Created by Valeriy Kovalevskiy on 8/3/20.
//  Copyright © 2020 Valeriy Kovalevskiy. All rights reserved.
//

import UIKit
import CoreData


class TableViewController: UITableViewController {

    var tasks = [Task]()
    var managedContext: NSManagedObjectContext!
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTasks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        self.managedContext = managedContext
        
        
        
        
    }
    
        func fetchTasks() {
            do {
                let request = Task.fetchRequest() as NSFetchRequest<Task>

                
                self.tasks = try managedContext.fetch(request)
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
            catch {
        
            }
        }

    //MARK: - Methods
    func createTask() {

        let ac = UIAlertController(title: "Edit person", message: "Edit name:", preferredStyle: .alert)
        ac.addTextField()
        
        let textField = ac.textFields?[0]

        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] action in

            guard let strongSelf = self else { return }
            guard let text = textField?.text else { return }
            
            self?.saveTask(name: text, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let finished):
                    if finished {
                        strongSelf.tableView.reloadData()
                    }
                    else {
                        
                    }
                }
                
            })
            


        })
        present(ac, animated: true)

    }
    
    func saveTask(name: String,
                  isCompleted: Bool = false,
                  imageData: UIImage = UIImage(systemName: "pencil.slash")!,
                  id: UUID = UUID(),
                  endDate: Date = Date(),
                  describe: String = "",
                  creationDate: Date = Date(),
                  completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else { return }
        
        let task = Task(entity: entity, insertInto: managedContext)
        
        task.name = name
        task.imageData = imageData.pngData()
        task.id = id
        task.creationDate = creationDate
        task.endDate = endDate
        task.isCompleted = isCompleted
        task.describe = ""
        task.color = UIColor.red
        
        do {
            try managedContext.save()
            tasks.append(task)
            completion(.success(true))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    //MARK: - Actions
    @IBAction func didTappedAddButton(_ sender: UIBarButtonItem) {
        createTask()
        
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = tasks[indexPath.row].name
        cell.detailTextLabel?.text = tasks[indexPath.row].describe

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailViewController()
        controller.managedContext = self.managedContext
        self.navigationController?.pushViewController(controller, animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
