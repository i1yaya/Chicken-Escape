import SwiftUI

struct ChuckWindow: View {
    @StateObject private var viewModel = ChuckViewModel()
    
    var body: some View {
        ZStack {
            ChuckMenuView(viewModel: self.viewModel)
            
            ChuckGameView(viewModel: self.viewModel)
                .opacity(viewModel.showGame ? 1 : 0)
            
            ChuckBonusView(viewModel: self.viewModel)
                .opacity(viewModel.showBonus ? 1 : 0)
            
            ChuckInfoView(viewModel: self.viewModel)
                .opacity(viewModel.showInfo ? 1 : 0)
            
            ChuckWelcomeView(viewModel: self.viewModel)
                .opacity(viewModel.showWelcome ? 1 : 0)
        }
        .onAppear() {
            viewModel.loadUserDefaultsChuck()
            
            if viewModel.dateWelcome == 2 {
                viewModel.showWelcome = false
            } else {
                viewModel.showWelcome = true
            }
        }
    }
}
