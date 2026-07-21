//
//  EmptyState.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import SwiftUI

struct EmptyState: View {

    let title: String
    let message: String
    let systemImage: String

    var body: some View {

        VStack(spacing: 20) {

            Image(systemName: systemImage)
                .font(.system(size: 70))
                .foregroundStyle(AppColors.primary)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

        }
        .padding()
    }
}

#Preview {
    EmptyState(
        title: "No hay tareas",
        message: "Presiona el botón + para agregar tu primera tarea.",
        systemImage: "tray"
    )
}
