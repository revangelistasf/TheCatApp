//
//  StateViewModifier.swift
//  TheCatApp
//
//  Created by revangelista on 07/05/2024.
//

import SwiftUI

struct StateViewModifier<StateContentView: View>: ViewModifier {
    var shouldShowState: Bool
    let stateContentView: () -> StateContentView

    func body(content: Content) -> some View {
        if shouldShowState {
            stateContentView()
        } else {
            content
        }
    }
}

extension View {
    func stateView<StateContentView: View>(
        shouldShowState: Bool,
        stateContentView: @escaping () -> StateContentView
    ) -> some View {
        modifier(StateViewModifier(shouldShowState: shouldShowState, stateContentView: stateContentView))
    }
}
