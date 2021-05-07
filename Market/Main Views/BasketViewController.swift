//
//  BasketViewController.swift
//  Market
//
//  Created by MYMACBOOK on 29.04.2021.
//

import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var basket: Basket?
    var allItems: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBasketFromFirestore()
    }
    
    //MARK: - Download basket
    private func loadBasketFromFirestore() {     //USER
        BasketManager.shared.downloadBasketFromFirestore(USER1) { (basket) in
            self.basket = basket
            self.getBasketItems()
        }
    }
    
    private func getBasketItems() {
        if let basket = basket {
            ItemManager.shared.downloadItems(basket.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalLabels(false)
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: Remove item from basket
    private func removeItemFromBasket(itemId: String) {
        if var basket = basket {
            for i in 0..<basket.itemIds.count {
                if itemId == basket.itemIds[i] {
                    basket.itemIds.remove(at: i)
                    self.basket = basket
                    return
                }
            }
        }
    }
    
    //MARK: - Helper functions
    private func updateTotalLabels(_ isEmpty: Bool) {
        if isEmpty {
            totalItemsLabel.text = "0"
        } else {
            totalItemsLabel.text = "\(allItems.count)"
        }
    }
    
    //MARK: - Navigation
    private func showItemView(withItem: Item) {
        guard let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as? ItemViewController else { return }
        itemVC.item = withItem
        show(itemVC, sender: true)
    }
}

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(allItems[indexPath.row])
        return cell
    }
    
    //MARK: - UITableview Delegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = allItems[indexPath.row]
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemFromBasket(itemId: itemToDelete.id)

            BasketManager.shared.updateBasketInFirestore(basket!, withValues: [kITEMIDS : basket!.itemIds ?? [""]]) { (error) in
                if error != nil {
                    print("error updating the basket", error!.localizedDescription)
                }
                self.getBasketItems()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
}
