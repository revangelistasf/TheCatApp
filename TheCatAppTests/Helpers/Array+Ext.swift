//
//  Array+Ext.swift
//  TheCatAppTests
//
//  Created by revangelista on 08/05/2024.
//

import Foundation

extension Array where Element: Encodable {
    func jsonData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
