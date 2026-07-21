//
//  TaskListView.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import SwiftUI

struct TaskListView: View {

    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var taskViewModel: TaskViewModel

    @State private var showTaskForm = false
    @State private var taskToDelete: TaskItem?

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            Group {
                if taskViewModel.tasks.isEmpty && !taskViewModel.isLoading {
                    EmptyState(
                        title: "No hay tareas",
                        message: "Presiona el botón + para agregar tu primera tarea.",
                        systemImage: "checklist"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(taskViewModel.tasks) { task in
                                NavigationLink {
                                    TaskDetailView(task: task)
                                } label: {
                                    TaskCard(
                                        title: task.title,
                                        description: task.description,
                                        isCompleted: task.isCompleted
                                    )
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button {
                                        Task {
                                            await taskViewModel.toggleCompletion(task)
                                        }
                                    } label: {
                                        Label(
                                            task.isCompleted
                                            ? "Marcar como pendiente"
                                            : "Marcar como completada",
                                            systemImage: task.isCompleted
                                            ? "circle"
                                            : "checkmark.circle"
                                        )
                                    }

                                    Button(role: .destructive) {
                                        taskToDelete = task
                                    } label: {
                                        Label(
                                            "Eliminar",
                                            systemImage: "trash"
                                        )
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await taskViewModel.fetchTasks()
                    }
                }
            }

            if taskViewModel.isLoading {
                LoadingView(message: "Cargando tareas...")
            }
        }
        .navigationTitle("Mis tareas")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    authViewModel.logout()
                } label: {
                    Label(
                        "Salir",
                        systemImage: "rectangle.portrait.and.arrow.right"
                    )
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showTaskForm = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
        }
        .sheet(isPresented: $showTaskForm) {
            NavigationStack {
                TaskFormView()
            }
            .environmentObject(taskViewModel)
        }
        .alert(
            "Eliminar tarea",
            isPresented: Binding(
                get: { taskToDelete != nil },
                set: { newValue in
                    if !newValue {
                        taskToDelete = nil
                    }
                }
            )
        ) {
            Button("Cancelar", role: .cancel) {
                taskToDelete = nil
            }

            Button("Eliminar", role: .destructive) {
                guard let task = taskToDelete else {
                    return
                }

                Task {
                    await taskViewModel.deleteTask(task)
                    taskToDelete = nil
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
        .task {
            await taskViewModel.fetchTasks()
        }
    }
}

#Preview {
    NavigationStack {
        TaskListView()
            .environmentObject(AuthViewModel())
            .environmentObject(TaskViewModel())
    }
}
