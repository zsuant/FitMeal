//
//  Untitled.swift
//  FitMeal
//
//  Created by 이수겸 on 10/1/24.
//

import SwiftUI

struct FoodNutritionalInfoView: View {
    @State private var searchQuery: String = ""
    @State private var foodResults: [String] = ["사과 - 52 kcal", "바나나 - 96 kcal", "닭가슴살 - 165 kcal"]
    
    var body: some View {
        VStack {
            Text("음식 영양성분 검색")
                .font(.headline)
                .padding()
            
            TextField("음식 검색", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List(foodResults.filter { searchQuery.isEmpty || $0.lowercased().contains(searchQuery.lowercased()) }, id: \.self) { result in
                Text(result)
            }
            
            Spacer()
        }
        .navigationTitle("음식 영양성분 확인")
    }
}
