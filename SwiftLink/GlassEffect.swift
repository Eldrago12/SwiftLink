//
//  GlassEffect.swift
//  SwiftLink
//
//  Created by SIRSHAK DOLAI on 13/07/24.
//

import SwiftUI

struct GlassEffect: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
