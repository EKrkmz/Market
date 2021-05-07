//
//  ItemsTableViewController.swift
//  Market
//
//  Created by MYMACBOOK on 27.04.2021.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    var category: Category?
    var itemArray: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category?.name
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            loadItems()
        }
    }
    
    func loadItems() {
        ItemManager.shared.downloadItemsFromFirebase(category!.id) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemToAddItemSeg" {
            guard let vc = segue.destination as? AddItemViewController else { return }
            vc.category = category
        }
    }
    
    private func showItemView(item: Item) {
        guard let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as? ItemViewController else { return }
        itemVC.item = item
        show(itemVC, sender: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(itemArray[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(item: itemArray[indexPath.row])
    }
}
