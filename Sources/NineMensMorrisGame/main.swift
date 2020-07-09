var b = Board()
var v = Visualisation(fields: b.board)

let g = Game()

g.placeAllPoolsOnBoard(firstPlayer: g.firstPlayer, secondPlayer: g.secondPlayer,endGame: &end, b: &b.board)
var end = false
g.makeMovements(firstPlayer: g.firstPlayer, secondPlayer: g.secondPlayer, endGame: &end, b: &b.board)