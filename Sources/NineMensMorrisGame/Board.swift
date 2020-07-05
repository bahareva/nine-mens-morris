import Foundation

protocol Rules {

   func checkNineMensMorris(player: Player, currentPosition: Position) -> Bool
   func checkIfPlayerCanMovePool(player: Player) -> Bool
   func checkIfGivenPositionIsAvailable(givenPosition: Position) -> Bool
   func checkAvailableNeighbours(currentPosition: Position) -> Bool
}

struct Position {
    var ringNumber: Int
    var positionNumber: Int

    init(ringNumber: Int, positionNumber: Int) {
        self.ringNumber = ringNumber
        self.positionNumber = positionNumber
    }
}

class Board: Rules {

    var board: [[String]]
    var validCoordinates:[String]

    init() {
        board = Array(repeating:  Array(repeating: "·", count: 8), count: 3); 

        validCoordinates = 
        ["A1","A4","A7","B2","B4","B6","C3","C4",
        "C5","D1","D2","D3","D5","D6","D7","E3",
        "E4","E5","F2","F4","F6", "G1","G4","G7"]
    }

    func checkIfGivenPositionIsAvailable(givenPosition: Position) -> Bool {
        if board[givenPosition.ringNumber][givenPosition.positionNumber] == "·" {
            return true
        }
        else {
            return false
        }
    }

    func checkAvailableNeighbours(currentPosition: Position) -> Bool {
        if currentPosition.positionNumber % 2 == 0 {
            switch currentPosition.ringNumber {
                case 0: 
                    return checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber, positionNumber: (currentPosition.positionNumber + 1) % 8)) ||
                        checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber, positionNumber: (8+currentPosition.positionNumber -1) % 8)) ||
                        checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber + 1, positionNumber: currentPosition.positionNumber))
                case 1:
                    return checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber, positionNumber: (currentPosition.positionNumber + 1) % 8)) ||
                        checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber, positionNumber: (8+currentPosition.positionNumber - 1) % 8)) ||
                        checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber + 1, positionNumber: currentPosition.positionNumber)) ||
                        checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber - 1, positionNumber: currentPosition.positionNumber))
                case 2: 
                    return checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber, positionNumber: (8+currentPosition.positionNumber -1)%8)) ||
                        checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber, positionNumber: (currentPosition.positionNumber + 1)%8)) ||
                        checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber - 1, positionNumber: currentPosition.positionNumber))
            }
        }
        else {
            return checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber, positionNumber: (8+currentPosition.positionNumber -1)% 8)) ||
                checkIfGivenPositionIsAvailable(givenPosition: Position(ringNumber: currentPosition.ringNumber, positionNumber: (8+currentPosition.positionNumber + 1)%8))
        }
    }

    func checkIfPlayerCanMovePool(player: Player) -> Bool {
        let colorOfPool = player.colorOfPools

        for element in coordinates {
            for value in element {
                if value == colorOfPool.rawValue {
                    if checkAvailableNeighbours(currentPosition: Position(ringNumber: element, positionNumber: value)) {
                        return true
                    }
                }
            }
        }
        return false
    }

    func checkEqualColors(color: Color, leftPos: i, rightPos: j) {
        if color.rawValue == board[i][j] {
            return true
        } else {
            return false
        }
    }

    func checkNineMensMorris(player: Player, currentPosition: Position) -> Bool {
        // след всяко поставяне и след всяко местене се проверява за "дама"
        let colorOfPool = player.colorOfPools.rawValue
        let curPosLeft = currentPosition.ringNumber
        let curPosRight = currentPosition.positionNumber

        if curPosRight % 2 == 0 {
            return (checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (curPosRight + 1) % 8) && 
                checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (8 + curPosRight - 1) % 8)) ||
                (checkEqualColors(color: colorOfPool, leftPos: (curPosLeft + 1) % 3, rightPos: curPosRight) && 
                checkEqualColors(color: colorOfPool, leftPos: (curPosLeft + 2) % 3, rightPos: curPosRight)
        } else {
            return (checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (curPosRight + 1) % 8) && 
                checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (curPosRight + 2) % 8)) ||
                (checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (8 + curPosRight - 1) % 8) && 
                checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (8 + curPosRight - 2) % 8)
        }
        
    }

    func executePlacement(fromPosition: Position, toPosition: Position) -> Bool {
        let fromPosLeft = fromPosition.ringNumber
        let fromPosRight = fromPosition.positionNumber

        let toPosLeft = toPosition.ringNumber
        let toPosRight = toPosition.positionNumber

        if board[fromPosLeft][fromPosRight] != "·" && board[toPosLeft][toPosRight] == "·" {
            board[toPosLeft][toPosRight] = board[fromPosLeft][fromPosRight]
            return true
        }

        return false
    }

    func executeMove(player: Player, placement: Position) -> Bool {
        let colorOfPlayer = player.colorOfPool.rawValue
        let posLeft = placement.ringNumber
        let posRight = placement.positionNumber
        if board[posLeft][posRight] == "·" {
            board[posLeft][posRight] = colorOfPlayer
            return true
        }
        return false
    }

    func checkCoordinates(coordinates:String) -> Bool {

        if validCoordinates.contains(coordinates) {
            return true
        }
        else {
            return false
        }
    }

    func takePool(positionOfPoolToRemove: Position) {
        let posLeft = positionOfPoolToRemove.ringNumber
        let posRight = positionOfPoolToRemove.positionNumber
        board[posLeft][posRight] = "·"
    }

}
