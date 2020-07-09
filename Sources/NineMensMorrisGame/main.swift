var b = Board()
var v = Visualisation(fields: b.board)

let g = Game()

g.placeAllPoolsOnBoard(endGame: &end)
var end = false
g.makeMovements(endGame: &end)