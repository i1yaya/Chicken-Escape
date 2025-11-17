import SwiftUI

struct ChuckInfoView: View {
    @StateObject public var viewModel: ChuckViewModel
    
    var body: some View {
        ZStack {
            if viewModel.pageInfo != 2 {
                Image("ChuckWelcomeBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .padding(.all, 0.0)
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Button {
                            withAnimation() {
                                viewModel.showInfo = false
                            }
                        } label: {
                            if viewModel.pageInfo == 2 {
                                Image("ChuckInfoBackButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 75)
                            } else {
                                Image("ChuckInfoHomeButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 75)
                            }
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

                    Image("ChuckInfoGround")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 1100)
                    
                    if viewModel.pageInfo == 1 {
                        Button {
                            withAnimation() {
                                viewModel.showInfo = false
                            }
                        } label: {
                            Image("ChuckInfoStartButton")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 105)
                        }
                    }
                }
                .padding(.vertical, 15.0)
            }
        }
    }
}
