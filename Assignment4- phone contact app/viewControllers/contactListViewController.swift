//
//  ViewController.swift
//  Assignment4- phone contact app
//
//  Created by Administrator on 04/03/24.
//

import UIKit
import CoreData
import MBProgressHUD

class contactListViewController: UIViewController {

    var data = [Contacts]()

    var sectionTitle = [String]()
    
    var sectionDict = [String: [Contacts]]()
    
    @IBOutlet weak var newContactButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "contactTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "contactTableViewCell")
        self.tableView.rowHeight = 93.0
        tableView.sectionIndexColor = UIColor.systemGreen

        fetchContactsFromLocalDB()
     
    }
    
    func fetchContactsFromLocalDB(){
        if contactsAvailableLocally(){
            displayContacts()
        }else{
            fetchContactsFromServer()
        }
    }
    
    func contactsAvailableLocally() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return false //initialize core data stack
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts") //fetch request
        do{
            let contacts = try managedContext.fetch(fetchRequest)
            
            return !contacts.isEmpty
        }catch let error as NSError{
            print("Error fetching contacts: \(error.localizedDescription)")
            return false
        }
        
    }
    
    func displayContacts(){
        populateSections()
        tableView.reloadData()
    }
    
    func fetchContactsFromServer(){
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        contactListApi(URL: "https://61db84524593510017aff8d4.mockapi.io/contactbook/v1/getlist") { result in
            self.data = result
            
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.displayContacts()
                //update ui on the main thread
                self.tableView.reloadData()
            }
            
            //need to save to data to local db
            self.saveContactsToDB()
               }
    }
    
    func saveContactsToDB(){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            
            for contactData in self.data {
                if let contactEntity = NSEntityDescription.entity(forEntityName: "Contact", in: context) {
                    let contact = NSManagedObject(entity: contactEntity, insertInto: context)
                    contact.setValue(contactData.firstName, forKey: "firstName")
                    contact.setValue(contactData.lastName, forKey: "lastName")
                    contact.setValue(contactData.mobileNumber, forKey: "mobileNumber")
                    contact.setValue(contactData.email, forKey: "email")
                    
                    // Save the context
                    do {
                        try context.save()
                    } catch {
                        print("Error saving contact to local DB: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
        

    
        func populateSections() {
            sectionTitle = Array(Set(data.map { String($0.firstName.prefix(1)) }))
            sectionTitle.sort()
            sectionDict = Dictionary(grouping: data) { String($0.firstName.prefix(1)) }//data source
        }
        
    // MARK - call contact api
    func contactListApi(URL url: String, completion: @escaping ([Contacts]) -> Void){  // @escaping has 2 purposes: storing a closure and async operating purposes.
        
   //     MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = URL(string: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { data, response, error in   //helps in taking data from the url
            if data != nil && error == nil {
                do{
                    let parsingData = try JSONDecoder().decode([Contacts].self, from: data!)
                    completion(parsingData)
                } catch{
                    print(error)
                }
            }
        }
        dataTask.resume()
        
    }
    
    //this part can be done in other ways - ask Prasanna
    
    // made the function to acept the url directly so that each cell will fetch its corresponding image.
    
    func fetchImageFromAPI(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }
            
            // Fetch image data asynchronously
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                guard let imageData = data, error == nil else {
                    completion(nil)
                    return
                }
                
                // Convert image data to UIImage
                if let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    
    
}



extension contactListViewController: editViewControllerDelegate{
    func didUpdateContact(_ contact: Contacts, atIndex index: Int) {
        //update the data array
        data[index] = contact
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    
}

extension contactListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
         return sectionDict[sectionTitle[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCell", for: indexPath) as! contactTableViewCell
        
        
        if let contact = sectionDict[sectionTitle[indexPath.section]]?[indexPath.row] {
                    let fullName = "\(contact.firstName) \(contact.lastName)"
                    cell.firstName.text = fullName
                
                // Fetch contact image asynchronously
                    fetchImageFromAPI(url: contact.avatarUrl) { image in
                        DispatchQueue.main.async {
                            // Check if the cell is still visible and if the fetched image is not nil
                            if let visibleIndexPaths = tableView.indexPathsForVisibleRows, visibleIndexPaths.contains(indexPath), let image = image {
                                // Assign the fetched image to the cell
                                cell.contactImage.image = image
                            }
                        }
                    }
            
                }
        
        
//        // cell.firstName.text = sectionDict[sectionTitle[indexPath.section]]?[indexPath.row].firstName
//        //cell.lastName.text = data[indexPath.row].lastName
//       // cell.lastName.text = sectionDict[sectionTitle[indexPath.section]]?[indexPath.row].lastName
//       // cell.contactImage.image = UIImage(data[indexPath.row].avatarUrl)
//
//
//        fetchImageFromAPI(for: indexPath) { image in
//                    // Update UI on the main thread
//                    DispatchQueue.main.async {
//                        cell.contactImage.image = image
//                    }
//                }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionTitle
    }
    
    //section title color
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .lightGray
            headerView.textLabel?.textColor = .white
        }
    }
    
        //linking cell to next screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? contactTableViewCell,
           let vc = storyboard?.instantiateViewController(withIdentifier: "editViewController") as? editViewController{
            vc.img = cell.contactImage.image!
            vc.name = cell.firstName.text!
            
            if let contacts = sectionDict[sectionTitle[indexPath.section]]?[indexPath.row]{
                vc.email = contacts.email
                vc.phnum = contacts.mobileNumber
                vc.data = self.data     //display the changes in og data file
                vc.contactIndex = indexPath.row
                
            }
            vc.delegate = self //set self as a delegate

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension contactListViewController {
    func addNewContact(_ contact: Contacts) {
        // Add the new contact to your data source coming from newContactViewController
        data.append(contact)
        populateSections()
        tableView.reloadData()
    }
}



