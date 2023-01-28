//
//  styles.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import Foundation
import SwiftUI

extension Button {
    func withActionButtonStyles() -> some View {
        self.foregroundColor(.white)
            .font(Font.body.bold())
            .padding(10)
            .padding(.horizontal, 20)
            .background(Color.blue)
            .cornerRadius(10)
    }
}

extension Text {
    func withTitleStyles() -> some View {
        self.font(.title).fontWeight(.bold).padding(20)
    }
}
