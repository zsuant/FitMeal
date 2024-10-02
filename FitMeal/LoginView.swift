import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @Binding var isLoggedIn: Bool // 바인딩 변수

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text("로그인")
                .font(.largeTitle)
                .padding()

            TextField("이메일", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("비밀번호", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button(action: {
                loginUser()
            }) {
                Text("로그인")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            NavigationLink(destination: SignUpView(isLoggedIn: $isLoggedIn), label: {
                Text("회원가입")
                    .foregroundColor(.blue)
            })
            .padding()
        }
        .padding()
    }

    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.isLoggedIn = true // 로그인 성공 시 홈페이지로 이동
        }
    }
}
