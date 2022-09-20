//
//  ViewController.swift
//  LK ToDo
//
//  Created by Lívia Carvalho Keller on 12/09/2022.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    
    //MARK: - TableView Datasource Methods
    
    // adicionando as celulas de acordo com o número de indices
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // retorna o texto em cada celula através do index
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // constante para armezenar
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            // colocando e tirando um acessorio
            // valor = condicao ? valorVerdadeiro : valorFalso
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // pegar a célula que foi clicada
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        // deselecionar
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPrressed(_ sender: UIBarButtonItem) {
        
        // variavel para armazenar o campo do texto
        var textField = UITextField()
        
        // criando o alerta
        let alert = UIAlertController(title: "Add New LK ToDo Item", message: "", preferredStyle: .alert)
        // acao para adicionar o novo item
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        // criando uma acao no alerta
        alert.addAction(action)
        // colocando um campo de texto para o usuario adicionar o item
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            // textField recebe o valor do que o usuario digitou
            textField = alertTextField
            
        }
        // para o alerta aparecer na tela
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    
    // parametros internos e externos
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // voltar a lista original
        if searchBar.text?.count == 0 {
            loadItems()
            
            // tirando o cursor e teclado
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
