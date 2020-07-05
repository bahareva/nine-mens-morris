let p = Player(isFirst: true, colorForSecondPerson: Colors.black)
p.colorOfPools = Colors.white

let b = Board()
print(b.executeMove(player: p, placement: Position(ringNumber: 1, positionNumber: 3)))                 //true
print(b.checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: 1, positionNumber: 3)))       //false
print(b.executeMove(player: p, placement: Position(ringNumber: 1, positionNumber: 3)))                    //FALSE
print(b.executePlacement(fromPosition: Position(ringNumber: 1, positionNumber: 3), 
toPosition: Position(ringNumber: 0, positionNumber: 2)))                                                   //true
print(b.executeMove(player: p, placement: Position(ringNumber: 0, positionNumber: 1)))                      //true
print(b.executeMove(player: p, placement: Position(ringNumber: 0, positionNumber: 3)))                        //true
print(b.executeMove(player: p, placement: Position(ringNumber: 1, positionNumber: 2)))                         //true
print(b.checkNineMensMorris(player: p, currentPosition: Position(ringNumber: 0, positionNumber: 4)))       //false

print(b.checkAvailableNeighbours(currentPosition: Position(ringNumber: 0, positionNumber: 3)))               //true

print(b.checkIfPlayerCanMovePool(player: p))                                                               //true



