class Game {

    var firstPlayer:Player
    var secondPlayer:Player
    var board:Board

    public static func pickPools() -> Colors {
        print("Pick your pools: 1: ○ ; 2: ● ")
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
        //self.secondPlayer = Player(color:color)
        if color == Colors.white {
            self.secondPlayer = Player(color:Colors.black)
        }
        else {
            self.secondPlayer = Player(color:Colors.white)
        }

        self.board = Board()
    }

    
    func makeSinglePlacement(player: Player, ringNumber: inout Int, positionNumber: inout Int, b: inout [[String]]) {
       let input = player.readCoordinates()
       var (ring, num) = board.toCoordinates(given: input)
       if board.executePlacement(player: player,ringNumber: ring, positionNumber: num, b: &b) {
           player.poolsOnBoard = player.poolsOnBoard + 1
           player.poolsInHand = player.poolsInHand - 1
           ringNumber = ring
           positionNumber = num
       }
       else {
           makeSinglePlacement(player: player, ringNumber: &ring, positionNumber: &num, b: &b)
       }
    }


    func placeAllPoolsOnBoardHelper(firstPlayer: Player, secondPlayer: Player, ringNumber:inout Int, positionNumber: inout Int, b: inout [[String]]) {
        makeSinglePlacement(player: firstPlayer, ringNumber: &ringNumber, positionNumber: &positionNumber, b: &b)
            if firstPlayer.poolsOnBoard >= 3 {
                if board.checkNineMensMorris(player: firstPlayer, ringNumber: ringNumber, positionNumber: positionNumber) {
                    print("Nine Men's Morris Found! ")
                    
                    let toRemove = firstPlayer.readCoordinatesToRemovePools()  // тук трябва да стоят координати за премахване 
                                                                   // и да се проверява какви пулове има противника (може да има само дами)
                    let (ring, num) = board.toCoordinates(given: toRemove)
                    board.takePool(player: secondPlayer, ringNumber: ring, positionNumber: num,b: &b)
                }
            }
    }


    func placeAllPoolsOnBoard(firstPlayer: Player, secondPlayer: Player, b:inout [[String]]) {
        while (firstPlayer.poolsInHand > 0 || secondPlayer.poolsInHand > 0) {
            var ringNumber1 = 0, positionNumber1 = 0, ringNumber2 = 0, positionNumber2 = 0
            placeAllPoolsOnBoardHelper(firstPlayer: firstPlayer, secondPlayer: secondPlayer, ringNumber: &ringNumber1, positionNumber: &positionNumber1, b: &b)
            placeAllPoolsOnBoardHelper(firstPlayer: secondPlayer, secondPlayer: firstPlayer, ringNumber: &ringNumber2, positionNumber: &positionNumber2, b: &b)
        }
        if firstPlayer.poolsInHand == 0 && secondPlayer.poolsInHand == 0 {
            print("You are now allowed to move pools! ")  

        }
    }


    func makeSingleMovement(player: Player, fromRingNum: inout Int, fromPosNum: inout Int, toRingNum: inout Int, toPosNum: inout Int) {
        let input = player.readMovement()    
       // let arrInput = Array(input)
       var (fromRing, fromPos) = board.toCoordinates(given: input)
       var (toRing, toPos) = board.toCoordinates(given: input)
       if board.executeMovement(fromRingNumber: fromRing, fromPositionNumber: fromPos, toRingNumber: toRing, toPositionNumber: toPos) {
           fromRingNum = fromRing
           fromPosNum = fromPos
           toRingNum = toRing
           toPosNum = toPos
       }
       else {
           makeSingleMovement(player: player, fromRingNum: &fromRing, fromPosNum: &fromPos, toRingNum: &toRing, toPosNum: &toPos)
       }
    }


    func removePools(firstPlayer: Player, secondPlayer: Player, endGame: inout Bool, b: inout [[String]]) {
        let toRemove = firstPlayer.readCoordinatesToRemovePools()  // тук трябва да стоят координати за премахване 
                                                                   // и да се проверява какви пулове има противника (може да има само дами)
        let (ring, num) = board.toCoordinates(given: toRemove)
        board.takePool(player: secondPlayer, ringNumber: ring, positionNumber: num, b: &b)
        if secondPlayer.poolsOnBoard == 2 {
            print("\(secondPlayer.name) lost the game! ")   
            endGame = true
        }
        if secondPlayer.poolsOnBoard == 3 { 
            print("\(secondPlayer.name) can now fly! ")     
        }
    }


    func makeMovementsHelper(firstPlayer: Player, secondPlayer: Player, fromRingNum:inout Int, fromPosNum:inout Int, toRingNum:inout Int, toPosNum:inout Int, endGame:inout Bool, b: inout [[String]]) {
        if board.checkIfPlayerCanMovePool(player: firstPlayer) {
            let firstPlayerInput = firstPlayer.readMovement()
            var (fromRing, fromNum) = board.toCoordinates(given: firstPlayerInput)  
            var (toRing, toNum) = board.toCoordinates(given: firstPlayerInput)
            makeSingleMovement(player: firstPlayer, fromRingNum: &fromRing, fromPosNum: &fromNum, toRingNum: &toRing, toPosNum: &toNum)
            if firstPlayer.poolsOnBoard >= 3 {
            if board.checkNineMensMorris(player: firstPlayer, ringNumber: toRing, positionNumber: toNum) {
                removePools(firstPlayer: firstPlayer, secondPlayer: secondPlayer, endGame: &endGame, b: &b)
                }
            }
        }
        else {
            endGame = true
        }
    }


    func makeMovements(firstPlayer: Player, secondPlayer: Player, endGame:inout Bool,b: inout [[String]]){
        var endGame = false 
        var fromRing1 = 0, fromPos1 = 0, toRing1 = 0, toPos1 = 0
        var fromRing2 = 0, fromPos2 = 0, toRing2 = 0, toPos2 = 0
        while endGame == false {
            makeMovementsHelper(firstPlayer: firstPlayer, secondPlayer: secondPlayer, fromRingNum: &fromRing1, fromPosNum: &fromPos1, toRingNum: &toRing1, toPosNum: &toPos1, endGame: &endGame, b: &b)
            if endGame == false {
                makeMovementsHelper(firstPlayer: secondPlayer, secondPlayer: firstPlayer, fromRingNum: &fromRing2, fromPosNum: &fromPos2, toRingNum: &toRing2, toPosNum: &toPos2, endGame: &endGame, b: &b)
            }
        }
    }
}


///МЕСТЕНЕ НА ПУЛ
// 1) Преди всяко местене се проверява дали играча може да мести, ако не може ГУБИ (тук може да се проверва само, ако пуловете са > 3)
// 2) След всяко местене се проверява за:  дама   
//                                       (ако има дама трябва да се проверява какви пулове има противника, 
//                                         ако има САМО дами, тогава се премахва пул от дама)


// ПРЕМАХВАНЕ НА ПУЛ
// След всяко премахване на пул трябва да се проверява: 1) дали на играча не са останали само 2 пула, тогава ГУБИ играта
//                                                       2) дали играча е останал само с 3 пула, за може да лети,
//                                                           ако може да лети не е нужно да се проверяват съседите


// ПРИНТИРАНЕ
//    1) В началото на играта 
//    2) След всеки изигран ход



