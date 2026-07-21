//
//  AppTextField.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import SwiftUI

struct AppTextField: View {

    let title: String
    let systemImage: String

    @Binding var text: String

    var isSecure: Bool = false

    var body: some View {

        HStack(spacing: 12) {

            Image(systemName: systemImage)
                .foregroundColor(AppColors.primary)
                .frame(width: 22)

            if isSecure {

                SecureField(title, text: $text)

            } else {

                TextField(title, text: $text)

            }

        }
        .padding()
        .background(AppColors.fieldBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    AppColors.primary.opacity(0.15),
                    lineWidth: 1
                )
        )
    }
}

#Preview {

    VStack(spacing: 20) {

        AppTextField(
            title: "Correo electrónico",
            systemImage: "envelope.fill",
            text: .constant("")
        )

        AppTextField(
            title: "Contraseña",
            systemImage: "lock.fill",
            text: .constant(""),
            isSecure: true
        )

    }
    .padding()
}
