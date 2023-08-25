import Foundation

struct Position : Comparable {
    var x: Int
    var y: Int

    static func < (lhs: Position, rhs: Position) -> Bool {
        if lhs.x < rhs.x || lhs.y < rhs.y {
            return true
        }
        return false
    }

    static func > (lhs: Position, rhs: Position) -> Bool {
        if lhs.x > rhs.x || lhs.y > rhs.y {
            return true
        }
        return false
    }
}

enum Orientation: Character {
    case north = "N"
    case south = "S"
    case east  = "E"
    case west  = "W"
}

class Robot {
    var position: Position
    var orientation: Orientation
    var isLost = false

    init(position: Position, orientation: Orientation) {
        self.position = position
        self.orientation = orientation
    }

    func printPose() {
        if isLost {
            print(position.x, position.y, orientation.rawValue, "LOST", separator: "")
        } else {
            print(position.x, position.y, orientation.rawValue, separator: "")
        }
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
        }
    }

    func forward() {
        switch (orientation) {
        case .north:
            position.y+=1
        case .south:
            position.y-=1
        case .east:
            position.x+=1
        case .west:
            position.x-=1
        }
    }
}

let input = """
53
11E RFRFRFRF
32N FRRFLLFFRRFLL
03W LLFFFLFLFL
"""

func traverse(input: String) {
    let lines = input.components(separatedBy: "\n")
    let boundsInput = Array(lines[0])
    let robotsInput = lines.dropFirst()
    guard let boundX = boundsInput[0].wholeNumberValue, let boundY = boundsInput[1].wholeNumberValue else { return }
    let bounds = Position(x: boundX, y: boundY)
    var lostPositions:[Position] = []

    for robotInput in robotsInput {
        let components = robotInput.components(separatedBy: " ")
        let poseInput = Array(components[0])
        let instructionInput = components[1]
        guard let initX = poseInput[0].wholeNumberValue, let initY = poseInput[1].wholeNumberValue else { return }
        let initPosition = Position(x: initX, y: initY)
        let initOrientation: Orientation?
        switch (poseInput[2]) {
        case "N":
            initOrientation = .north
        case "S":
            initOrientation = .south
        case "E":
            initOrientation = .east
        case "W":
            initOrientation = .west
        default:
            initOrientation = nil
        }
        guard let initOrientation else { return }

        var robot = Robot(position: initPosition, orientation: initOrientation)

        for instruction in instructionInput {
            let backupPosition = robot.position
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
            if robot.position > bounds {
                robot.position = backupPosition
                if !lostPositions.contains(backupPosition) {
                    lostPositions.append(backupPosition)
                    robot.isLost = true
                    break
                }
            }
        }

        robot.printPose()
    }
}

traverse(input: input)
