//
//  AppColors.swift
//  TaskControl
//
//  Created by Ariana on 20/07/26.
//
import SwiftUI

enum AppColors {
    static let primary = Color.indigo
    static let secondary = Color.blue
    static let accent = Color.cyan

    static let backgroundTop = Color.indigo.opacity(0.95)
    static let backgroundBottom = Color.blue.opacity(0.75)

    static let cardBackground = Color.white.opacity(0.96)
    static let fieldBackground = Color.gray.opacity(0.12)

    static let title = Color.primary
    static let subtitle = Color.secondary

    static let success = Color.green
    static let warning = Color.orange
    static let danger = Color.red

    static let gradient = LinearGradient(
        colors: [backgroundTop, backgroundBottom],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
