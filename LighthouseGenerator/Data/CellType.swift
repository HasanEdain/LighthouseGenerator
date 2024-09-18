//
//  CellType.swift
//  LighthouseGenerator
//
//  Created by Hasan Edain on 9/15/24.
//

import Foundation
import SwiftUI

enum CellType {


    case water
    case ship
    case lighthouse
    case empty

    var color: Color {
        switch self {
            case .water:
                return .blue
            case .ship:
                return .gray
            case .lighthouse:
                return .yellow
            case .empty:
                return .white
        }
    }

    var name: String {
        switch self {
            case .water:
                return "Water"
            case .ship:
                return "Ship"
            case .lighthouse:
                return "Lighthouse"
            case .empty:
                return "Empty"
        }
    }

    var image: Image {
        switch self {
            case .water:
                return Image(systemName: "water.waves")
            case .ship:
                return Image(systemName: "sailboat")
            case .lighthouse:
                return Image(systemName: "light.beacon.max.fill")
            case .empty:
                return Image(systemName: "square.fill")
        }
    }

}
