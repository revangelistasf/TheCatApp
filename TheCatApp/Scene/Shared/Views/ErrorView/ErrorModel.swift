//
//  ErrorModel.swift
//  TheCatApp
//
//  Created by revangelista on 08/05/2024.
//

import SwiftUI

struct ErrorModel {
    let image: ImageResource
    let title: String
    var buttonTitle: String? = nil
    var action: (() -> Void)? = nil
}
