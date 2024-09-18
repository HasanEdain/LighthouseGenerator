    //
    //  CellView.swift
    //  LighthouseGenerator
    //
    //  Created by Hasan Edain on 9/15/24.
    //

import SwiftUI

struct CellView: View {
    var celltype: CellType

    var body: some View {
        ZStack {
            Rectangle()
                .fill(celltype.color).aspectRatio(contentMode: .fit)
                .border(Color.red)
            if celltype != .empty && celltype != .lighthouse {
                celltype.image
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }.frame(width: 64.0,height: 64.0)
    }
}

#Preview {

    let vstack = VStack {
        CellView(celltype: .water)
        CellView(celltype: .empty)
        CellView(celltype: .ship)
        CellView(celltype: .lighthouse)
    }

    return vstack
}
