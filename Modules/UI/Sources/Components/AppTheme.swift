//
//  AppTheme.swift
//  UI
//
//  Created by Matheus Martins on 23/04/25.
//

import SwiftUI

public struct AppTheme {
    public static let shared = AppTheme()

    public let colors: ThemeColors

    private init() {
        self.colors = ThemeColors()
    }
}

public struct ThemeColors {
    public var background: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1) :
                                               UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        })
    }

    public var primaryText: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? .white : .black
        })
    }

    public var secondaryText: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor.lightGray : UIColor.darkGray
        })
    }

    public let accent: Color = Color(red: 0.6, green: 0.2, blue: 0.8)
}
