var b = Board()
var v = Visualisation(fields: b.board)

let g = Game()

g.placeAllPoolsOnBoard(firstPlayer: g.firstPlayer, secondPlayer: g.secondPlayer, b: &b.board)
//v = Visualisation(fields: b.board)
//v.printBoard()

// if b.executePlacement(player: g.firstPlayer, ringNumber: 0, positionNumber: 5, b: &b.board) {
//    // v = Visualisation(fields: b.board)
//     print("in main before print: ")
//     v.printBoard()
// }

//print(g.firstPlayer.colorOfPools.rawValue)

