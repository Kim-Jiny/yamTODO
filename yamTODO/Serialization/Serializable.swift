//
//  Serializable.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/18.
//

import Foundation

protocol Serializable {
    static func decode(_ data: Data) throws -> Self
}
