import SwiftUI

class ChuckViewModel: ObservableObject {
    // MARK: - Welcome
    @Published var showWelcome: Bool = false
    @Published var dateWelcome: Int = 0
    
    // MARK: - Info
    @Published var showInfo: Bool = false
    @Published var pageInfo: Int = 0
    @Published var dateInfo: Int = 0
    
    // MARK: - Menu
    @Published var dateBalance: Int = 1000
    @Published var dateLevels: [Int] = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    // MARK: - Game
    @Published var doubleStep: Bool = false
    @Published var goldenEgg: Bool = false
    @Published var isGoldenEgg: Bool = false
    @Published var showPause: Bool = false
    @Published var showGame: Bool = false
    @Published var firstWin = false
    @Published var showLose = false
    @Published var showWin = false
    @Published var showBonusWin = false
    @Published var currentLevel: Int = 0
    @Published var currentRows: Int = 0
    @Published var currentCols: Int = 0
    @Published var grid: [[Tile]] = []
    @Published var moveHistory: [[[Tile]]] = []
    @Published var wolfSkinsMapping: [UUID: String] = [:]
    let wolfSkinsByLevel: [Int: [String]] = [
        0: ["ChuckGameTileFox0"],
        1: ["ChuckGameTileFox1"],
        2: ["ChuckGameTileFox2"],
        3: ["ChuckGameTileFox3"],
        4: ["ChuckGameTileFox4"],
        5: ["ChuckGameTileFox5"],
        6: ["ChuckGameTileFox6", "ChuckGameTileFox8", "ChuckGameTileFox7"],
        7: ["ChuckGameTileFox9", "ChuckGameTileFox10"],
        8: ["ChuckGameTileFox11", "ChuckGameTileFox12"],
        9: ["ChuckGameTileFox13", "ChuckGameTileFox14", "ChuckGameTileFox15"],
    ]
    
    // MARK: - Bonus
    @Published var showBonus = false
    @Published var showPauseBonus = false
    @Published var showWinBonus = false
    @Published var showLoseBonus = false
    @Published var countOfFox = 0
    @Published var currentWin = 0
    @Published var newWin = 0
    @Published var movesLeft = 30
    @Published var matchedCount = 0
    @Published var firstSelectionIndex: Int?
    @Published var foundPairs: Set<Int> = []
    @Published var cards: [Card] = []
    
    init() {
        grid = []
        
        for index in 0...6 {
            if index == 0 {
                grid.append([Tile(row: index, col: 0, type: .empty), Tile(row: index, col: 1, type: .softGround), Tile(row: index, col: 2, type: .empty)])
            } else {
                grid.append([Tile(row: index, col: 0, type: .softGround), Tile(row: index, col: 1, type: .softGround), Tile(row: index, col: 2, type: .softGround)])
            }
        }
    }
    
    public func spawnGoldenEgg() {
        if !isGoldenEgg {
            let random = Int.random(in: 0...5)
            
            if random == 0 {
                var randomRow = Int.random(in: 0...grid.count - 1)
                var randomCol = Int.random(in: 0...grid[randomRow].count - 1)
                
                while grid[randomRow][randomCol].type != .softGround {
                    randomRow = Int.random(in: 0...grid.count - 1)
                    randomCol = Int.random(in: 0...grid[randomRow].count - 1)
                }
                
                isGoldenEgg = true
                
                withAnimation() {
                    grid[randomRow][randomCol].type = .goldenEgg
                }
            }
        } else {
            for row in 0...grid.count - 1 {
                for column in 0...grid[row].count - 1 {
                    if grid[row][column].type == .goldenEgg {
                        withAnimation() {
                            grid[row][column].type = .softGround
                        }
                    }
                }
            }
        }
    }
    
    func saveUserDefaultsChuck() {
        UserDefaults.standard.set(dateWelcome, forKey: "dateWelcome")
        UserDefaults.standard.set(dateInfo, forKey: "dateInfo")
        UserDefaults.standard.set(dateBalance, forKey: "dateBalance")
        UserDefaults.standard.set(dateLevels, forKey: "dateLevels")
    }
    
    func loadUserDefaultsChuck() {
        dateWelcome = UserDefaults.standard.integer(forKey: "dateWelcome")
        dateInfo = UserDefaults.standard.integer(forKey: "dateInfo")
        if UserDefaults.standard.integer(forKey: "dateBalance") == 0 {
            dateBalance = 1000
        } else {
            dateBalance = UserDefaults.standard.integer(forKey: "dateBalance")
        }
        dateLevels = UserDefaults.standard.array(forKey: "dateLevels") as? [Int] ?? [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    }
    
    public func setupBonus() {
        var values = Array(0...9) + Array(0...9)
        values.shuffle()
        cards = values.map { Card(value: $0) }
        
        firstSelectionIndex = nil
        movesLeft = 7
        countOfFox = 0
        newWin = 0
        matchedCount = 0
        foundPairs = []
        
        showPauseBonus = false
        showWinBonus = false
        showLoseBonus = false
        
        showBonus = true
    }
    
    public func handleTap(on index: Int) {
        guard !cards[index].isMatched, !cards[index].isRevealed else { return }

        cards[index].isRevealed = true

        if let firstIndex = firstSelectionIndex {
            movesLeft -= 1
            
            if cards[firstIndex].value == cards[index].value {
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true
                matchedCount += 1

                if cards[firstIndex].value == 0 || cards[firstIndex].value == 1 {
                    countOfFox += 1
                }
                
                foundPairs.insert(cards[index].value)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.cards[firstIndex].isRevealed = false
                    self.cards[index].isRevealed = false
                }
            }
            
            firstSelectionIndex = nil
        } else {
            firstSelectionIndex = index
        }

        if movesLeft <= 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if self.countOfFox == 1 {
                    withAnimation() {
                        self.showWinBonus = true
                        self.newWin = self.currentWin * 2
                        
                        self.dateBalance -= self.currentWin
                        self.dateBalance += self.newWin
                        self.saveUserDefaultsChuck()
                    }
                } else if self.countOfFox == 2 {
                    withAnimation() {
                        self.showWinBonus = true
                        self.newWin = self.currentWin * 3
                        
                        self.dateBalance -= self.currentWin
                        self.dateBalance += self.newWin
                        self.saveUserDefaultsChuck()
                    }
                } else {
                    withAnimation() {
                        self.showLoseBonus = true
                    }
                }
            }
        }
    }
    
    public func setupGameChuck(_ level: Int) {
        showPause = false
        moveHistory = []
        wolfSkinsMapping = [:]
        grid = []
        doubleStep = false
        firstWin = false
        isGoldenEgg = false
        goldenEgg = false
        showPause = false
        showLose = false
        showWin = false
        showBonusWin = false
        
        currentLevel = level
        
        switch level {
        case 0:
            grid = []
            currentRows = 7
            currentCols = 3
            
            for index in 0...6 {
                if index == 0 {
                    grid.append([Tile(row: index, col: 0, type: .empty), Tile(row: index, col: 1, type: .softGround), Tile(row: index, col: 2, type: .empty)])
                } else {
                    grid.append([Tile(row: index, col: 0, type: .softGround), Tile(row: index, col: 1, type: .softGround), Tile(row: index, col: 2, type: .softGround)])
                }
            }
            
            grid[3][1].type = .wolf
            
            grid[0][1].type = .sheep0
            grid[6][1].type = .sheep1
        case 1:
            grid = []
            currentRows = 7
            currentCols = 7
            
            for index in 0...6 {
                if index == 0 {
                    grid.append([Tile(row: index, col: 0, type: .empty), Tile(row: index, col: 1, type: .softGround), Tile(row: index, col: 2, type: .empty), Tile(row: index, col: 3, type: .softGround), Tile(row: index, col: 4, type: .empty), Tile(row: index, col: 5, type: .softGround), Tile(row: index, col: 6, type: .empty)])
                } else {
                    grid.append([Tile(row: index, col: 0, type: .softGround), Tile(row: index, col: 1, type: .softGround), Tile(row: index, col: 2, type: .softGround), Tile(row: index, col: 3, type: .softGround), Tile(row: index, col: 4, type: .softGround), Tile(row: index, col: 5, type: .softGround), Tile(row: index, col: 6, type: .softGround)])
                }
            }
            
            grid[3][3].type = .wolf
            
            grid[1][0].type = .sheep0
            grid[6][0].type = .sheep1
            grid[1][6].type = .sheep2
            grid[6][6].type = .sheep3
        case 2:
            grid = []
            currentRows = 6
            currentCols = 7
            
            let layout: [[Int]] = [
                [0, 0, 0, 1, 0, 0, 0],
                [0, 1, 1, 1, 1, 1, 0],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [0, 0, 1, 1, 1, 0, 0],
            ]

            grid = []

            for (rowIndex, row) in layout.enumerated() {
                var tileRow: [Tile] = []
                for (colIndex, value) in row.enumerated() {
                    let type: TileType = value == 1 ? .softGround : .empty
                    tileRow.append(Tile(row: rowIndex, col: colIndex, type: type))
                }
                grid.append(tileRow)
            }
            
            grid[5][3].type = .wolf
            
            grid[0][3].type = .sheep0
            grid[2][0].type = .sheep1
            grid[2][6].type = .sheep2
            
            grid[2][3].type = .barrier
        case 3:
            grid = []
            currentRows = 6
            currentCols = 5
            
            let layout: [[Int]] = [
                [0, 1, 1, 1, 0],
                [1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1],
                [0, 0, 1, 0, 0],
            ]

            grid = []

            for (rowIndex, row) in layout.enumerated() {
                var tileRow: [Tile] = []
                for (colIndex, value) in row.enumerated() {
                    let type: TileType = value == 1 ? .softGround : .empty
                    tileRow.append(Tile(row: rowIndex, col: colIndex, type: type))
                }
                grid.append(tileRow)
            }
            
            grid[5][2].type = .wolf
            
            grid[2][2].type = .sheep0
        case 4:
            grid = []
            currentRows = 7
            currentCols = 7
            
            let layout: [[Int]] = [
                [0, 0, 0, 1, 0, 0, 0],
                [0, 1, 1, 1, 1, 1, 0],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [0, 0, 1, 1, 1, 0, 0],
            ]

            grid = []

            for (rowIndex, row) in layout.enumerated() {
                var tileRow: [Tile] = []
                for (colIndex, value) in row.enumerated() {
                    let type: TileType = value == 1 ? .softGround : .empty
                    tileRow.append(Tile(row: rowIndex, col: colIndex, type: type))
                }
                grid.append(tileRow)
            }
            
            grid[4][3].type = .wolf
            
            grid[0][3].type = .sheep0
            grid[4][0].type = .sheep1
            grid[4][6].type = .sheep2
            
            grid[3][1].type = .barrier
            grid[4][1].type = .barrier
            grid[1][3].type = .barrier
            grid[3][5].type = .barrier
            grid[4][5].type = .barrier
        case 5:
            grid = []
            currentRows = 6
            currentCols = 7
            
            let layout: [[Int]] = [
                [0, 0, 0, 1, 0, 0, 0],
                [0, 1, 1, 1, 1, 1, 0],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [0, 0, 1, 1, 1, 0, 0],
            ]

            grid = []

            for (rowIndex, row) in layout.enumerated() {
                var tileRow: [Tile] = []
                for (colIndex, value) in row.enumerated() {
                    let type: TileType = value == 1 ? .softGround : .empty
                    tileRow.append(Tile(row: rowIndex, col: colIndex, type: type))
                }
                grid.append(tileRow)
            }
            
            grid[3][3].type = .wolf
            
            grid[1][1].type = .sheep0
            grid[1][5].type = .sheep1
            grid[4][0].type = .sheep2
            grid[4][6].type = .sheep3
            
            grid[1][3].type = .barrier
            
            grid[2][0].type = .hardGround
            grid[3][0].type = .hardGround
            grid[2][6].type = .hardGround
            grid[3][6].type = .hardGround
            grid[0][3].type = .hardGround
            grid[1][2].type = .hardGround
            grid[1][4].type = .hardGround
            grid[5][3].type = .hardGround
            grid[5][2].type = .hardGround
            grid[5][4].type = .hardGround
            grid[4][3].type = .hardGround
            grid[4][2].type = .hardGround
            grid[4][4].type = .hardGround
            grid[3][2].type = .hardGround
            grid[3][4].type = .hardGround
            grid[2][3].type = .hardGround
        case 6:
            grid = []
            currentRows = 5
            currentCols = 7
            
            let layout: [[Int]] = [
                [0, 0, 0, 1, 0, 0, 0],
                [0, 1, 1, 1, 1, 1, 0],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [0, 0, 1, 1, 1, 0, 0],
            ]

            grid = []

            for (rowIndex, row) in layout.enumerated() {
                var tileRow: [Tile] = []
                for (colIndex, value) in row.enumerated() {
                    let type: TileType = value == 1 ? .softGround : .empty
                    tileRow.append(Tile(row: rowIndex, col: colIndex, type: type))
                }
                grid.append(tileRow)
            }
            
            grid[4][3].type = .wolf
            grid[3][0].type = .wolf
            grid[3][6].type = .wolf
            
            grid[1][3].type = .sheep0
        case 7:
            grid = []
            currentRows = 7
            currentCols = 3
            
            for index in 0...6 {
                if index == 0 {
                    grid.append([Tile(row: index, col: 0, type: .empty), Tile(row: index, col: 1, type: .softGround), Tile(row: index, col: 2, type: .empty)])
                } else {
                    grid.append([Tile(row: index, col: 0, type: .softGround), Tile(row: index, col: 1, type: .softGround), Tile(row: index, col: 2, type: .softGround)])
                }
            }
            
            grid[3][1].type = .sheep0
            
            grid[0][1].type = .wolf
            grid[6][1].type = .wolf
        case 8:
            grid = []
            currentRows = 7
            currentCols = 7
            
            let layout: [[Int]] = [
                [0, 0, 0, 1, 0, 0, 0],
                [0, 1, 1, 1, 1, 1, 0],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [0, 0, 1, 1, 1, 0, 0],
            ]

            grid = []

            for (rowIndex, row) in layout.enumerated() {
                var tileRow: [Tile] = []
                for (colIndex, value) in row.enumerated() {
                    let type: TileType = value == 1 ? .softGround : .empty
                    tileRow.append(Tile(row: rowIndex, col: colIndex, type: type))
                }
                grid.append(tileRow)
            }
            
            grid[0][3].type = .wolf
            grid[6][3].type = .wolf

            grid[2][0].type = .sheep0
            grid[2][6].type = .sheep1
            grid[5][0].type = .sheep2
            grid[5][6].type = .sheep3
            
            grid[1][3].type = .hardGround
            grid[2][3].type = .hardGround
            grid[3][3].type = .hardGround
            grid[4][3].type = .hardGround
            grid[5][3].type = .hardGround
            grid[1][4].type = .hardGround
            grid[2][4].type = .hardGround
            grid[3][4].type = .hardGround
            grid[4][4].type = .hardGround
            grid[5][4].type = .hardGround
            grid[6][4].type = .hardGround
            grid[1][2].type = .hardGround
            grid[2][2].type = .hardGround
            grid[3][2].type = .hardGround
            grid[4][2].type = .hardGround
            grid[5][2].type = .hardGround
            grid[6][2].type = .hardGround
            grid[3][1].type = .hardGround
            grid[3][5].type = .hardGround
        case 9:
            grid = []
            currentRows = 7
            currentCols = 7
            
            let layout: [[Int]] = [
                [0, 0, 0, 1, 0, 0, 0],
                [0, 1, 1, 1, 1, 1, 0],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [0, 0, 1, 1, 1, 0, 0],
            ]

            grid = []

            for (rowIndex, row) in layout.enumerated() {
                var tileRow: [Tile] = []
                for (colIndex, value) in row.enumerated() {
                    let type: TileType = value == 1 ? .softGround : .empty
                    tileRow.append(Tile(row: rowIndex, col: colIndex, type: type))
                }
                grid.append(tileRow)
            }
            
            grid[0][3].type = .wolf
            grid[2][0].type = .wolf
            grid[2][6].type = .wolf
            
            grid[4][3].type = .sheep0
            grid[5][3].type = .sheep1
        default:
            grid = []
            currentRows = 7
            currentCols = 3
            
            for index in 0...6 {
                if index == 0 {
                    grid.append([Tile(row: index, col: 0, type: .empty), Tile(row: index, col: 1, type: .softGround), Tile(row: index, col: 2, type: .empty)])
                } else {
                    grid.append([Tile(row: index, col: 0, type: .softGround), Tile(row: index, col: 1, type: .softGround), Tile(row: index, col: 2, type: .softGround)])
                }
            }
        }
        
        let wolves = grid.flatMap { $0 }.filter { $0.type == .wolf }
        assignWolfSkins(for: currentLevel, wolves: wolves)
        
        withAnimation() {
            showGame = true
        }
        
        if dateInfo != 2 {
            withAnimation() {
                pageInfo = 1
                showInfo = true
            }
            
            dateInfo = 2
            saveUserDefaultsChuck()
        }
    }
    
    func saveCurrentState() {
        let gridCopy = grid.map { row in row.map { $0 } }
        moveHistory.append(gridCopy)
    }

    func undoMove() {
        guard let previous = moveHistory.popLast() else { return }
        grid = previous
    }
    
    func assignWolfSkins(for level: Int, wolves: [Tile]) {
        guard let skins = wolfSkinsByLevel[level] else { return }
        
        wolfSkinsMapping.removeAll()
        
        for (index, wolf) in wolves.enumerated() {
            let skin = skins[index % skins.count]
            wolfSkinsMapping[wolf.id] = skin
        }
    }
    
    func tileTapped(row: Int, col: Int) {
        guard !showLose else { return }
        
        if grid[row][col].type == .softGround {
            saveCurrentState()
            
            grid[row][col].type = .barrier
            
            if doubleStep {
                withAnimation() {
                    doubleStep = false
                }
            } else {
                moveWolves()
            }
            
            spawnGoldenEgg()
        }
    }
    
    func moveWolves() {
        withAnimation {
            let wolves = grid.flatMap { $0 }
                .filter { $0.type == .wolf }
                .map { ($0.row, $0.col) }

            var anyWolfCanReachSheep = false

            for (row, col) in wolves {
                if let target = nearestSheep(from: (row, col)) {
                    let path = bfs(from: (row, col), to: target)

                    if path.count > 1 {
                        anyWolfCanReachSheep = true
                        let next = path[1]

                        switch grid[next.0][next.1].type {
                        case .sheep0, .sheep1, .sheep2, .sheep3:
                            let wolfId = grid[row][col].id
                            grid[row][col].id = grid[next.0][next.1].id
                            grid[next.0][next.1].id = wolfId
                            grid[row][col].type = .softGround
                            grid[next.0][next.1].type = .wolf
                            showLose = true
                            return
                        case .softGround, .hardGround, .goldenEgg:
                            let wolfId = grid[row][col].id
                            grid[row][col].id = grid[next.0][next.1].id
                            grid[next.0][next.1].id = wolfId
                            grid[row][col].type = .softGround
                            grid[next.0][next.1].type = .wolf
                        default:
                            break
                        }
                    }
                }
            }

            // После проверки всех волков
            if !anyWolfCanReachSheep {
                let hasSheep = grid.flatMap { $0 }.contains { tile in
                    switch tile.type {
                    case .sheep0, .sheep1, .sheep2, .sheep3:
                        return true
                    default:
                        return false
                    }
                }

                if hasSheep {
                    if goldenEgg {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                if self.currentLevel < 9 {
                                    if self.dateLevels[self.currentLevel + 1] == 0 {
                                        self.dateBalance += 500
                                        self.currentWin = 500
                                    } else {
                                        self.dateBalance += 200
                                        self.currentWin = 200
                                    }
                                    self.dateLevels[self.currentLevel + 1] = 1
                                } else {
                                    self.dateBalance += 500
                                    self.currentWin = 500
                                }

                                self.showBonusWin = true
                                self.saveUserDefaultsChuck()
                            }
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                if self.currentLevel < 9 {
                                    if self.dateLevels[self.currentLevel + 1] == 0 {
                                        self.firstWin = true
                                        self.dateBalance += 500
                                        self.currentWin = 500
                                    } else {
                                        self.firstWin = false
                                        self.dateBalance += 200
                                        self.currentWin = 200
                                    }
                                    self.dateLevels[self.currentLevel + 1] = 1
                                } else {
                                    self.dateBalance += 500
                                    self.currentWin = 500
                                }

                                self.showWin = true
                                self.saveUserDefaultsChuck()
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            self.showLose = true
                            self.saveUserDefaultsChuck()
                        }
                    }
                }
            }
        }
    }

    func nearestSheep(from start: (Int, Int)) -> (Int, Int)? {
        var visited = Set<String>()
        var queue: [(Int, Int)] = [start]
        visited.insert("\(start.0),\(start.1)")

        var foundSheep: [(Int, Int)] = []

        while !queue.isEmpty {
            var nextQueue: [(Int, Int)] = []

            for current in queue {
                let (row, col) = current

                if grid[row][col].type == .sheep0 || grid[row][col].type == .sheep1 || grid[row][col].type == .sheep2 || grid[row][col].type == .sheep3 {
                    foundSheep.append(current)
                }
                
                let tileID = grid[row][col].id
                for (nr, nc) in possibleMoves(from: row, col, for: tileID) {
                    let key = "\(nr),\(nc)"
                    if !visited.contains(key) {
                        visited.insert(key)
                        nextQueue.append((nr, nc))
                    }
                }
            }

            if !foundSheep.isEmpty {
                return foundSheep.min { a, b in
                    a.0 == b.0 ? a.1 < b.1 : a.0 < b.0
                }
            }

            queue = nextQueue
        }

        return nil
    }

    func bfs(from start: (Int, Int), to goal: (Int, Int)) -> [(Int, Int)] {
        var visited = Set<String>()
        var queue: [[(Int, Int)]] = [[start]]
              
        while !queue.isEmpty {
            let path = queue.removeFirst()
            let current = path.last!
            if current == goal {
                return path
            }
            
            let tileID = grid[current.0][current.1].id
            for neighbor in possibleMoves(from: current.0, current.1, for: tileID) {
                let key = "\(neighbor.0),\(neighbor.1)"
                if !visited.contains(key) {
                    visited.insert(key)
                    queue.append(path + [neighbor])
                }
            }
        }
        
        return []
    }
    
    func possibleMoves(from row: Int, _ col: Int, for tileID: UUID) -> [(Int, Int)] {
        var directions: [(Int, Int)] = []

        let isEven = col % 2 == 0

        let normalDirections: [(Int, Int)] = isEven
            ? [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1)]
            : [(-1, 0), (1, 0), (0, -1), (0, 1), (1, -1), (1, 1)]

        directions.append(contentsOf: normalDirections)

        let extendedSkins: Set<String> = ["ChuckGameTileFox3", "ChuckGameTileFox4", "ChuckGameTileFox7"]

        if let skin = wolfSkinsMapping[tileID], extendedSkins.contains(skin) {
            let longDirections: [(Int, Int)] = isEven
                ? [(-2, 0), (2, 0), (0, -2), (0, 2), (-2, -1), (-2, 1)]
                : [(-2, 0), (2, 0), (0, -2), (0, 2), (2, -1), (2, 1)]

            directions.append(contentsOf: longDirections)
        }

        let allowedTypes: Set<TileType> = [.softGround, .hardGround, .sheep0, .sheep1, .sheep2, .sheep3, .goldenEgg]

        return directions.compactMap { dr, dc in
            let newRow = row + dr
            let newCol = col + dc

            guard !grid.isEmpty,
                  newRow >= 0, newRow < grid.count,
                  newCol >= 0, newCol < grid[newRow].count else {
                return nil
            }

            let destinationType = grid[newRow][newCol].type
            guard allowedTypes.contains(destinationType) else {
                return nil
            }

            let isLongJump = abs(dr) == 2 || abs(dc) == 2
            if isLongJump {
                let midRow = row + dr / 2
                let midCol = col + dc / 2

                guard midRow >= 0, midRow < grid.count,
                      midCol >= 0, midCol < grid[midRow].count else {
                    return nil
                }

                let middleType = grid[midRow][midCol].type
                if middleType == .barrier {
                    return nil
                }
            }

            return (newRow, newCol)
        }
    }
}
