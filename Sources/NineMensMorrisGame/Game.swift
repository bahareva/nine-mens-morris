class Game {

    var firstPlayer:Player
    var secondPlayer:Player
    var board:Board
    var endGame:Bool

    public static func pickPools() -> Colors {
        print("Pick your pools: 1 -> ○ or 2 -> ●\nEnter the number of the chosen color: ")
        if let input = readLine() {
            if let res = Int(input) {
                if res == 1 {
                 return Colors.white
                }
                else if res == 2 {
                    return Colors.black
                }
            else {
                print("Invalid input. Try again. ")
                return pickPools()
                }
            }
        else {
            print("Invalid input. Try again. ")
            return pickPools()
            }
        }
    return Colors.black
    }


    init() {
        let color:Colors = Game.pickPools()
        self.firstPlayer = Player(color: color)
        if color == Colors.white {
            self.secondPlayer = Player(color:Colors.black)
        }
        else {
            self.secondPlayer = Player(color:Colors.white)
        }
        self.board = Board()
        self.endGame = false
    }

    
    func makeSinglePlacement(player: Player, ringNumber: inout Int, positionNumber: inout Int) {
       let input = player.readCoordinates()
       let (ring, num) = board.toCoordinates(given: input)
       if board.executePlacement(player: player,ringNumber: ring, positionNumber: num) {
           player.poolsOnBoard = player.poolsOnBoard + 1
           player.poolsInHand = player.poolsInHand - 1
           ringNumber = ring
           positionNumber = num
       }
       else {
           makeSinglePlacement(player: player, ringNumber: &ringNumber, positionNumber: &positionNumber)
       }
    }


    func placeAllPoolsOnBoard() {
        while (firstPlayer.poolsInHand > 0 || secondPlayer.poolsInHand > 0) {
            var ringNumber1 = 0, positionNumber1 = 0, ringNumber2 = 0, positionNumber2 = 0
            print("It is \(firstPlayer.name)'s turn! ")
            makeSinglePlacement(player: firstPlayer, ringNumber: &ringNumber1, positionNumber: &positionNumber1)
            removeIfNineMensMorris(firstPlayer: firstPlayer, secondPlayer: secondPlayer, toRingNum: &ringNumber1, toPosNum: &positionNumber1)
            print("It is \(secondPlayer.name)'s turn! ")
            makeSinglePlacement(player: secondPlayer, ringNumber: &ringNumber2, positionNumber: &positionNumber2)
            removeIfNineMensMorris(firstPlayer: secondPlayer, secondPlayer: firstPlayer, toRingNum: &ringNumber2, toPosNum: &positionNumber2)
        }
        if firstPlayer.startMovement && secondPlayer.startMovement {
            print("You are now allowed to move pools! ")  
        }
    }


    func makeSingleMovement(player: Player, fromRingNum: inout Int, fromPosNum: inout Int, toRingNum: inout Int, toPosNum: inout Int){
        let input = player.readMovement()    
        let (firstPart, secondPart) = input.divideInTwo()
        let (fromRing, fromPos) = board.toCoordinates(given: player.fromCharArrayToString(arr: firstPart))
        let (toRing, toPos) = board.toCoordinates(given: player.fromCharArrayToString(arr: secondPart))
        if board.executeMovement(colorOfPlayer:player.colorOfPools.rawValue ,fromRingNumber: fromRing, fromPositionNumber: fromPos, toRingNumber: toRing, toPositionNumber: toPos, fly: player.fly) {
           fromRingNum = fromRing
           fromPosNum = fromPos
           toRingNum = toRing
           toPosNum = toPos
        }
        else {
           makeSingleMovement(player: player, fromRingNum: &fromRingNum, fromPosNum: &fromPosNum, toRingNum: &toRingNum, toPosNum: &toPosNum)
        }
    }


    func removePools(firstPlayer: Player, secondPlayer: Player) {
        let toRemove = firstPlayer.readCoordinatesToRemovePools()  
        let (ring, num) = board.toCoordinates(given: toRemove) 
        if board.checkEqualColors(color: secondPlayer.colorOfPools, leftPos: ring, rightPos: num) &&
            (!board.checkNineMensMorris(player: secondPlayer, ringNumber: ring, positionNumber: num) || board.arePoolsInNineMensMorris(player: secondPlayer)){
            board.takePool(player: secondPlayer, ringNumber: ring, positionNumber: num) 
            if secondPlayer.lost {
                print("Game over! \nThe winner is \(firstPlayer.name)!")   
                endGame = true
            }
            if secondPlayer.fly { 
                print("\(secondPlayer.name) can now fly! ")     
            }
        }
        else {
            print("Cannot take pool at this position!")
            removePools(firstPlayer: firstPlayer, secondPlayer: secondPlayer)
        }
    }


    func removeIfNineMensMorris(firstPlayer: Player, secondPlayer: Player, toRingNum:inout Int, toPosNum:inout Int) {
        if firstPlayer.poolsOnBoard >= 3 && board.checkNineMensMorris(player: firstPlayer, ringNumber: toRingNum, positionNumber: toPosNum){
            print("Nine Men's Morris Found! ")
            removePools(firstPlayer: firstPlayer, secondPlayer: secondPlayer)
        }
    }


    func isMovementAllowed(firstPlayer: Player, secondPlayer: Player, fromRingNum:inout Int, fromPosNum:inout Int, toRingNum:inout Int, toPosNum:inout Int) {
        if board.checkIfPlayerCanMovePool(player: firstPlayer) {
            makeSingleMovement(player: firstPlayer, fromRingNum: &fromRingNum, fromPosNum: &fromPosNum, toRingNum: &toRingNum, toPosNum: &toPosNum)
            removeIfNineMensMorris(firstPlayer: firstPlayer, secondPlayer: secondPlayer, toRingNum: &toRingNum, toPosNum: &toPosNum)
        }
        else {
            print("Game over! \nThe winner is \(secondPlayer.name)!") 
            endGame = true
        }
    }


    func makeMovements(){
        var fromRing1 = 0, fromPos1 = 0, toRing1 = 0, toPos1 = 0
        var fromRing2 = 0, fromPos2 = 0, toRing2 = 0, toPos2 = 0
        while endGame == false {
            print("It is \(firstPlayer.name)'s turn! ")
            isMovementAllowed(firstPlayer: firstPlayer, secondPlayer: secondPlayer, fromRingNum: &fromRing1, fromPosNum: &fromPos1, toRingNum: &toRing1, toPosNum: &toPos1)
            if endGame == false {
                print("It is \(secondPlayer.name)'s turn! ")
                isMovementAllowed(firstPlayer: secondPlayer, secondPlayer: firstPlayer, fromRingNum: &fromRing2, fromPosNum: &fromPos2, toRingNum: &toRing2, toPosNum: &toPos2)
            }
        }
    }


    public func run() {
        placeAllPoolsOnBoard()
        makeMovements()
    }
}

extension String {
    func divideInTwo() -> ([Character], [Character]) {
        let arrInput: [Character] = Array(self)
        let firstPart: [Character] = [arrInput[0],arrInput[1]]
        let secondPart: [Character] = [arrInput[2],arrInput[3]]
        return (firstPart, secondPart)
    }
}
