//
//  TaskItem.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//

import Foundation
import FirebaseFirestore

struct TaskItem: Identifiable, Codable {

    @DocumentID var id: String?

    var title: String
    var description: String
    var isCompleted: Bool
    var createdAt: Date = Date()

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case isCompleted
        case createdAt
    }
}

