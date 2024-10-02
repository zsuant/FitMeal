//
//  MeasureFoodView.swift
//  FitMeal
//
//  Created by 이수겸 on 10/1/24.
//

import SwiftUI

struct MeasureFoodView: View {
    @State private var selectedFood: String = ""
    @State private var weight: Double = 0.0
    @State private var nutritionInfo: [String: Double] = [:]
    @State private var isFoodSelected: Bool = false

    let availableFoods = [
        "사과", "바나나", "닭가슴살", "부채살 스테이크", "토마토 파스타",
        "봉골레 파스타", "알리오 올리오 파스타", "치킨 텐더 샐러드",
        "코카콜라", "펩시콜라", "피클"
    ]
    
    // 각 음식의 영양 성분 (100g 기준)
    let nutritionalInfo: [String: (calories: Double, carbs: Double, sodium: Double, sugars: Double)] = [
        "사과": (78.0, 21.0, 1.0, 10.0),
        "바나나": (105.0, 27.0, 1.0, 14.0),
        "닭가슴살": (165.0, 0.0, 74.0, 0.0),
        "부채살 스테이크": (300.0, 0.0, 70.0, 0.0),
        "토마토 파스타": (220.0, 30.0, 500.0, 4.0),
        "봉골레 파스타": (250.0, 35.0, 600.0, 2.0),
        "알리오 올리오 파스타": (280.0, 40.0, 400.0, 2.0),
        "치킨 텐더 샐러드": (350.0, 20.0, 800.0, 5.0),
        "코카콜라": (140.0, 39.0, 40.0, 39.0),
        "펩시콜라": (150.0, 41.0, 30.0, 41.0),
        "피클": (11.0, 2.0, 800.0, 1.0)
    ]
    
    // 영양성분을 계산하는 함수
    func calculateNutrition(weight: Double, food: String) -> [String: Double] {
        guard let info = nutritionalInfo[food] else { return ["calories": 0.0, "carbs": 0.0, "sodium": 0.0, "sugars": 0.0] }
        
        // 실제 무게를 기준으로 비례 계산
        let calculatedCalories = (weight / 100.0) * info.calories
        let calculatedCarbs = (weight / 100.0) * info.carbs
        let calculatedSodium = (weight / 100.0) * info.sodium
        let calculatedSugars = (weight / 100.0) * info.sugars
        
        return ["calories": calculatedCalories, "carbs": calculatedCarbs, "sodium": calculatedSodium, "sugars": calculatedSugars]
    }

    var body: some View {
        VStack {
            Text("음식을 선택하세요")
                .font(.headline)
            
            Picker("음식", selection: $selectedFood) {
                ForEach(availableFoods, id: \.self) { food in
                    Text(food).tag(food)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            TextField("무게 (g)", value: $weight, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()
            
            Button("무게 측정 및 영양 성분 계산") {
                if !selectedFood.isEmpty && weight > 0 {
                    nutritionInfo = calculateNutrition(weight: weight, food: selectedFood)
                    isFoodSelected = true
                }
            }
            .padding()
            
            // 결과 표시 부분
            if isFoodSelected {
                VStack(alignment: .leading) {
                    Text("선택한 음식: \(selectedFood)")
                        .font(.title3)
                        .padding(.top)

                    Text("측정된 무게: \(weight, specifier: "%.2f") g")
                        .font(.subheadline)
                    Text("칼로리: \(nutritionInfo["calories"] ?? 0.0, specifier: "%.2f") kcal")
                        .font(.subheadline)
                    Text("탄수화물: \(nutritionInfo["carbs"] ?? 0.0, specifier: "%.2f") g")
                        .font(.subheadline)
                    Text("나트륨: \(nutritionInfo["sodium"] ?? 0.0, specifier: "%.2f") mg")
                        .font(.subheadline)
                    Text("당류: \(nutritionInfo["sugars"] ?? 0.0, specifier: "%.2f") g")
                        .font(.subheadline)
                }
                .padding()
            }
        }
        .navigationTitle("영양 성분 기록")
    }
}
