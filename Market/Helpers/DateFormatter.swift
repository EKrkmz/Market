//
//  DateFormatter.swift
//  Market
//
//  Created by MYMACBOOK on 1.05.2021.
//

import Foundation

func dateFormatter() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm E, d MMM y"
    return formatter.string(from: date)
}
