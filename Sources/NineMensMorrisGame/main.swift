var a = Array(repeating:  Array(repeating: "·", count: 8), count: 3)

for array in a {
    for value in array {
        print(value, terminator: " ")
    }
    print(" ")
}