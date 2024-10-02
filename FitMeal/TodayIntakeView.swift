//
//  TodayIntakeView.swift
//  FitMeal
//
//  Created by 이수겸 on 10/1/24.
//

import SwiftUI

struct TodayIntakeView: View {
    @State private var intakeData: [String] = ["사과 - 95 kcal", "바나나 - 105 kcal", "닭가슴살 - 165 kcal"]
    
    var body: some View {
        VStack {
            Text("오늘 섭취한 음식")
                .font(.headline)
                .padding()
            
            List(intakeData, id: \.self) { item in
                Text(item)
            }
            
            Spacer()
        }
        .navigationTitle("오늘 섭취 데이터")
    }
}
