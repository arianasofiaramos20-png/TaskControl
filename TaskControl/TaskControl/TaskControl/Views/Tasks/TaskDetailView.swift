//
//  TaskDetailView.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import SwiftUI

struct TaskDetailView: View {

    @EnvironmentObject private var taskViewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss

    let task: TaskItem

    @State private var showEditForm = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    Image(
                        systemName: task.isCompleted
                        ? "checkmark.circle.fill"
                        : "clock.circle.fill"
                    )
                    .font(.system(size: 72))
                    .foregroundStyle(
                        task.isCompleted
                        ? AppColors.success
                        : AppColors.primary
                    )
                    .padding(.top, 30)

                    VStack(alignment: .leading, spacing: 18) {
                        Text(task.title)
                            .font(.title2)
                            .fontWeight(.bold)

                        Divider()

                        Text(task.description)
                            .font(.body)
                            .foregroundStyle(.secondary)

                        Divider()

                        HStack {
                            Label(
                                task.isCompleted
                                ? "Completada"
                                : "Pendiente",
                                systemImage: task.isCompleted
                                ? "checkmark.circle.fill"
                                : "circle"
                            )
                            .foregroundStyle(
                                task.isCompleted
                                ? AppColors.success
                                : AppColors.warning
                            )

                            Spacer()

                            Text(
                                task.createdAt.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                )
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(AppColors.cardBackground)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 22)
                    )

                    PrimaryButton(
                        title: task.isCompleted
                        ? "Marcar como pendiente"
                        : "Marcar como completada",
                        systemImage: task.isCompleted
                        ? "arrow.uturn.backward.circle.fill"
                        : "checkmark.circle.fill"
                    ) {
                        Task {
                            await taskViewModel.toggleCompletion(task)
                            dismiss()
                        }
                    }

                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label(
                            "Eliminar tarea",
                            systemImage: "trash.fill"
                        )
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
                .padding()
            }

            if taskViewModel.isLoading {
                LoadingView(message: "Procesando...")
            }
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showEditForm = true
                } label: {
                    Label(
                        "Editar",
                        systemImage: "pencil"
                    )
                }
            }
        }
        .sheet(isPresented: $showEditForm) {
            NavigationStack {
                TaskFormView(task: task)
            }
            .environmentObject(taskViewModel)
        }
        .alert(
            "Eliminar tarea",
            isPresented: $showDeleteConfirmation
        ) {
            Button("Cancelar", role: .cancel) {}

            Button("Eliminar", role: .destructive) {
                Task {
                    await taskViewModel.deleteTask(task)
                    dismiss()
                }
            }
        } message: {
            Text("Esta acción no se puede deshacer.")
        }
        .alert(
            "Error",
            isPresented: $taskViewModel.showError
        ) {
            Button("Aceptar") {
                taskViewModel.clearError()
            }
        } message: {
            Text(taskViewModel.errorMessage)
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(
            task: TaskItem(
                title: "Preparar presentación",
                description: "Terminar la presentación del proyecto TaskControl.",
                isCompleted: false,
                createdAt: Date()
            )
        )
        .environmentObject(TaskViewModel())
    }
}
