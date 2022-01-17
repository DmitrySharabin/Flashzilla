//
//  ContentView.swift
//  Flashzilla
//
//  Created by Dmitry Sharabin on 16.01.2022.
//

import SwiftUI

func withOptionalAnimation<Result>(_ animation: Animation? = .default, body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}

struct ContentView: View {
//    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
//    @Environment(\.accessibilityReduceMotion) var reduceMotion
//    @State private var scale = 1.0
    
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    var body: some View {
//        HStack {
//            if differentiateWithoutColor {
//                Image(systemName: "checkmark.circle")
//            }
//
//            Text("Success")
//        }
//        .padding()
//        .background(differentiateWithoutColor ? .black : .green)
//        .foregroundColor(.white)
//        .clipShape(Capsule())
        
//        Text("Hello, World!")
//            .scaleEffect(scale)
//            .onTapGesture {
////                if reduceMotion {
////                    scale *= 1.5
////                } else {
//                    withAnimation {
////                        scale *= 1.5
////                    }
////                }
//                withOptionalAnimation {
//                    scale *= 1.5
//                }
//            }
        
        Text("Hello, World!")
            .padding()
            .background(reduceTransparency ? .black: .black.opacity(0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
