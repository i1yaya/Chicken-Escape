import SwiftUI

struct ChuckMenuView: View {
    @StateObject public var viewModel: ChuckViewModel
    
    var body: some View {
        ZStack {
            Image("ChuckWelcomeBackground")
                .resizable()
                .ignoresSafeArea()
                .padding(.all, 0.0)
            
            ZStack {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Image("ChuckMenuLamp")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 450)
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Image("ChuckMenuChickens")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 367.5)
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Image("ChuckMenuGrass")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 172.5)
                    }
                }
                .ignoresSafeArea()
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Button {
                            withAnimation() {
                                viewModel.pageInfo = 0
                                viewModel.showInfo = true
                            }
                        } label: {
                            Image("ChuckMenuInfoButton")
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
                        Image("ChuckMenuLevelTitle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 27.5)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 25.0)
                    
                    VStack {
                        ForEach(0..<2) { row in
                            HStack {
                                ForEach(0..<3) { column in
                                    Image("ChuckMenu\(viewModel.dateLevels[3 * row + column])\(3 * row + column)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 130)
                                        .onTapGesture() {
                                            if viewModel.dateLevels[3 * row + column] == 1 {
                                                withAnimation() {
                                                    viewModel.setupGameChuck(3 * row + column)
                                                }
                                            }
                                        }
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 15.0)
                        }
                    }
                    
                    VStack {
                        ForEach(2..<4) { row in
                            HStack {
                                ForEach(2..<4) { column in
                                    Image("ChuckMenu\(viewModel.dateLevels[2 * row + column])\(2 * row + column)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 130)
                                        .onTapGesture() {
                                            if viewModel.dateLevels[2 * row + column] == 1 {
                                                withAnimation() {
                                                    viewModel.setupGameChuck(2 * row + column)
                                                }
                                            }
                                        }
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 15.0)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 15.0)
            }
        }
    }
}
