//
//  TaskCard.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//
import SwiftUI

struct TaskCard: View {

    let title: String
    let description: String
    let isCompleted: Bool

    var body: some View {

        HStack(alignment: .top, spacing: 16) {

            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(
                    isCompleted ? AppColors.success : AppColors.primary
                )

            VStack(alignment: .leading, spacing: 8) {

                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppColors.title)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

            }

            Spacer()

        }
        .padding()
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(
            color: .black.opacity(0.08),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}

#Preview {
    VStack(spacing: 20) {

        TaskCard(
            title: "Estudiar SwiftUI",
            description: "Completar el proyecto TaskControl usando Firebase y MVVM.",
            isCompleted: false
        )

        TaskCard(
            title: "Proyecto terminado",
            description: "La tarea fue completada correctamente.",
            isCompleted: true
        )

    }
    .padding()
}
