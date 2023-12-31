import Foundation

struct Position: Comparable {
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

    var left: Orientation {
        switch self {
        case .north: return .west
        case .east:  return .north
        case .south: return .east
        case .west:  return .south
        }
    }

    var right: Orientation {
        switch self {
        case .north: return .east
        case .east:  return .south
        case .south: return .west
        case .west:  return .north
        }
    }
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

    func left() {
        orientation = orientation.left
    }

    func right() {
        orientation = orientation.right
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

// This function parses a pose from a string and returns a tuple of Position and Orientation(optional)
func parsePose(from string: String) -> (Position, Orientation)? {
    let poseInput = Array(string)
    guard let initX = poseInput[0].wholeNumberValue, let initY = poseInput[1].wholeNumberValue else { return nil }
    let initPosition = Position(x: initX, y: initY)

    let initOrientation: Orientation
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
        return nil
    }

    return (initPosition, initOrientation)
}

/* This function executes instructions for a robot. For each instruction, the new position is checked against the bounds. If the position exceeds the bounds and has not been marked by a lost robot before, the robot is now lost aborting execution. The robot's position is rolled back and it's location marked for future robots. If the position exceeds the bounds and has been marked before, the robot's position rolled back and execution continues.
*/
func executeInstructions(_ instructions: [Character], for robot: Robot, bounds: Position, lostPositions: inout [Position]) {
    for instruction in instructions {
        let backupPosition = robot.position
        switch(instruction) {
        case "R":
            robot.right()
        case "L":
            robot.left()
        case "F":
            robot.forward()
        default:
            continue
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
}

/* This function accepts an input string, parses it, and sequentially executes instructions for each robot. After executing the instructions for a robot, it's final pose is printed. The string has information for the upper right coordinates of the rectangular world the robot is in and sets of initial poses for different robots and their movement instructions.
*/
func process(input: String) {
    let lines = input.components(separatedBy: "\n")
    let boundsInput = Array(lines[0])
    let robotsInput = lines.dropFirst()

    guard let boundX = boundsInput[0].wholeNumberValue, let boundY = boundsInput[1].wholeNumberValue else { return }
    let bounds = Position(x: boundX, y: boundY)
    var lostPositions:[Position] = []

    for robotInput in robotsInput {
        let components = robotInput.components(separatedBy: " ")
        guard let (initialPosition, initialOrientation) = parsePose(from: components[0]) else { return }
        let instructions = Array(components[1])

        let robot = Robot(position: initialPosition, orientation: initialOrientation)
        executeInstructions(instructions, for: robot, bounds: bounds, lostPositions: &lostPositions)
        robot.printPose()
    }
}

// Sample input
let input = """
53
11E RFRFRFRF
32N FRRFLLFFRRFLL
03W LLFFFLFLFL
"""

process(input: input)
