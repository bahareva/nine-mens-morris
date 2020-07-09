import Foundation

protocol Rules {

   func checkNineMensMorris(player: Player, ringNumber: Int, positionNumber: Int) -> Bool
   func checkIfPlayerCanMovePool(player: Player) -> Bool
   func checkIfGivenPositionIsAvailable(ringNumber: Int, positionNumber: Int) -> Bool
   func checkAvailableNeighbours(ringNumber: Int, positionNumber: Int) -> Bool
}

class Board: Rules {

    var ringNumber: Int
    var positionNumber: Int
    var board: [[String]]
    var validCoordinates:[String]

    init() {
        self.board = Array(repeating:  Array(repeating: "·", count: 8), count: 3); 
        self.positionNumber = 0
        self.ringNumber = 0

        validCoordinates = 
        ["A1","A4","A7","B2","B4","B6","C3","C4",
        "C5","D1","D2","D3","D5","D6","D7","E3",
        "E4","E5","F2","F4","F6", "G1","G4","G7"]
    }

    func checkIfGivenPositionIsAvailable(ringNumber: Int, positionNumber: Int) -> Bool {
        if board[ringNumber][positionNumber] == "·" {
            return true
        }
        else {
            return false
        }
    }

    func checkAvailableNeighbours(ringNumber: Int, positionNumber: Int) -> Bool {
        if positionNumber % 2 == 0 {
            switch ringNumber {
                case 0: 
                    return checkIfGivenPositionIsAvailable(ringNumber: ringNumber, positionNumber: (positionNumber + 1) % 8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: ringNumber, positionNumber: (8+positionNumber - 1) % 8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: ringNumber + 1, positionNumber: positionNumber)
                case 1:
                    return checkIfGivenPositionIsAvailable(ringNumber: ringNumber, positionNumber: (positionNumber + 1) % 8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: ringNumber, positionNumber: (8+positionNumber - 1) % 8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: ringNumber + 1, positionNumber: positionNumber) ||
                        checkIfGivenPositionIsAvailable(ringNumber: ringNumber - 1, positionNumber: positionNumber)
                case 2: 
                    return checkIfGivenPositionIsAvailable(ringNumber: ringNumber, positionNumber: (8+positionNumber - 1)%8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: ringNumber, positionNumber: (positionNumber + 1)%8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: ringNumber - 1, positionNumber: positionNumber)
                default:
                    return false
            }
        }
        else {
            return checkIfGivenPositionIsAvailable(ringNumber: ringNumber, positionNumber: (8+positionNumber - 1) % 8) ||
                checkIfGivenPositionIsAvailable(ringNumber: ringNumber, positionNumber: (8+positionNumber + 1) % 8)
        }
    }

    func checkIfPlayerCanMovePool(player: Player) -> Bool {
        let colorOfPool = player.colorOfPools
        for (index1, element) in board.enumerated() {
            for (index2, value) in element.enumerated() {
                if value == colorOfPool.rawValue {
                    if checkAvailableNeighbours(ringNumber:index1 , positionNumber: index2) {
                        return true
                    }
                }
            }
        }
        return false
    }

    func checkEqualColors(color: Colors, leftPos: Int, rightPos: Int) -> Bool {
        if color.rawValue == board[leftPos][rightPos] {
            return true
        } else {
            return false
        }
    }

    func checkNineMensMorris(player: Player, ringNumber: Int, positionNumber: Int) -> Bool {
        let colorOfPool = player.colorOfPools
        if positionNumber % 2 == 0 {
            return (checkEqualColors(color: colorOfPool, leftPos: ringNumber, rightPos: (positionNumber + 1) % 8) && 
                checkEqualColors(color: colorOfPool, leftPos: ringNumber, rightPos: (8 + positionNumber - 1) % 8)) ||
                (checkEqualColors(color: colorOfPool, leftPos: (ringNumber + 1) % 3, rightPos: positionNumber) && 
                checkEqualColors(color: colorOfPool, leftPos: (ringNumber + 2) % 3, rightPos: positionNumber))
        } else {
            return (checkEqualColors(color: colorOfPool, leftPos: ringNumber, rightPos: (positionNumber + 1) % 8) && 
                checkEqualColors(color: colorOfPool, leftPos: ringNumber, rightPos: (positionNumber + 2) % 8)) ||
                (checkEqualColors(color: colorOfPool, leftPos: ringNumber, rightPos: (8 + positionNumber - 1) % 8) && 
                checkEqualColors(color: colorOfPool, leftPos: ringNumber, rightPos: (8 + positionNumber - 2) % 8))
        }
    }


    func checkRightMovement(fromRing: Int, fromPos: Int, toRing: Int, toPos: Int) -> Bool {
        if fromRing == toRing && ((fromPos + 1) % 8 == toPos || (toPos + 1) % 8 == fromPos) {
            return true
        }
        if fromPos == toPos && fromPos % 2 == 0 && (fromRing == toRing + 1 || toRing == fromRing + 1) {
            return true
        }
        return false
    }


    func executeMovement(colorOfPlayer: String, fromRingNumber: Int, fromPositionNumber: Int, toRingNumber: Int, toPositionNumber: Int,fly: Bool) -> Bool {
        var v = Visualisation(fields: board)
        if board[toRingNumber][toPositionNumber] == "·" && board[fromRingNumber][fromPositionNumber] == colorOfPlayer {
            if fly || checkRightMovement(fromRing: fromRingNumber, fromPos: fromPositionNumber, toRing: toRingNumber, toPos: toPositionNumber) {
                board[toRingNumber][toPositionNumber] = board[fromRingNumber][fromPositionNumber]
                board[fromRingNumber][fromPositionNumber] = "·"
                v = Visualisation(fields: board)
                v.printBoard()
                return true
            }
            else {
                print("Cannot move pool! ")
                return false
            }
        }
        else {
            print("Cannot move pool! ")
            return false
        }
    }

    func executePlacement(player: Player, ringNumber: Int, positionNumber: Int) -> Bool {
        let colorOfPlayer = player.colorOfPools.rawValue
        if board[ringNumber][positionNumber] == "·" {
            board[ringNumber][positionNumber] = colorOfPlayer
            let v = Visualisation(fields: board)
            v.printBoard()
            return true
        }
        else {
            print("Position already taken! ")
            return false
        }
        
    }

    func checkCoordinates(coordinates:String) -> Bool {
        if validCoordinates.contains(coordinates) {
            return true
        }
        else {
            return false
        }
    }

    func takePool(player: Player, ringNumber: Int, positionNumber: Int){
        board[ringNumber][positionNumber] = "·"
        player.poolsOnBoard = player.poolsOnBoard - 1
        let v = Visualisation(fields: board)
        v.printBoard()
    }

    func convertStringToInt(str: Character) -> Int {
        return Int(String(str))!
    }

    func toCoordinates(given:String) -> (Int,Int) {
        let stringArr = Array(given)
        let x = String(stringArr[0]).unicodeScalars.map { $0.value }.reduce(0, +) - "A".unicodeScalars.map { $0.value }.reduce(0, +) + 1
        let y = String(stringArr[1]).unicodeScalars.map { $0.value }.reduce(0, +) - "1".unicodeScalars.map { $0.value }.reduce(0, +) + 1
        let ring = getRing(Int(x), Int(y))
        let position = getPosition(Int(x), Int(y))
        return (ring,position)
    }


    func getRing(_ x: Int, _ y: Int) -> Int {
        if x==1 || x==7 || y == 1 || y == 7{
            return 0
        }
        else if x==2 || x==6 || y == 2 || y == 6{
            return 1
        }
        else if x==3 || x==5 || y == 3 || y == 5{
            return 2
        }
        return 10
    }


    func getPosition(_ x: Int, _ y: Int)->Int{
        let a = possiblePositionsForX(x)
        let b = possiblePositionsForY(y)
        let c = intersection(a,b)
        return c
    }

    func possiblePositionsForX(_ x: Int) -> [Int]   {
        if x == 1 || x == 2 || x == 3{
            return [5, 6, 7]
        }  else if x == 4 {
            return [0, 4]
        }else {
            return [1,2,3]
        }
    }


    func possiblePositionsForY(_ y: Int) -> [Int] {
        if y == 1 || y == 2 || y == 3{
            return [0, 1, 7]
        } else if y == 4 {
            return [2, 6]
        } else {
            return [3,4,5]
        }
    }


    func intersection(_ a: [Int], _ b: [Int]) -> Int {
        for el1 in a {
            for el2 in b {
                if el1 == el2 {
                    return el1
                }
            }
        }
        return 0
    }

}