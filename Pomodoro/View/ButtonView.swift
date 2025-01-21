//
//  ButtonView.swift
//  Pomodoro
//
//  Created by Haris Alicic on 21. 1. 2025..
//

import SwiftUI

struct ButtonView: View {
    var buttonText: String = ""
    var buttonColor: Color = Color.blue
    var disabled: Bool = false
    var buttonAction: () -> Void
    
    var body: some View {
        Button(action: buttonAction) {
            Text(buttonText)
                .font(.system(size: 18, weight: .medium, design: .default))
                .padding()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(buttonColor)
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(disabled)
    }
    
}

#Preview {
    ButtonView(buttonText: "Start", buttonColor: Color.blue, disabled: false, buttonAction: {
        print("Button clicked!!!")
    })
}
