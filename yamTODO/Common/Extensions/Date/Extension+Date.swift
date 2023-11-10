//
//  Extension+Date.swift
//  yamTODO
//
//  Created by Jiny on 11/9/23.
//

import Foundation

extension Date {
  static let calendarDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY.MM"
    return formatter
  }()
  
  static let keyDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYYMMdd"
    return formatter
  }()
}
