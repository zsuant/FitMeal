import SwiftUI

struct MeasureFoodView: View {
    @State private var searchQuery: String = ""
    @State private var foodResults: [FoodItem] = []
    @State private var selectedCategory: String = "01"
    @State private var isLoading: Bool = false
    @State private var cachedResults: [String: [FoodItem]] = [:]

    // Store meals by date and meal type
    @State private var meals: [String: [String: [(String, [String: Double])]]] = [:]
    @State private var selectedMealType: String = "아침" // Default selected meal type
    private let mealTypes = ["아침", "점심", "저녁"]

    var body: some View {
        NavigationView {
            VStack {
                mealTypePicker

                searchField

                categorySelection

                if isLoading {
                    ProgressView("로딩 중...")
                } else {
                    foodResultsList
                }
            }
            .navigationTitle("영양성분 측정")
            .navigationBarBackButtonHidden(true) // Hide default back button
            .padding(.bottom, 10)
            .onAppear {
                setDefaultMealTypeBasedOnTime()
                loadInitialFoodData()
            }
        }
    }

    // MARK: - View Components

    private var mealTypePicker: some View {
        Picker("식사 선택", selection: $selectedMealType) {
            ForEach(mealTypes, id: \.self) { mealType in
                Text(mealType).tag(mealType)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }

    private var searchField: some View {
        TextField("음식 검색", text: $searchQuery)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onChange(of: searchQuery) { _ in
                filterFoodResults()
            }
    }

    private var categorySelection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(FoodAPI.categories, id: \.code) { category in
                    Button(action: {
                        selectedCategory = category.code
                        if let cached = cachedResults[category.code] {
                            foodResults = cached
                        } else {
                            fetchFoodNutritionalInfo()
                        }
                    }) {
                        Text(category.name)
                            .padding()
                            .background(selectedCategory == category.code ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private var foodResultsList: some View {
        List(foodResults, id: \.foodName) { item in
            NavigationLink(destination: WeightInputView(item: item, onAddToMeal: addToMeal)) {
                FoodItemView(item: item)
            }
        }
        .listStyle(PlainListStyle())
    }

    // MARK: - Functions

    private func setDefaultMealTypeBasedOnTime() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<11:
            selectedMealType = "아침" // Morning
        case 11..<17:
            selectedMealType = "점심" // Lunch
        default:
            selectedMealType = "저녁" // Dinner
        }
    }

    private func loadInitialFoodData() {
        if cachedResults[selectedCategory] == nil {
            fetchFoodNutritionalInfo()
        } else {
            foodResults = cachedResults[selectedCategory]!
        }
    }

    private func fetchFoodNutritionalInfo() {
        isLoading = true
        FoodAPI.fetchFoodNutritionalInfo(for: selectedCategory) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let items):
                    self.foodResults = items
                    self.cachedResults[self.selectedCategory] = items
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }
        }
    }

    private func filterFoodResults() {
        if searchQuery.isEmpty {
            foodResults = cachedResults[selectedCategory] ?? []
        } else {
            foodResults = (cachedResults[selectedCategory] ?? []).filter {
                $0.foodName.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }

    private func addToMeal(foodName: String, nutrients: [String: Double]) {
        let dateKey = formatDate(date: Date())

        if meals[dateKey] == nil {
            meals[dateKey] = [:]
        }

        if meals[dateKey]?[selectedMealType] == nil {
            meals[dateKey]?[selectedMealType] = []
        }

        meals[dateKey]?[selectedMealType]?.append((foodName, nutrients))
        print("Added \(foodName) to \(selectedMealType) for \(dateKey) with nutrients: \(nutrients)")
    }

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
