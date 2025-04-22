//
//  ViewState.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 22/04/25.
//

import Foundation

/// A generic enum to represent loading states in SwiftUI views
public enum ViewState<Value> {
    case idle
    case loading
    case success(Value)
    case error(String)
}
