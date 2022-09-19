//
//  ViewController.swift
//  LK ToDo
//
//  Created by Lívia Carvalho Keller on 12/09/2022.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
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
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // colocando e tirando um acessorio
        // valor = condicao ? valorVerdadeiro : valorFalso
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // pegar a célula que foi clicada
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // printa texto do index da célula (linha que foi clicada)
        // print(itemArray[indexPath.row])
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // verdadeiro ou falso (opostos)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
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
            // o que acontecerá quando o usuário clicar no botão de adicionar item
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            // adicionando o que o usuario escreveu no array
            self.itemArray.append(newItem)
            self.saveItems()
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
    
    func saveItems () {
       
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
}
