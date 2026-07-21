//
//  FirebaseService.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseService {

    static let shared = FirebaseService()

    private let auth = Auth.auth()
    private let database = Firestore.firestore()

    private init() {}

    // MARK: - Usuario actual

    var currentUserID: String? {
        auth.currentUser?.uid
    }

    var isUserAuthenticated: Bool {
        auth.currentUser != nil
    }

    // MARK: - Autenticación

    func register(
        email: String,
        password: String
    ) async throws {

        try await auth.createUser(
            withEmail: email,
            password: password
        )
    }

    func login(
        email: String,
        password: String
    ) async throws {

        try await auth.signIn(
            withEmail: email,
            password: password
        )
    }

    func logout() throws {
        try auth.signOut()
    }

    // MARK: - Referencia de tareas

    private func tasksCollection() throws -> CollectionReference {

        guard let userID = currentUserID else {
            throw FirebaseServiceError.userNotAuthenticated
        }

        return database
            .collection("users")
            .document(userID)
            .collection("tasks")
    }

    // MARK: - Crear tarea

    func createTask(_ task: TaskItem) async throws {

        let collection = try tasksCollection()
        let document = collection.document()

        try document.setData(from: task)
    }

    // MARK: - Obtener tareas

    func fetchTasks() async throws -> [TaskItem] {

        let collection = try tasksCollection()

        let snapshot = try await collection
            .order(by: "createdAt", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { document in
            try? document.data(as: TaskItem.self)
        }
    }

    // MARK: - Actualizar tarea

    func updateTask(_ task: TaskItem) async throws {

        guard let taskID = task.id else {
            throw FirebaseServiceError.invalidTaskID
        }

        let collection = try tasksCollection()

        try collection
            .document(taskID)
            .setData(from: task)
    }

    // MARK: - Eliminar tarea

    func deleteTask(_ task: TaskItem) async throws {

        guard let taskID = task.id else {
            throw FirebaseServiceError.invalidTaskID
        }

        let collection = try tasksCollection()

        try await collection
            .document(taskID)
            .delete()
    }
}

// MARK: - Errores personalizados

enum FirebaseServiceError: LocalizedError {

    case userNotAuthenticated
    case invalidTaskID

    var errorDescription: String? {

        switch self {

        case .userNotAuthenticated:
            return "No existe un usuario autenticado."

        case .invalidTaskID:
            return "La tarea no tiene un identificador válido."
        }
    }
}
