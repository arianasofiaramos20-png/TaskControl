//
//  LoginView.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {

        ZStack {

            AppColors.gradient
                .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 30) {

                    Spacer()
                        .frame(height: 40)

                    Image(systemName: "checklist")
                        .font(.system(size: 70))
                        .foregroundStyle(.white)

                    Text("Bienvenido")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Text("Inicia sesión para administrar tus tareas")
                        .foregroundStyle(.white.opacity(0.9))

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

                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    PrimaryButton(
                        title: "Iniciar Sesión",
                        systemImage: "arrow.right.circle.fill"
                    ) {

                        Task {
                            await authViewModel.login()
                        }

                    }

                    NavigationLink("¿No tienes cuenta? Regístrate") {
                        RegisterView()
                    }
                    .foregroundStyle(.white)

                    Spacer()

                }
                .padding()
            }

            if authViewModel.isLoading {

                LoadingView(message: "Iniciando sesión...")

            }

        }
        .navigationBarBackButtonHidden(true)
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

        LoginView()
            .environmentObject(AuthViewModel())

    }

}
