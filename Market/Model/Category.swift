//
//  Category.swift
//  Market
//
//  Created by MYMACBOOK on 27.04.2021.
//

import UIKit

struct Category {
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(name: String, imageName: String) {
        self.id = ""
        self.name = name
        self.imageName = imageName
    }
    
    init(dictionary: NSDictionary) {
        self.id = dictionary[kOBJECTID] as! String
        self.name = dictionary[kNAME] as! String
        self.image = UIImage(named: dictionary[kIMAGENAME] as? String ?? "")
    }
}
