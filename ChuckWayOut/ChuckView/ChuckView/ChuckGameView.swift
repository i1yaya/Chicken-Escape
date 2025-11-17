import SwiftUI

struct ChuckGameView: View {
    @StateObject public var viewModel: ChuckViewModel
    @State private var device = UIDevice()

    var body: some View {
        ZStack {
            ZStack {
                Image("ChuckWelcomeBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .padding(.all, 0.0)
                
                Color(#colorLiteral(red: 0, green: 0.1488004327, blue: 0.2420957685, alpha: 1))
                    .ignoresSafeArea()
                    .opacity(0.75)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Button {
                                withAnimation() {
                                    viewModel.showPause = true
                                }
                            } label: {
                                Image("ChuckGamePauseButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 75)
                            }
                            
                            ZStack {
                                Image("ChuckMenuBalanceFrame")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 75)
                                
                                ZStack {
                                    Text("\(viewModel.dateBalance)")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .fontWeight(.black)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 90)
                                }
                                .padding(.trailing, 37.5)
                                .padding(.top, -10.0)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 15.0)
                        
                        VStack {
                            Image("ChuckGameTool0")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 0.0)
                                .padding(.top, -37.5)
                            
                            VStack {
                                ForEach(Array(viewModel.grid.enumerated()), id: \.offset) { rowIndex, row in
                                    HStack {
                                        ForEach(Array(row.enumerated()), id: \.offset) { colIndex, tile in
                                            ZStack {
                                                if tile.type != .empty {
                                                    Image(imageForTile(tile))
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? 40 : 50)
                                                        .offset(y: colIndex.isMultiple(of: 2) ? device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? -20.0 : -25.0 : 0)
                                                        .onTapGesture {
                                                            if tile.type == .goldenEgg {
                                                                withAnimation() {
                                                                    viewModel.goldenEgg = true
                                                                    viewModel.grid[tile.row][tile.col].type = .softGround
                                                                }
                                                            } else {
                                                                viewModel.tileTapped(row: tile.row, col: tile.col)
                                                            }
                                                        }
                                                } else {
                                                    Image(imageForTile(tile))
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? 40 : 50)
                                                        .offset(y: colIndex.isMultiple(of: 2) ? device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? -20.0 : -25.0 : 0)
                                                        .opacity(0.0)
                                                }
                                            }
                                            .padding(.horizontal, -9.0)
                                            .padding(.vertical, -3.0)
                                        }
                                    }
                                }
                            }
                            .padding(.top, -5.0)
                            
                            Image("ChuckGameTool1")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 0.0)
                                .padding(.top, -5.0)
                        }
                        
                        HStack {
                            ZStack {
                                Image("ChuckGameBoost0")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 85)
                                
                                VStack {
                                    Spacer()
                                    
                                    Image("ChuckGameBuyButton")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 45)
                                }
                                .frame(height: 125)
                            }
                            .onTapGesture {
                                withAnimation() {
                                    if viewModel.moveHistory.count > 0 {
                                        if viewModel.dateBalance >= 200 {
                                            viewModel.dateBalance -= 200
                                            viewModel.undoMove()
                                            
                                            viewModel.saveUserDefaultsChuck()
                                        }
                                    }
                                }
                            }
                            .opacity(viewModel.moveHistory.count > 0 ? viewModel.dateBalance >= 200 ? 1 : 0 : 0.5)
                            
                            ZStack {
                                Image("ChuckGameBoost1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 85)
                                
                                VStack {
                                    Spacer()
                                    
                                    Image("ChuckGameBuyButton")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 45)
                                }
                                .frame(height: 125)
                            }
                            .scaleEffect(viewModel.doubleStep ? 0.75 : 1.0)
                            .onTapGesture {
                                withAnimation() {
                                    if !viewModel.doubleStep {
                                        if viewModel.dateBalance >= 200 {
                                            viewModel.dateBalance -= 200
                                            viewModel.doubleStep = true
                                            
                                            viewModel.saveUserDefaultsChuck()
                                        }
                                    }
                                }
                            }
                            .opacity(viewModel.dateBalance >= 200 ? viewModel.doubleStep ? 0.5 : 1 : 0)
                        }
                        .padding(.top, -25.0)
                    }
                    .padding(.vertical, 15.0)
                }
            }
            
            ZStack {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.85)
                
                VStack {
                    Image("ChuckGamePauseTitle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 260)
                    
                    VStack {
                        Button {
                            withAnimation() {
                                viewModel.showPause = false
                            }
                        } label: {
                            Image("ChuckGamePauseBackButton")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 105)
                        }
                        
                        HStack {
                            Button {
                                withAnimation() {
                                    viewModel.pageInfo = 2
                                    viewModel.showInfo = true
                                }
                            } label: {
                                Image("ChuckGamePauseInfoButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 105)
                            }
                            
                            Button {
                                withAnimation() {
                                    viewModel.showGame = false
                                }
                            } label: {
                                Image("ChuckGamePauseHomeButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 105)
                            }
                        }
                    }
                }
            }
            .opacity(viewModel.showPause ? 1 : 0)
            
            ZStack {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.85)
                
                VStack {
                    Image("ChuckGameResultWin\(viewModel.firstWin ? 0 : 1)")
                        .resizable()
                        .scaledToFit()
                        .frame(height: device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? 400 : 435)
                    
                    if viewModel.currentLevel < 9 {
                        Button {
                            withAnimation() {
                                viewModel.setupGameChuck(viewModel.currentLevel + 1)
                            }
                        } label: {
                            Image("ChuckGameResultNextButton")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 105)
                        }
                    }
                    
                    Button {
                        withAnimation() {
                            viewModel.showGame = false
                        }
                    } label: {
                        Image("ChuckGameResultHomeButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 105)
                    }
                }
            }
            .opacity(viewModel.showWin ? 1 : 0)
            
            ZStack {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.85)
                
                VStack {
                    Image("ChuckGameResultLose")
                        .resizable()
                        .scaledToFit()
                        .frame(height: device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? 300 : 330)
                    
                    Button {
                        withAnimation() {
                            viewModel.setupGameChuck(viewModel.currentLevel)
                        }
                    } label: {
                        Image("ChuckGameResultAgainButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 105)
                    }
                    
                    Button {
                        withAnimation() {
                            viewModel.showGame = false
                        }
                    } label: {
                        Image("ChuckGameResultHomeButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 105)
                    }
                }
            }
            .opacity(viewModel.showLose ? 1 : 0)
            
            ZStack {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.85)
                
                VStack {
                    Image("ChuckGameResultWinBonus")
                        .resizable()
                        .scaledToFit()
                        .frame(height: device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? 400 : 450)
                    
                    Button {
                        withAnimation() {
                            viewModel.setupBonus()
                        }
                    } label: {
                        Image("ChuckGameResultBonusButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 105)
                    }
                    
                    HStack {
                        Button {
                            withAnimation() {
                                viewModel.showGame = false
                            }
                        } label: {
                            Image("ChuckGameResultHomeButton")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 105)
                        }
                        
                        if viewModel.currentLevel < 9 {
                            Button {
                                withAnimation() {
                                    viewModel.setupGameChuck(viewModel.currentLevel + 1)
                                }
                            } label: {
                                Image("ChuckGameResultNextButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 105)
                            }
                        }
                    }
                }
            }
            .opacity(viewModel.showBonusWin ? 1 : 0)
        }
    }

    func imageForTile(_ tile: Tile) -> String {
        switch tile.type {
        case .empty: return "ChuckGameTile0"
        case .sheep0: return "ChuckGameTileChicken0"
        case .sheep1: return "ChuckGameTileChicken1"
        case .sheep2: return "ChuckGameTileChicken2"
        case .sheep3: return "ChuckGameTileChicken3"
        case .wolf: return viewModel.wolfSkinsMapping[tile.id] ?? "ChuckGameTileFox0"
        case .barrier: return "ChuckGameTileStone"
        case .softGround: return "ChuckGameTile1"
        case .hardGround: return "ChuckGameTile0"
        case .goldenEgg: return "ChuckGameTileEggs"
        }
    }
}
