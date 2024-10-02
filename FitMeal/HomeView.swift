//
//  HomeView.swift
//  FitMeal
//
//  Created by 이수겸 on 10/1/24.
//



import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: MeasureFoodView()) {
                    Text("음식 무게 측정 및 영양 성분 기록")
                }
                NavigationLink(destination: TodayIntakeView()) {
                    Text("오늘 섭취 데이터 보기")
                }
                NavigationLink(destination: CustomDietView()) {
                    Text("나만의 식단 계산하기")
                }
                NavigationLink(destination: FoodNutritionalInfoView()) {
                    Text("음식 별 영양성분 확인하기")
                }
            }
            .navigationTitle("Home")
        }
    }
}
