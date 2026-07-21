//
//  TaskViewModel.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import Foundation
import Combine
@MainActor
final class TaskViewModel: ObservableObject {

    @Published var tasks: [TaskItem] = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false

    private let firebaseService = FirebaseService.shared

    // MARK: - Obtener tareas

    func fetchTasks() async {

        isLoading = true
        clearError()

        do {
            tasks = try await firebaseService.fetchTasks()
        } catch {
            handleError(error)
        }

        isLoading = false
    }

    // MARK: - Crear tarea

    func createTask(
        title: String,
        description: String
    ) async -> Bool {

        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanDescription = description.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanTitle.isEmpty else {
            showValidationError("Ingresa el título de la tarea.")
            return false
        }

        guard !cleanDescription.isEmpty else {
            showValidationError("Ingresa la descripción de la tarea.")
            return false
        }

        isLoading = true
        clearError()

        let newTask = TaskItem(
            title: cleanTitle,
            description: cleanDescription,
            isCompleted: false,
            createdAt: Date()
        )

        do {
            try await firebaseService.createTask(newTask)
            await fetchTasks()
            return true

        } catch {
            handleError(error)
            isLoading = false
            return false
        }
    }

    // MARK: - Actualizar tarea

    func updateTask(
        _ task: TaskItem,
        title: String,
        description: String,
        isCompleted: Bool
    ) async -> Bool {

        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanDescription = description.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanTitle.isEmpty else {
            showValidationError("Ingresa el título de la tarea.")
            return false
        }

        guard !cleanDescription.isEmpty else {
            showValidationError("Ingresa la descripción de la tarea.")
            return false
        }

        isLoading = true
        clearError()

        var updatedTask = task
        updatedTask.title = cleanTitle
        updatedTask.description = cleanDescription
        updatedTask.isCompleted = isCompleted

        do {
            try await firebaseService.updateTask(updatedTask)
            await fetchTasks()
            return true

        } catch {
            handleError(error)
            isLoading = false
            return false
        }
    }

    // MARK: - Cambiar estado

    func toggleCompletion(_ task: TaskItem) async {

        var updatedTask = task
        updatedTask.isCompleted.toggle()

        do {
            try await firebaseService.updateTask(updatedTask)
            await fetchTasks()
        } catch {
            handleError(error)
        }
    }

    // MARK: - Eliminar tarea

    func deleteTask(_ task: TaskItem) async {

        isLoading = true
        clearError()

        do {
            try await firebaseService.deleteTask(task)
            await fetchTasks()
        } catch {
            handleError(error)
        }

        isLoading = false
    }

    // MARK: - Manejo de errores

    private func showValidationError(_ message: String) {
        errorMessage = message
        showError = true
    }

    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }

    func clearError() {
        errorMessage = ""
        showError = false
    }
}
