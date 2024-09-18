    //
    //  Puzzle.swift
    //  LighthouseGenerator
    //
    //  Created by Hasan Edain on 9/15/24.
    //

import Foundation

class Puzzle {
    var cells: [[Cell]]
    var width: Int
    var height: Int
    var shipCount: Int
    private var ships: [Location] = [Location]()
    private var lighthouses: [Location] = [Location]()

    init(cells: [[Cell]], width: Int, height: Int, shipCount: Int) {
        self.cells = cells
        self.width = width
        self.height = height
        self.shipCount = shipCount
    }

    static func create(width: Int, height: Int, shipCount: Int) -> Puzzle {
        var cells = [[Cell]]()

        for i in  0..<height {
            cells.append([Cell]())
            for _ in 0..<width {
                cells[i].append(Cell(type: .empty))
            }
        }

        let puzzle = Puzzle(cells: cells, width: width, height: height, shipCount: shipCount)

        puzzle.placeShips()
        puzzle.placeLighthouses()

        var count = 0
        while puzzle.validData == false && count < 20 {
            puzzle.clear()
            puzzle.placeShips()
            puzzle.placeLighthouses()
            count = count + 1
        }

        if count > 0 {
            print("\(count) attempts to create board. Dark Ships: \(puzzle.darkShips.sorted())")
        } else {
            print("Ships: \(puzzle.ships.sorted())")
            print("Lighthouses: \(puzzle.lighthouses.sorted())")
        }


        return puzzle
    }
    var validData: Bool {
        if darkShips.isEmpty {
            return true
        }

        return false
    }

    func clear() {
        for i in  0..<height {
            cells.append([Cell]())
            for j in 0..<width {
                let location = Location(x: j, y: i)
                update(location: location, toType: .empty)
            }
        }

        ships.removeAll()
        lighthouses.removeAll()
    }

    static var empty: Puzzle {
        var cells = [[Cell]]()
        let width = 10
        let height = 10
        let shipCount = 10

        for i in  0..<height {
            cells.append([Cell]())
            for _ in 0..<width {
                cells[i].append(Cell(type: .empty))
            }
        }

        let puzzle = Puzzle(cells: cells, width: width, height: height, shipCount: shipCount)

        return puzzle
    }

    static var startGame: Puzzle {
        let puzzle = Puzzle.empty
        puzzle.placeShips()
        puzzle.placeLighthouses()

        return puzzle
    }

    static var tenShips: Puzzle {
        let puzzle = Puzzle.empty
        puzzle.placeShips()

        return puzzle
    }

    func placeShips() {
        ships.removeAll()
        for _ in 0..<shipCount {
            placeShip()
        }
    }

    func randomLocation() -> Location {
        let x = Int.random(in: 0..<width)
        let y = Int.random(in: 0..<height)

        let location = Location(x: x, y: y)

        return location
    }

    func type(at location: Location) -> CellType {
        return cells[location.y][location.x].type
    }

    func update(location: Location, toType: CellType) {
        cells[location.y][location.x].type = toType
    }

    func inBounds(location: Location) -> Bool {
        if location.x < 0 {
            return false
        } else if location.x >= width {
            return false
        } else if location.y < 0 {
            return false
        } else if location.y >= height {
            return false
        }

        return true
    }

    func placeShip() {
        var placed: Bool = false

        while placed != true {
            let location = randomLocation()

            if canPlace(location: location) {
                update(location: location, toType: .ship)
                ships.append(location)
                placed = true
            }
        }
    }

    func placeLighthouses() {
        lighthouses.removeAll()
        var tryCount = 0

        while darkShips.isEmpty == false && tryCount < (10 * width * height) {
            let location = randomLocation()
            if canPlaceLighthouse(location: location) {
                placeLighthouse(location: location)
            }

            tryCount = tryCount + 1
        }

        tryCount = 0
        while (darkShips.isEmpty == false) && tryCount < ( width + height ) {
            let shipLocation = randomDarkShip

            attachLighthouse(location: shipLocation)

            tryCount = tryCount + 1
        }
    }

    func attachLighthouse(location: Location) {
        var placed = false
        for row in 0..<height {
            if row != location.y {
                guard placed == false else {
                    return
                }
                let rowLocation = Location(x: location.x, y: row)
                let type = type(at: rowLocation)
                if type == .empty {
                    if canPlace(location: location) {
                        placeLighthouse(location: location)
                        placed = true
                    }
                }
            }
        }

        for column in 0..<width {
            if column != location.x {
                guard placed == false else {
                    return
                }
                let columnLocation = Location(x: column, y: location.y)
                let type = type(at: columnLocation)
                if type == .empty {
                    if canPlace(location: location) {
                        placeLighthouse(location: location)
                        placed = true
                    }
                }
            }
        }
    }

    var iluminatedShips: [Location] {
        var illuminated: [Location] = [Location]()

        ships.forEach { location in
            if isIlluminated(location: location) {
                illuminated.append(location)
            }
        }

        return illuminated
    }

    var randomDarkShip: Location {
        let dark = darkShips

        guard let darkShip = dark.randomElement() else {
            return Location.invalid
        }

        return darkShip
    }

    var darkShips: [Location] {
        var dark: [Location] = [Location]()

        ships.forEach { location in
            let light = isIlluminated(location: location)
            if light == false {
                dark.append(location)
            }
        }

        return dark
    }

    func isIlluminated(location: Location) -> Bool {
        var count: Int = 0

        for row in 0..<height {
            if row != location.y {
                let rowLocation = Location(x: location.x, y: row)
                let type = type(at: rowLocation)
                if type == .lighthouse {
                    count = count + 1
                }
            }
        }

        for column in 0..<width {
            if column != location.x {
                let columnLocation = Location(x: column, y: location.y)
                let type = type(at: columnLocation)
                if type == .lighthouse {
                    count = count + 1
                }
            }
        }

        return count > 0
    }

    func placeLighthouse(location: Location) {
        if canPlaceLighthouse(location: location) {
            update(location: location, toType: .lighthouse)
            lighthouses.append(location)
        }
    }

    func canPlaceLighthouse(location: Location) -> Bool {
        if canPlace(location: location) {
            let lighthousesInView = viewCount(cellType: .lighthouse, location: location)
            if lighthousesInView == 0 {
                let shipsInView = viewCount(cellType: .ship, location: location)
                if  shipsInView > 0 {
                    return true
                }
            }
        }

        return false
    }

    func viewCount(cellType: CellType, location: Location) -> Int {
        var count: Int = 0

        for row in 0..<height {
            let rowLocation = Location(x: location.x, y: row)
            if cellType == type(at: rowLocation) {
                count = count + 1
            }
        }

        for column in 0..<width {
            let columnLocation = Location(x: column, y: location.y)
            if type(at: columnLocation) == cellType {
                count = count + 1
            }
        }


        return count
    }

    func canPlace(location: Location) -> Bool {
        var placeable = true
        for yLocation in location.y-1...location.y+1 {
            for xLocation in location.x-1...location.x+1 {
                if yLocation >= 0 && xLocation >= 0 && yLocation < height && xLocation < width {
                    let value = cells[yLocation][xLocation]
                    if value.type != .empty {
                        placeable = false
                    }
                }
            }
        }

        return placeable
    }

    var allShipsIlluminated: Bool {
        var allIluminated = true

        ships.forEach { location in
            let illuminated = isIlluminated(location: location)
            if illuminated == false {
                allIluminated = false
            }
        }

        return allIluminated
    }
}
