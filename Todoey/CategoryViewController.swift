//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Livia Carvalho Keller on 19/09/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    // array que armazena as categorias
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    //MARK: - TableView Datasource Methods
    
    // adicionando as celulas de acordo com o número de indices
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // se for nulo, retorna 1
        return categories?.count ?? 1
    }
    
    // retorna o texto em cada celula através do index
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func save (category: Category) {
        
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // parametros internos e externos
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()

    }

    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // variavel para armazenar o campo do texto
        var textField = UITextField()
        
        // criando o alerta
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        // criando uma acao no alerta
        alert.addAction(action)
        // colocando um campo de texto para o usuario adicionar a categoria
        alert.addTextField { field in
            field.placeholder = "Create new category"
            // textField recebe o valor do que o usuario digitou
            textField = field
            
        }
        // para o alerta aparecer na tela
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        // linha atual selecionada
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
