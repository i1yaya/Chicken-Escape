import SwiftUI

struct ChuckBonusView: View {
    @State private var device = UIDevice()
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 5)
    @StateObject public var viewModel: ChuckViewModel
    
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
                                    viewModel.showPauseBonus = true
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
                        
                        HStack {
                            Image("ChuckBonusTitle")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                            
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
                                ForEach(0..<4, id: \.self) { row in
                                    HStack {
                                        ForEach(0..<5, id: \.self) { col in
                                            let index = 4 * col + row
                                            
                                            if index < viewModel.cards.count {
                                                let card = viewModel.cards[index]
                                                
                                                ZStack {
                                                    Image("ChuckBonusTile")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? 55 : 65)
                                                    
                                                    if card.isRevealed || card.isMatched {
                                                        Image("ChuckBonusTile\(card.value)")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(height: device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? 55 : 65)
                                                    }
                                                }
                                                .onTapGesture {
                                                    withAnimation(.linear(duration: 0.2)) {
                                                        viewModel.handleTap(on: index)
                                                    }
                                                }
                                                .disabled(card.isMatched || card.isRevealed)
                                            }
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
                        
                        VStack {
                            Text("Moves left: \(viewModel.movesLeft)")
                                .font(.system(size: device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? 18 : 22))
                                .foregroundColor(.white)
                                .fontWeight(.black)
                                .multilineTextAlignment(.center)
                            
                            ZStack {
                                Image("ChuckBonusGround")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? 75 : 85)
                            }
                        }
                    }
                    .padding(.vertical, 15.0)
                }
            }
            
            ZStack {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.85)
                
                VStack {
                    Image("ChuckBonusFrame")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                    
                    VStack {
                        Button {
                            withAnimation() {
                                viewModel.showPauseBonus = false
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
                                    viewModel.showBonus = false
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
            .opacity(viewModel.showPauseBonus ? 1 : 0)
            
            ZStack {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.85)
                
                VStack {
                    Image("ChuckBonusLose")
                        .resizable()
                        .scaledToFit()
                        .frame(height: device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? 400 : 450)
                    
                    Button {
                        withAnimation() {
                            viewModel.showBonus = false
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
            .opacity(viewModel.showLoseBonus ? 1 : 0)
            
            ZStack {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.85)
                
                VStack {
                    Image("ChuckBonusWin\(viewModel.countOfFox == 1 ? "0" : "1")")
                        .resizable()
                        .scaledToFit()
                        .frame(height: device.deviceModel == .iPhone8 || device.deviceModel == .iPhone8Plus ? 400 : 450)
                    
                    Text("Your final reward:")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.black)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("\(viewModel.newWin)")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                        
                        ZStack {
                            Image("ChuckCoin")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                        }
                        .padding(.leading, -7.5)
                        .padding(.top, 5.0)
                    }
                    
                    Button {
                        withAnimation() {
                            viewModel.showBonus = false
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
            .opacity(viewModel.showWinBonus ? 1 : 0)
        }
    }
}
