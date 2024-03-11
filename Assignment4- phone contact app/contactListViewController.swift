//
//  ViewController.swift
//  Assignment4- phone contact app
//
//  Created by Administrator on 04/03/24.
//

import UIKit

class contactListViewController: UIViewController {

    var data = [Contacts]()

    var sectionTitle = [String]()
    
    var sectionDict = [String: [Contacts]]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "contactTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "contactTableViewCell")
        
        contactListApi(URL: "https://61db84524593510017aff8d4.mockapi.io/contactbook/v1/getlist") { result in
            self.data = result
            DispatchQueue.main.async {      //update ui on the main thread
                self.tableView.reloadData()
            }
        }
        
        sectionTitle = Array(Set(data.compactMap({String($0.firstName.prefix(1))})))  //take the first character of names
        sectionTitle.sort()
        sectionTitle.forEach({sectionDict[$0] = [Contacts]()}) // make blank array for every section title
       // data.forEach({sectionDict[String($0.firstName.prefix(1))]?.append($0)})
        data.forEach { contact in
                let firstLetter = String(contact.firstName.prefix(1))
                if var contactsArray = sectionDict[firstLetter] {
                    contactsArray.append(contact)
                    sectionDict[firstLetter] = contactsArray
                } else {
                    sectionDict[firstLetter] = [contact]
                }
            }
        
    }

    func contactListApi(URL url: String, completion: @escaping ([Contacts]) -> Void){  // @escaping has 2 purposes: storing a closure and async operating purposes.
        
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
    
    func fetchImageFromAPI(for indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
            
            let imageURLString = data[indexPath.row].avatarUrl
            
            // Convert the imageURLString to URL
            guard let imageURL = URL(string: imageURLString) else {
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

extension contactListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return data.count
        
        //DOUBT
        sectionDict[sectionTitle[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCell") as! contactTableViewCell
        //cell.firstName.text = data[indexPath.row].firstName
        cell.firstName.text = sectionDict[sectionTitle[indexPath.section]]?[indexPath.row].firstName
        cell.lastName.text = data[indexPath.row].lastName
        cell.lastName.text = sectionDict[sectionTitle[indexPath.section]]?[indexPath.row].lastName
       // cell.contactImage.image = UIImage(data[indexPath.row].avatarUrl)
        fetchImageFromAPI(for: indexPath) { image in
                    // Update UI on the main thread
                    DispatchQueue.main.async {
                        cell.contactImage.image = image
                    }
                }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitle[section]
    }
}



