//
//  MyPageView.swift
//  FitMeal
//
//  Created by 이수겸 on 10/1/24.
//

import SwiftUI
import FirebaseFirestore

struct MyPageView: View {
    @State private var name: String = "홍길동"
    @State private var age: String = "25"
    @State private var showingAlert = false

    // Firestore 인스턴스
    let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("프로필 정보")) {
                    HStack {
                        Text("이름")
                        Spacer()
                        TextField("이름 입력", text: $name)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    HStack {
                        Text("나이")
                        Spacer()
                        TextField("나이 입력", text: $age)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .onReceive(age.publisher.collect()) {
                                self.age = String($0.prefix(3).filter { "0123456789".contains($0) })
                            }
                    }
                }
                
                Section {
                    Button(action: {
                        hideKeyboard()
                        saveProfile() // Firestore에 프로필 저장
                    }) {
                        Text("프로필 수정 저장")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.blue)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("프로필 저장됨"), message: Text("프로필 정보가 성공적으로 저장되었습니다."), dismissButton: .default(Text("확인")))
                    }
                }
            }
            .navigationTitle("My Page")
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // Firestore에 프로필을 저장하는 함수
    private func saveProfile() {
        if !name.isEmpty && !age.isEmpty {
            let userData = ["name": name, "age": age]
            db.collection("users").document("userProfile").setData(userData) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    showingAlert = true
                }
            }
        } else {
            print("입력 값이 비어있습니다.")
        }
    }
}
