//
//  SplashView.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import SwiftUI

struct SplashView: View {

    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var logoScale: CGFloat = 0.75
    @State private var logoOpacity: Double = 0
    @State private var showContent = false

    var body: some View {
        ZStack {
            AppColors.gradient
                .ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.16))
                        .frame(width: 150, height: 150)

                    Image(systemName: "checklist")
                        .font(.system(size: 68, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                if showContent {
                    VStack(spacing: 10) {
                        Text("TaskControl")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(.white)

                        Text("Organiza tus tareas de manera simple")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                ProgressView()
                    .tint(.white)
                    .padding(.top, 12)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.65)) {
                logoScale = 1
                logoOpacity = 1
            }

            withAnimation(.easeOut(duration: 0.6).delay(0.35)) {
                showContent = true
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AuthViewModel())
}
