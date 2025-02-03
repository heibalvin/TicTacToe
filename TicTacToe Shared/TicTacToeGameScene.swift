//
//  TicTacToeGameScene.swift
//  TicTacToe
//
//  Created by heibalvin on 03/02/2025.
//

import SpriteKit

enum TicTacToeType: Character {
    case o      = "O"
    case x      = "X"
    
    func next() -> TicTacToeType {
        if self == .o {
            return TicTacToeType.x
        } else {
            return TicTacToeType.o
        }
    }
}

class TicTacToeGameScene: SKScene {
    var cells: [[Character]] = []
    var turn: TicTacToeType = .o
    var message: SKLabelNode!
    
    class func newGameScene() -> TicTacToeGameScene {
        let scene = TicTacToeGameScene(size: CGSize(width: 300, height: 300))
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .white
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        reset()
    }
    
    func reset() {
        // cleanup the scene
        removeAllChildren()
        
        // table of 3 rows x 3 cols Character filled with nothing
        cells = Array(repeating: Array(repeating: " ", count: 3), count: 3)
        
        // add background board
        let board = SKTexture(imageNamed: "tictactoe-board")
        let boardNode = SKSpriteNode(texture: board)
        boardNode.name = "board"
        boardNode.zPosition = -10
        boardNode.position = CGPoint(x: 150, y: 150)
        addChild(boardNode)
        
        // Add message
        message = SKLabelNode(text: "")
        message.fontName = "Chalkduster"
        message.fontSize = 24
        message.fontColor = .black
        message.zPosition = 10
        message.position = CGPoint(x: 150, y: 150)
        message.isHidden = true
        addChild(message)
    }
    
    func add(col: Int, row: Int, type: TicTacToeType) {
        let tex = SKTexture(imageNamed: "tictactoe-\(type)")
        let node = SKSpriteNode(texture: tex)
        node.name = "\(type)"
        node.position = CGPoint(x: col * 100 + 50, y: row * 100 + 50)
        addChild(node)
    }
    
    func inputEvent(position: CGPoint) {
        if (message.isHidden == false) {
            reset()
            return
        }
        
        let col = Int(position.x / 100)
        let row = Int(position.y / 100)
        
        if cells[row][col] == " " {
            add(col: col, row: row, type: turn)
            cells[row][col] = turn.rawValue
            
            if hasWon(type: turn) {
                message.text = "\(turn.rawValue) has Won"
                message.isHidden = false
            } else if isDraw() {
                message.text = "It is a Draw"
                message.isHidden = false
            }
            
            turn = turn.next()
        }
    }
    
    func hasWon(type: TicTacToeType) -> Bool {
        // horizontal test
        for row in 0...2 {
            if (cells[row][0] == type.rawValue) && (cells[row][1] == type.rawValue) && (cells[row][2] == type.rawValue) {
                return true
            }
        }
        
        // vertical test
        for col in 0...2 {
            if (cells[0][col] == type.rawValue) && (cells[1][col] == type.rawValue) && (cells[2][col] == type.rawValue) {
                return true
            }
        }
        
        // diagonal test
        if (cells[0][0] == type.rawValue) && (cells[1][1] == type.rawValue) && (cells[2][2] == type.rawValue) {
            return true
        }
        if (cells[0][2] == type.rawValue) && (cells[1][1] == type.rawValue) && (cells[2][0] == type.rawValue) {
            return true
        }
        
        return false
    }
    
    func isDraw() -> Bool {
        for row in 0...2 {
            for col in 0...2 {
                if cells[row][col] == " " {
                    return false
                }
            }
        }
        return true
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension TicTacToeGameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        inputEvent(position: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension TicTacToeGameScene {

    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        inputEvent(position: location)
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }

}
#endif

