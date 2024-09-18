//
//  LighthouseView.swift
//  LighthouseGenerator
//
//  Created by Hasan Edain on 9/15/24.
//

import SwiftUI

struct LighthouseView: View {
    var shipCount: Int

    var body: some View {
        ZStack {

            CellView(celltype: .lighthouse)
            Text(String(shipCount))
                .fontWeight(.black)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    let vstack = VStack {
        LighthouseView(shipCount: 0)
        LighthouseView(shipCount: 1)
        LighthouseView(shipCount: 2)
        LighthouseView(shipCount: 3)
    }
    return vstack
}
