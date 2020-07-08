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
        let curPosLeft = ringNumber
        let curPosRight = positionNumber

        if curPosRight % 2 == 0 {
            switch curPosLeft {
                case 0: 
                    return checkIfGivenPositionIsAvailable(ringNumber: curPosLeft, positionNumber: (curPosRight + 1) % 8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: curPosLeft, positionNumber: (8+curPosRight - 1) % 8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: curPosLeft + 1, positionNumber: curPosRight)
                case 1:
                    return checkIfGivenPositionIsAvailable(ringNumber: curPosLeft, positionNumber: (curPosRight + 1) % 8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: curPosLeft, positionNumber: (8+curPosRight - 1) % 8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: curPosLeft + 1, positionNumber: curPosRight) ||
                        checkIfGivenPositionIsAvailable(ringNumber: curPosLeft - 1, positionNumber: curPosRight)
                case 2: 
                    return checkIfGivenPositionIsAvailable(ringNumber: curPosLeft, positionNumber: (8+curPosRight - 1)%8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: curPosLeft, positionNumber: (curPosRight + 1)%8) ||
                        checkIfGivenPositionIsAvailable(ringNumber: curPosLeft - 1, positionNumber: curPosRight)
                default:
                    return false
            }
        }
        else {
            return checkIfGivenPositionIsAvailable(ringNumber: curPosLeft, positionNumber: (8+curPosRight - 1) % 8) ||
                checkIfGivenPositionIsAvailable(ringNumber: curPosLeft, positionNumber: (8+curPosRight + 1) % 8)
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
        let curPosLeft = ringNumber
        let curPosRight = positionNumber

        if curPosRight % 2 == 0 {
            return (checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (curPosRight + 1) % 8) && 
                checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (8 + curPosRight - 1) % 8)) ||
                (checkEqualColors(color: colorOfPool, leftPos: (curPosLeft + 1) % 3, rightPos: curPosRight) && 
                checkEqualColors(color: colorOfPool, leftPos: (curPosLeft + 2) % 3, rightPos: curPosRight))
        } else {
            return (checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (curPosRight + 1) % 8) && 
                checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (curPosRight + 2) % 8)) ||
                (checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (8 + curPosRight - 1) % 8) && 
                checkEqualColors(color: colorOfPool, leftPos: curPosLeft, rightPos: (8 + curPosRight - 2) % 8))
        }
        
    }

    func executeMovement(fromRingNumber: Int, fromPositionNumber: Int, toRingNumber: Int, toPositionNumber: Int) -> Bool {
        let fromPosLeft = fromRingNumber
        let fromPosRight = fromPositionNumber

        let toPosLeft = toRingNumber
        let toPosRight = toPositionNumber

        if board[fromPosLeft][fromPosRight] != "·" && board[toPosLeft][toPosRight] == "·" {
            board[toPosLeft][toPosRight] = board[fromPosLeft][fromPosRight]
            board[fromPosLeft][fromPosRight] = "·"
            return true
        }
        else {
            print("Position already taken! ")
            return false
        }
    }

    func executePlacement(player: Player, ringNumber: Int, positionNumber: Int) -> Bool {
        let colorOfPlayer = player.colorOfPools.rawValue
        let posLeft = ringNumber
        let posRight = positionNumber
        if board[posLeft][posRight] == "·" {
            board[posLeft][posRight] = colorOfPlayer
            print("color: " + colorOfPlayer)
            print("////")
            print("on pos: " + board[posLeft][posRight])
            print("////////////////")
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

    func takePool(player: Player, ringNumber: Int, positionNumber: Int) {
        let posLeft = ringNumber
        let posRight = positionNumber
        board[posLeft][posRight] = "·"
        player.poolsOnBoard = player.poolsOnBoard - 1
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