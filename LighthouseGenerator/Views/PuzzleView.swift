//
//  PuzzleView.swift
//  LighthouseGenerator
//
//  Created by Hasan Edain on 9/15/24.
//

import SwiftUI

struct PuzzleView: View {
    var puzzle: Puzzle

    let spacing: CGFloat = -8.0

    var body: some View {
        VStack {
            ForEach(puzzle.cells.indices, id: \.self) { yIndex in
                VStack (spacing: 0.0){
                    HStack (spacing: 0.0) {
                        ForEach(puzzle.cells[yIndex].indices, id: \.self) { xIndex in
                            cellView(xIndex: xIndex, yIndex: yIndex)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder func cellView(xIndex: Int, yIndex: Int) -> some View {
        let location = Location(x: xIndex, y: yIndex)
        let type = puzzle.type(at: location)
        if  type == .lighthouse {
            LighthouseView(shipCount: puzzle.viewCount(cellType: .ship, location: location))
                .padding(.bottom,spacing)
        } else {
            CellView(celltype: CellType.empty)
                .padding(.bottom,spacing)
        }
    }
}

#Preview {
    let startPuzzle = Puzzle.startGame

    return PuzzleView(puzzle: startPuzzle)
}
