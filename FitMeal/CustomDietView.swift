//
//  CustomDietView.swift
//  FitMeal
//
//  Created by 이수겸 on 10/1/24.
//

import SwiftUI

struct CustomDietView: View {
    @State private var selectedFoods: [String] = []
    @State private var foodOptions: [String] = ["사과", "바나나", "닭가슴살", "고구마", "브로콜리"]
    
    var body: some View {
        VStack {
            Text("나만의 식단 구성")
                .font(.headline)
                .padding()
            
            List(foodOptions, id: \.self) { food in
                Button(action: {
                    if selectedFoods.contains(food) {
                        selectedFoods.removeAll { $0 == food }
                    } else {
                        selectedFoods.append(food)
                    }
                }) {
                    HStack {
                        Text(food)
                        Spacer()
                        if selectedFoods.contains(food) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            
            Spacer()
            
            Text("선택한 음식: \(selectedFoods.joined(separator: ", "))")
                .padding()
            
            Button(action: {
                // 선택한 음식을 기반으로 식단을 계산하는 로직을 구현
            }) {
                Text("식단 계산하기")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("나만의 식단 계산")
    }
}


