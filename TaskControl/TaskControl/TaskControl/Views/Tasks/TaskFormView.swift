//
//  TaskFormView.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import SwiftUI

struct TaskFormView: View {

    @EnvironmentObject private var taskViewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss

    let task: TaskItem?

    @State private var title: String
    @State private var description: String
    @State private var isCompleted: Bool

    init(task: TaskItem? = nil) {
        self.task = task

        _title = State(initialValue: task?.title ?? "")
        _description = State(initialValue: task?.description ?? "")
        _isCompleted = State(initialValue: task?.isCompleted ?? false)
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    Image(
                        systemName: task == nil
                        ? "square.and.pencil"
                        : "pencil.circle.fill"
                    )
                    .font(.system(size: 60))
                    .foregroundStyle(AppColors.primary)
                    .padding(.top, 24)

                    VStack(spacing: 18) {
                        AppTextField(
                            title: "Título de la tarea",
                            systemImage: "textformat",
                            text: $title
                        )

                        VStack(alignment: .leading, spacing: 10) {
                            Label(
                                "Descripción",
                                systemImage: "text.alignleft"
                            )
                            .foregroundStyle(AppColors.primary)
                            .fontWeight(.semibold)

                            TextEditor(text: $description)
                                .frame(minHeight: 150)
                                .padding(10)
                                .scrollContentBackground(.hidden)
                                .background(AppColors.fieldBackground)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 14)
                                )
                        }

                        if task != nil {
                            Toggle(
                                "Tarea completada",
                                isOn: $isCompleted
                            )
                            .tint(AppColors.primary)
                        }
                    }
                    .padding()
                    .background(AppColors.cardBackground)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 22)
                    )

                    PrimaryButton(
                        title: task == nil
                        ? "Guardar tarea"
                        : "Actualizar tarea",
                        systemImage: task == nil
                        ? "checkmark.circle.fill"
                        : "arrow.triangle.2.circlepath"
                    ) {
                        saveTask()
                    }
                }
                .padding()
            }

            if taskViewModel.isLoading {
                LoadingView(
                    message: task == nil
                    ? "Guardando tarea..."
                    : "Actualizando tarea..."
                )
            }
        }
        .navigationTitle(task == nil ? "Nueva tarea" : "Editar tarea")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancelar") {
                    dismiss()
                }
            }
        }
        .alert(
            "Aviso",
            isPresented: $taskViewModel.showError
        ) {
            Button("Aceptar") {
                taskViewModel.clearError()
            }
        } message: {
            Text(taskViewModel.errorMessage)
        }
    }

    private func saveTask() {
        Task {
            let wasSaved: Bool

            if let task {
                wasSaved = await taskViewModel.updateTask(
                    task,
                    title: title,
                    description: description,
                    isCompleted: isCompleted
                )
            } else {
                wasSaved = await taskViewModel.createTask(
                    title: title,
                    description: description
                )
            }

            if wasSaved {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        TaskFormView()
            .environmentObject(TaskViewModel())
    }
}
