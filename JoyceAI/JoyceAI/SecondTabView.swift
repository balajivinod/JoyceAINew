//
//  SecondTabView.swift
//  JoyceAI
//
//  Created by C119142 on 5/22/24.
//

import SwiftUI

struct SecondTabView: View {
    @ObservedObject var viewModel: SecondTabViewModel
    var body: some View {
        VStack {
            Text(viewModel.text)
                .font(.largeTitle)
                .padding()
        }
    }
}

struct SecondTabView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SecondTabViewModel()
        SecondTabView(viewModel: viewModel)
    }
}
