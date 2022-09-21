//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Livia Carvalho Keller on 19/09/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    // array que armazena as categorias
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        navBar.backgroundColor = UIColor(hexString: "FA2FB5")
    }
    
    //MARK: - TableView Datasource Methods
    
    // adicionando as celulas de acordo com o número de indices
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // se for nulo, retorna 1
        return categories?.count ?? 1
    }
    
    // retorna o texto em cada celula através do index
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
            cell.backgroundColor = UIColor(hexString: category.colour)
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
        
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
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }

    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // variavel para armazenar o campo do texto
        var textField = UITextField()
        
        // criando o alerta
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            // instanciando a categoria e definindo os atributos que ela vai ter
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            
            // salvando a nova categoria
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
