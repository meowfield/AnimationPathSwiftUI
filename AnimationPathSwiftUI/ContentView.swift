//
//  ContentView.swift
//  AnimationPathSwiftUI
//
//  Created by Данис Гаязов on 4.11.24..
//

import SwiftUI

struct PetalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: width * 0.5, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: height),
            control: CGPoint(x: width, y: height * 0.5)
        )
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: 0),
            control: CGPoint(x: 0, y: height * 0.5)
        )
        return path
    }
}

struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: height * 0.5))
        path.addQuadCurve(
            to: CGPoint(x: width, y: 0),
            control: CGPoint(x: width * 0.3, y: 0)
        )
        path.addQuadCurve(
            to: CGPoint(x: 0, y: height * 0.5),
            control: CGPoint(x: width * 0.3, y: height)
        )
        return path
    }
}

struct StemShape: Shape {
    var stemOffset: CGFloat
    
    var animatableData: CGFloat {
        get { stemOffset }
        set { stemOffset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width / 2, y: height))
        path.addQuadCurve(
            to: CGPoint(x: width / 2 + stemOffset, y: 0),
            control: CGPoint(x: width / 2 + stemOffset * 1.5, y: height * 0.6)
        )
        
        return path
    }
}

struct ContentView: View {
    @State private var isAnimating = false
    @State private var stemOffset: CGFloat = 0
    @State private var leafScale: CGFloat = 0.1
    private let numberOfPetals = 8
    private let colors: [Color] = [Color(red: 0.3, green: 0.1, blue: 0.4, opacity: 0.1), Color(red: 0.1, green: 0.1, blue: 0.7, opacity: 0.1), Color(red: 0.9, green: 0.1, blue: 0.4, opacity: 0.1), Color(red: 0.3, green: 0.9, blue: 0.4, opacity: 0.1)]
    
    var body: some View {
        ZStack {
                // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.95, blue: 0.9),
                    Color(red: 0.95, green: 0.85, blue: 0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .shadow(color: .brown, radius: 15, x: 10, y: 0)
            ZStack {
                
                // Stem
                StemShape(stemOffset: stemOffset)
                    .stroke(Color.green, lineWidth: 3)
                    .frame(width: 100, height: 200)
                    .offset(y: 30)
                
                // Leaf
                LeafShape()
                    .fill(Color.green)
                    .frame(width: 40, height: 30)
                    .rotationEffect(.degrees(50))
                    .offset(x: stemOffset - 24, y: 50)
                    
                
                // Flower
                ZStack {
                    ForEach(0..<numberOfPetals, id: \.self) { index in
                        PetalShape()
                            .fill(colors[index % colors.count])
                            .frame(width: 60, height: 100)
                            .rotationEffect(.degrees(Double(index) * 360.0 / Double(numberOfPetals)))
                            .offset(y: 15)
                    }
                }
                .offset(x: stemOffset, y: -100)
            }
            .onAppear {
                
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    stemOffset = 15
                }
                withAnimation(.easeInOut(duration: 1.5)) {
                    leafScale = 1
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 300, height: 300)
}
