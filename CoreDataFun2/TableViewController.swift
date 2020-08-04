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
    
    var tasksTableDataSource: [[Task]] {
        return [nonCompletedTasks, completedTasks]
    }
    
    var completedTasks = [Task]()
    var nonCompletedTasks = [Task]()
    
    let headerTitles = ["Undone", "Done"]
    
    var managedContext: NSManagedObjectContext!
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTasks()
        filterTasks()
        
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
            
            //sort completed and not completed
            
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

            guard let text = textField?.text else { return }
            
            self?.saveTask(name: text, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let finished):
                    if finished {
                        self?.filterTasks()
                        self?.tableView.reloadData()
                    }
                    else {
                        
                    }
                }
                
            })
            


        })
        present(ac, animated: true)

    }
    
    func filterTasks() {
        tasks.forEach { $0.isCompleted == true ? completedTasks.append($0) : nonCompletedTasks.append($0) }
        self.tableView.reloadData()
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
        
        fetchTasks()
    }
    
    //MARK: - Actions
    @IBAction func didTappedAddButton(_ sender: UIBarButtonItem) {
        createTask()
        
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksTableDataSource[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        tasksTableDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }

        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cellTask = tasksTableDataSource[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = cellTask.name
        fetchTasks()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailViewController()
        controller.managedContext = self.managedContext
        
        let cellTask = tasksTableDataSource[indexPath.section][indexPath.row]
        controller.taskTitle = cellTask.name
        cellTask.isCompleted = true
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
