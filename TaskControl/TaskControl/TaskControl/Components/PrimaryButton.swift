//
//  PrimaryButton.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import SwiftUI

struct PrimaryButton: View {

    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {

            HStack(spacing: 10) {

                Image(systemName: systemImage)
                    .font(.headline)

                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        AppColors.primary,
                        AppColors.secondary
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(
                color: AppColors.primary.opacity(0.35),
                radius: 8,
                x: 0,
                y: 6
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        PrimaryButton(
            title: "Iniciar sesión",
            systemImage: "arrow.right.circle.fill"
        ) {

        }
        .padding()
    }
}
