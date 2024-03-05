//
//  ViewController.swift
//  Assignment4- phone contact app
//
//  Created by Administrator on 04/03/24.
//

import UIKit

class contactListViewController: UIViewController {

    var data = [Contacts]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        contactListApi(URL: "https://61db84524593510017aff8d4.mockapi.io/contactbook/v1/getlist") { result in
            self.data = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
}

extension contactListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = data[indexPath.row].firstName 
        		    
        return cell!
    }
}



