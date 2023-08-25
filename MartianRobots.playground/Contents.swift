import Foundation

class Robot {
    var x: Int
    var y: Int
    var orientation: Orientation
    init(x: Int, y: Int, orientation: Orientation) {
        self.x = x
        self.y = y
        self.orientation = orientation
    }
    func printLocation () {
        print(x, y, orientation)
    }
    func right() {
        switch (orientation) {
        case .north:
            orientation = .east
        case .south:
            orientation = .west
        case .west:
            orientation = .north
        case .east:
            orientation = .south
        case .none:
            break
        }
    }
    func left() {
        switch (orientation) {
        case .north:
            orientation = .west
        case .south:
            orientation = .east
        case .west:
            orientation = .south
        case .east:
            orientation = .north
        case .none:
            break
        }
    }
    func forward() {
        switch (orientation) {
        case .north:
            y = y+1
        case .south:
            y = y-1
        case .west:
            x = x-1
        case .east:
            x = x+1
        case .none:
            break
        }
    }
}

enum Orientation {
    case north
    case south
    case east
    case west
    case none
}

let input = "5 3\n0 3 W\nLLFFF L F LFL"

func ProcessInput(input: String) {
    var seperateInput = input.components(separatedBy: "\n")
    var initPosition = seperateInput[1].components(separatedBy: " ")
    var initX = Int(initPosition[0])!
    var initY = Int(initPosition[1])!
    var initOrientation: Orientation
    switch (initPosition[2]) {
    case "N":
        initOrientation = .north
    case "S":
        initOrientation = .south
    case "E":
        initOrientation = .east
    case "W":
        initOrientation = .west
    default:
        initOrientation = .none
    }

    var robot = Robot(x: initX, y: initY, orientation: initOrientation)

    var instructions = seperateInput[2].components(separatedBy: " ")
    var instruct2 = Array(instructions[0])

    for instruction in instruct2 {
        switch(instruction) {
        case "R":
            robot.right()
        case "L":
            robot.left()
        case "F":
            robot.forward()
        default:
            break
        }
        robot.printLocation()
    }

    robot.printLocation()
}

ProcessInput(input: input)
