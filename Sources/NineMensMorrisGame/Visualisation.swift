class Visualisation {

    var fields: [[String]]

    public init(fields: [[String]]) {
        self.fields = fields
    }

}

extension Visualisation {
    func printDotsAndDashes(line: Int, values: [String]) -> String {
        var result = ""
        result += values[0]
        let numberDashes = (22 - (line*8))/2
        for _ in 1...numberDashes {
            result += "-"
        }
        result += values[1]
        for _ in 1...numberDashes {
            result += "-"
        }
        result += values[2]
        return result
    }

    func printOddLines(line: Int) {
        var result = ""
        var index = 0
        var values: [String] = []
        if line > 7 {
            index = (15 - line) / 2 - 1
            values.append(fields[index][5])
            values.append(fields[index][4])
            values.append(fields[index][3])
        }
        else {
            index = line / 2
            values.append(fields[index][7])
            values.append(fields[index][0])
            values.append(fields[index][1])
        }
        if index > 0 {
            for _ in 0...index - 1  {
            result += "|   "
            }
        } 
        result += printDotsAndDashes(line: index, values: values )
        if index > 0 {
            for _ in 0...index - 1  {
                result += "   |"
            }
        }
        print(result)
    }
}

extension Visualisation {
    func printDashesAndSpaces(dashPlace: Bool, numberSpaces: Int) -> String {
        var result = ""
        if dashPlace {
            result += "|"
            for _ in 1...numberSpaces {
                result += " "
            }
        }
        else {
            for _ in 1...numberSpaces {
                result += " "
            }
            result += "|"
        }
        return result
   }


    func printEvenLines(line: Int) {
        var res = ""
        switch line {
            case 1: 
                res += printDashesAndSpaces(dashPlace: true, numberSpaces: 11)
                res += "|"
                res += printDashesAndSpaces(dashPlace: false, numberSpaces: 11)
            case 2:
                res += printDashesAndSpaces(dashPlace: true, numberSpaces: 3)
                res += printDashesAndSpaces(dashPlace: true, numberSpaces: 7)
                res += "|"
                res += printDashesAndSpaces(dashPlace: false, numberSpaces: 7)
                res += printDashesAndSpaces(dashPlace: false, numberSpaces: 3)
            case 3:
                res += printDashesAndSpaces(dashPlace: true, numberSpaces: 3)
                res += printDashesAndSpaces(dashPlace: true, numberSpaces: 3)
                res += printDashesAndSpaces(dashPlace: true, numberSpaces: 3)
                res += " "
                res += printDashesAndSpaces(dashPlace: false, numberSpaces: 3)
                res += printDashesAndSpaces(dashPlace: false, numberSpaces: 3)
                res += printDashesAndSpaces(dashPlace: false, numberSpaces: 3)
            default: 
                print("")
        }
        print(res)
    }
}

extension Visualisation {

    public func printBoard() {
        for i in 1...13 {
            if i < 7 {
                if i % 2 == 0 {
                    printEvenLines(line: i / 2)
                }   
                else {
                    printOddLines(line: i)
                }
            }
            else if i == 7 {
                var result = ""
                var values = [fields[0][6], fields[1][6], fields[2][6]]
                result += printDotsAndDashes(line: 2, values: values)
                result += "       "
                values.removeAll() 
                values = [fields[2][2], fields[1][2], fields[0][2]]
                result += printDotsAndDashes(line: 2, values: values)
                print(result)
            }
            else {
                if i % 2 == 0 {
                    printEvenLines(line: (14 - i) / 2)
                }
                else {
                    printOddLines(line: i)
                }
            }
        }
    }

}
