//
//  Cell.swift
//  LighthouseGenerator
//
//  Created by Hasan Edain on 9/15/24.
//

import Foundation

class Cell: Identifiable, Hashable {
    var type: CellType
    var id: UUID

    init(type: CellType, id: UUID = UUID()) {
        self.type = type
        self.id = id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(id)
    }

    static func == (lhs: Cell, rhs: Cell) -> Bool {
        if lhs.id != rhs.id {
            return false
        }

        if lhs.type != rhs.type {
            return false
        }

        return true
    }
}
