import SwiftUI

struct ChuckWelcomeView: View {
    @StateObject public var viewModel: ChuckViewModel
    
    var body: some View {
        ZStack {
            Image("ChuckWelcomeBackground")
                .resizable()
                .ignoresSafeArea()
                .padding(.all, 0.0)
            
            VStack {
                Image("ChuckWelcomeGround")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 465)
                
                Button {
                    withAnimation() {
                        viewModel.showWelcome = false
                        
                        viewModel.dateWelcome = 2
                        viewModel.saveUserDefaultsChuck()
                    }
                } label: {
                    Image("ChuckWelcomeNextButton")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 122.5)
                }
            }
        }
    }
}
