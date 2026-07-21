//
//  RegisterView.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import SwiftUI

struct RegisterView: View {

    @EnvironmentObject private var authViewModel: AuthViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ZStack {

            AppColors.gradient
                .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 28) {

                    Spacer()
                        .frame(height: 25)

                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 65))
                        .foregroundStyle(.white)

                    VStack(spacing: 8) {

                        Text("Crear cuenta")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text("Regístrate para empezar a organizar tus tareas")
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 18) {

                        AppTextField(
                            title: "Correo electrónico",
                            systemImage: "envelope.fill",
                            text: $authViewModel.email
                        )

                        AppTextField(
                            title: "Contraseña",
                            systemImage: "lock.fill",
                            text: $authViewModel.password,
                            isSecure: true
                        )

                        AppTextField(
                            title: "Confirmar contraseña",
                            systemImage: "lock.shield.fill",
                            text: $authViewModel.confirmPassword,
                            isSecure: true
                        )

                    }
                    .padding()
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )

                    PrimaryButton(
                        title: "Crear cuenta",
                        systemImage: "person.crop.circle.badge.plus"
                    ) {

                        Task {
                            await authViewModel.register()
                        }

                    }

                    Button {
                        dismiss()
                    } label: {

                        Text("¿Ya tienes una cuenta? Inicia sesión")
                            .foregroundStyle(.white)
                            .fontWeight(.medium)

                    }

                    Spacer()

                }
                .padding()
            }

            if authViewModel.isLoading {

                LoadingView(
                    message: "Creando cuenta..."
                )

            }

        }
        .navigationBarBackButtonHidden(true)
        .toolbar {

            ToolbarItem(
                placement: .topBarLeading
            ) {

                Button {
                    dismiss()
                } label: {

                    Image(
                        systemName: "chevron.left"
                    )
                    .foregroundStyle(.white)
                    .fontWeight(.bold)

                }

            }

        }
        .alert(
            "Aviso",
            isPresented: $authViewModel.showError
        ) {

            Button("Aceptar") {}

        } message: {

            Text(authViewModel.errorMessage)

        }
    }
}

#Preview {

    NavigationStack {

        RegisterView()
            .environmentObject(
                AuthViewModel()
            )

    }

}
