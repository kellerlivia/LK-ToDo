//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

// o nome do arquivo é o nome da classe
// a main é uma Table View Controller
// linkar o arquivo Swift a Main no inspetor
// colocar um identifier na célula da Table View no inspetor
// colocar barra de navegacão e editar

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Java", "Python", "Swift", "Firebase"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - TableView Datasource Methods
    
    // adicionando as celulas de acordo com o número de indices
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // retorna o texto em cada celula através do index
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // constante para armezenar
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    //MARK: - TableView Delegate Methods
    
    // pegar a célula que foi clicada
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // printa texto do index da célula (linha que foi clicada)
        // print(itemArray[indexPath.row])
        
        // colocando e tirando um acessorio
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // deselecionar
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}
