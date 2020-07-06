class Game {

    var firstPlayer:Player
    var secondPlayer:Player
    var board:Board

    public func pickPools() -> Colors {
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
        let color:Colors = pickPools()
        self.firstPlayer = Player(color: color)
        self.secondPlayer = Player(color:color)
        if color == Colors.white {
            self.secondPlayer = Player(color:Colors.black)
        }
        else {
            self.secondPlayer = Player(color:Colors.white)
        }

        self.board = Board()
    }

    
    func makeSinglePlacement(player: Player, ringNumber: inout Int, positionNumber: inout Int) {
       var input = player.readCoordinates()
       let (ring, num) = board.toCoordinates(given: input)
       if board.executeMove(player: player,ringNumber: ring, positionNumber: num) {
           player.poolsOnBoard = player.poolsOnBoard + 1
           player.poolsInHand = player.poolsInHand - 1
           ringNumber = ring
           positionNumber = num
       }
       else {
           input = player.readCoordinates()
       }
    }

    func placeAllPoolsOnBoard(firstPlayer: Player) {
        while (firstPlayer.poolsInHand > 0 || secondPlayer.poolsInHand > 0) {
            var num = 0
            makeSinglePlacement(player: firstPlayer, ringNumber: &num, positionNumber: &num)
            makeSinglePlacement(player: secondPlayer, ringNumber: &num, positionNumber: &num)
            if firstPlayer.poolsOnBoard >= 3 {
                if board.checkNineMensMorris(player: firstPlayer, ringNumber: num, positionNumber: num) {
                    let toRemove = firstPlayer.readCoordinates()  // тук трябва да стоят координати за премахване 
                                                                   // и да се проверява какви пулове има противника (може да има само дами)
                    let (ring, num) = board.toCoordinates(given: toRemove)
                    board.takePool(player: secondPlayer, ringNumber: ring, positionNumber: num)
                }
            }
            else if secondPlayer.poolsOnBoard >= 3 {
                if board.checkNineMensMorris(player: secondPlayer, ringNumber: num, positionNumber: num) {
                    let toRemove = secondPlayer.readCoordinates()  // тук трябва да стоят координати за премахване
                                                                    // и да се проверява какви пулове има противника (може да има само дами)
                    let (ring, num) = board.toCoordinates(given: toRemove)
                    board.takePool(player: firstPlayer, ringNumber: ring, positionNumber: num)
                }
            }
        }
        if firstPlayer.poolsInHand == 0 && secondPlayer.poolsInHand == 0{
            print("You are now allowed to move pools! ")
        }
    }
}


///МЕСТЕНЕ НА ПУЛ
// 1) Преди всяко местене се проверява дали играча може да мести, ако не може ГУБИ
// 2) При всяко местене се проверява за:  дама   
//                                       (ако има дама трябва да се проверява какви пулове има противника, 
//                                         ако има САМО дами, тогава се премахва пул от дама)


// ПРЕМАХВАНЕ НА ПУЛ
// След всяко премахване на пул трябва да се проверява: 1) дали на играча не са останали само 2 пула, тогава ГУБИ играта
//                                                       2) дали играча е останал само с 3 пула, за може да лети


// ПРИНТИРАНЕ
//    1) В началото на играта 
//    2) След всеки изигран ход



