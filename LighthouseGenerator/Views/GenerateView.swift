//
//  GenerateView.swift
//  LighthouseGenerator
//
//  Created by Hasan Edain on 9/15/24.
//

import SwiftUI

struct GenerateView: View {
    @State var widthString: String = "10"
    @State var heightString: String = "10"
    @State var shipCountString: String = "10"
    @State var exportWidthString: String = "8.5"
    @State var exportHeightString: String = "11.0"
    @State var filenameString: String = "Lighthouse"
    @State private var saveCount: Int = 0

    @State var puzzle: Puzzle = Puzzle.empty
    
    var body: some View {
        HStack {
            VStack {
                Form {
                    Text("Puzzle")
                        .font(.title)
                        .fontWeight(.bold)
                    TextField(text: $widthString) {
                        Label(
                            title: { Text("Width") },
                            icon: { Image(systemName: "arrow.left.and.right") }
                        )
                    }
                    TextField(text: $heightString) {
                        Label(
                            title: { Text("Height") },
                            icon: { Image(systemName: "arrow.up.and.down") }
                        )
                    }
                    TextField(text: $shipCountString) {
                        Label(
                            title: { Text("Ships") },
                            icon: { Image(systemName: "number") }
                        )
                    }
                    Button("Generate") {
                        gen()
                    }

                    if puzzle.allShipsIlluminated == false {
                        Text("Invalid")
                    }
                }
                .padding(16)
                .frame(width: 148)
                Form {
                    Text("Export")
                        .font(.title)
                        .fontWeight(.bold)
                    TextField(text: $widthString) {
                        Label(
                            title: { Text("Width (inch)") },
                            icon: { Image(systemName: "arrow.left.and.right") }
                        )
                    }
                    TextField(text: $heightString) {
                        Label(
                            title: { Text("Height (inch)") },
                            icon: { Image(systemName: "arrow.up.and.down") }
                        )
                    }
                    TextField(text: $filenameString) {
                        Label(
                            title: { Text("Filename") },
                            icon: { Image(systemName: "doc.richtext") }
                        )
                    }
                    Button("Save") {
                        save()
                    }
                }
            }
            .padding(16)
            .frame(width: 248)

            //PuzzleView(puzzle: puzzle)
            //ShipView(puzzle: puzzle)
            solvedPuzzleView
        }
    }
    
    @ViewBuilder var solvedPuzzleView: some View {
        SolvedPuzzleView(puzzle: puzzle)
    }

    @ViewBuilder var unsolvedPuzzleView: some View {
        PuzzleView(puzzle: puzzle)
    }

    func gen() {
        guard let width = Int(widthString) else  {
            return
        }
        guard let height = Int(heightString) else {
            return
        }
        guard let shipCount = Int(shipCountString) else {
            return
        }
        self.puzzle = Puzzle.create(width: width, height: height, shipCount: shipCount)
    }
    
    @MainActor func save() {
        let rendererSolved = ImageRenderer(content: solvedPuzzleView)
        let redererPuzzle = ImageRenderer(content: unsolvedPuzzleView)

        let homeURL = FileManager.default.homeDirectoryForCurrentUser
        let solvedUrl = homeURL.appending(path: "\(filenameString)_\(saveCount)_solved.pdf")
        let unsolvedUrl = homeURL.appending(path: "\(filenameString)_\(saveCount)_puzzle.pdf")
        guard let width = Float(widthString) else  {
            return
        }
        guard let height = Float(heightString) else {
            return
        }

        rendererSolved.render { size, renderInContext in
            var box = CGRect(
                origin: .zero,
                size: .init(width: CGFloat(width*64), height: CGFloat(height*64))
            )

            guard let context = CGContext(solvedUrl as CFURL, mediaBox: &box, nil) else {
                return
            }

            context.beginPDFPage(nil)
            renderInContext(context)
            context.endPage()
            context.closePDF()
        }

        redererPuzzle.render { size, renderInContext in
            var box = CGRect(
                origin: .zero,
                size: .init(width: CGFloat(width*64), height: CGFloat(height*64))
            )

            guard let context = CGContext(unsolvedUrl as CFURL, mediaBox: &box, nil) else {
                return
            }

            context.beginPDFPage(nil)
            renderInContext(context)
            context.endPage()
            context.closePDF()
        }

        self.saveCount = saveCount + 1
    }
}

#Preview {
    GenerateView()
}
