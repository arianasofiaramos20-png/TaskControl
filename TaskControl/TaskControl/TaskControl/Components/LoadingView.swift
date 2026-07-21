//
//  LoadingView.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//
import SwiftUI

struct LoadingView: View {

    let message: String

    var body: some View {

        ZStack {

            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 20) {

                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)

                Text(message)
                    .foregroundColor(.white)
                    .font(.headline)

            }
            .padding(30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    LoadingView(message: "Cargando...")
}
