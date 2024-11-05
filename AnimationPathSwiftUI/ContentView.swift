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
    private let numberOfPetals = 8
    private let colors: [Color] = [Color(red: 0.3, green: 0.1, blue: 0.4, opacity: 0.1), Color(red: 0.3, green: 0.1, blue: 0.4, opacity: 0.1), Color(red: 0.3, green: 0.1, blue: 0.4, opacity: 0.1), Color(red: 0.3, green: 0.1, blue: 0.4, opacity: 0.1)]
    
    var body: some View {
        ZStack {
            // Стебель
            StemShape(stemOffset: stemOffset)
                .stroke(Color.green, lineWidth: 3)
                .frame(width: 100, height: 200)
                .offset(y: 30)
            
            // Цветок
            ZStack {
                ForEach(0..<numberOfPetals, id: \.self) { index in
                    PetalShape()
                        .fill(colors[index % colors.count])
                        .frame(width: 60, height: 100)
                        .rotationEffect(.degrees(Double(index) * 360.0 / Double(numberOfPetals)))
                        .offset(y: 15)
                }
            }
            .offset(x: stemOffset, y: -100) // Добавили смещение по x
        }
        .onAppear {
            // Анимация раскачивания
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                stemOffset = 15
            }
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 300, height: 300)
}
