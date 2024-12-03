import SwiftUI
import FirebaseFirestore

struct InquiryMainView: View {
    var body: some View {
        VStack {
            Form {
                // 새 문의하기 버튼
                NavigationLink(destination: NewInquiryView()) {
                    Text("새 문의하기")
                }

                // 내 문의 리스트 버튼
                NavigationLink(destination: MyInquiriesView()) {
                    Text("내 문의 리스트")
                }
            }
        }
    }
}
struct NewInquiryView: View {
    @State private var inquiryText: String = ""  // 입력된 텍스트 저장
    @State private var showSuccessMessage = false
    @State private var showErrorMessage = false  // 에러 메시지 표시 여부
    @State private var isSubmitting = false  // 제출 중 여부를 나타내는 변수
    @Environment(\.presentationMode) private var presentationMode  // 현재 뷰를 닫기 위한 환경 변수

    var body: some View {
        VStack {
            Text("문의하기")
                .font(.largeTitle)
                .padding()

            ZStack(alignment: .center) {
                // TextEditor로 텍스트 입력 영역
                TextEditor(text: $inquiryText)
                    .frame(height: 200)  // 텍스트 뷰의 높이를 설정하여 크기 조정
                    .cornerRadius(10)
                    .border(Color.gray, width: 1)  // 테두리 추가
                    .padding()
                
                // placeholder 텍스트
                if inquiryText.isEmpty {
                    Text("문의 내용을 입력해주세요.")
                        .foregroundColor(.gray)
                }
            }

            // 제출 버튼
            Button("문의 제출") {
                submitInquiry()
            }
            .padding()
            .foregroundColor(.white)
            .background(inquiryText.isEmpty ? Color.gray : Color.yamBlue)
            .cornerRadius(10)
            .padding([.leading, .trailing])
            .disabled(isSubmitting || inquiryText.isEmpty)  // 제출 중이거나 텍스트가 비어 있으면 버튼 비활성화
            
            .alert("문의가 제출되었습니다!", isPresented: $showSuccessMessage) {
                Button("확인") {
                    presentationMode.wrappedValue.dismiss() // 확인 버튼을 누르면 화면 닫기
                }
            }
            
            .alert("문의 내용을 입력해주세요.", isPresented: $showErrorMessage) {
                Button("확인", role: .cancel) {}
            }
        }
        .padding()
    }
    
    // Firebase에 문의 데이터 제출
    func submitInquiry() {
        // 입력값에서 공백 제거 후 확인
        let trimmedText = inquiryText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            showErrorMessage = true  // 공백만 입력되었을 때 에러 메시지 표시
            return
        }
        
        isSubmitting = true  // 제출 중으로 상태 변경

        let userId = getUserId()

        let inquiryData: [String: Any] = [
            "userId": userId,
            "inquiryText": inquiryText,
            "comment": "",  // 초기 값은 빈 값
            "timestamp": Timestamp(),  // 문의 제출 시간 저장
            "isRemove": false,
            "userPushToken": getAPNSToken()
        ]
        let db = Firestore.firestore()
        
        db.collection("inquiries")
            .addDocument(data: inquiryData) { error in
                isSubmitting = false  // 제출 완료 후 상태 변경
                
                if let error = error {
                    print("Error adding inquiry: \(error)")
                } else {
                    showSuccessMessage = true
                    inquiryText = ""  // 제출 후 입력창 초기화
                }
            }
    }
}

struct MyInquiriesView: View {
    @State private var inquiries: [Inquiry] = []  // 문의 내역 저장

    var body: some View {
        VStack {
            Text("내가 문의한 내용")
                .font(.largeTitle)
                .padding()
            // 문의 내역이 비어있을 경우
            if inquiries.filter({ !$0.isRemove }).isEmpty {
                Text("문의 내역이 없습니다.")
                    .foregroundColor(.gray)
            } else {
                Text("문의 내역은 제출일로부터 6개월 후 자동 삭제될 수 있습니다.")
                    .font(.caption)
                
                // 문의 목록을 리스트로 표시
                List(inquiries.filter { !$0.isRemove }) { inquiry in  // isRemove가 false인 것만 필터링
                    NavigationLink(destination: InquiryDetailView(inquiry: inquiry)) {
                        HStack {
                            if !inquiry.comment.isEmpty {
                                Text("[답변완료] ") // 답변이 있으면 앞에 [답변완료] 추가
                                    .foregroundColor(.green)
                            }
                            Text(inquiry.inquiryText) // 문의 내용
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchInquiries()
        }
        .padding()
    }

    // Firebase에서 문의 내역 조회
    func fetchInquiries() {
        let userId = getUserId()
        let db = Firestore.firestore()
        
        db.collection("inquiries")
            .whereField("userId", isEqualTo: userId)  // 현재 로그인한 사용자 ID로 필터링
            .getDocuments { snapshot, error in
                if let error = error {
                    print("문의 리스트 불러오기 실패: \(error.localizedDescription)")
                } else {
                    inquiries = snapshot?.documents.compactMap { document -> Inquiry? in
                        try? document.data(as: Inquiry.self)
                    } ?? []
                }
            }
    }
}

struct InquiryDetailView: View {
    var inquiry: Inquiry  // 선택한 문의 데이터를 전달받음
    @Environment(\.presentationMode) private var presentationMode  // 현재 뷰를 닫기 위한 환경 변수
    @State private var showAlert = false  // 삭제 확인 알림을 보여줄 상태 변수
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 문의 제목 및 타임스탬프
            HStack {
                Text("내 문의")
                    .foregroundStyle(.gray)
                Spacer()
                Text("\(inquiry.timestamp, formatter: dateFormatter)")  // 시간 포맷팅
                    .foregroundStyle(.gray)
            }
            
            // 문의 내용
            Text(inquiry.inquiryText)  // 유저가 작성한 문의 내용
                .font(.body)
                .foregroundColor(.primary)
                .padding(.bottom, 10)

            // 답변 제목
            Text("답변 내용")
                .foregroundStyle(.gray)
                .font(.title2)
                .padding(.bottom, 5)

            // 답변 내용
            Text(inquiry.comment.isEmpty ? "문의를 확인하고 있습니다..." : inquiry.comment)  // 답변 내용
                .font(.body)
                .foregroundColor(inquiry.comment.isEmpty ? .secondary: .yamBlack)
                .padding(.bottom, 20)

            Spacer()

            // 삭제 버튼
            Button(action: {
                showAlert = true  // 삭제 확인 알림을 보여주기 위한 상태 설정
            }) {
                Text("문의 삭제")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("삭제 확인"),
                    message: Text("이 문의를 삭제하시겠습니까?"),
                    primaryButton: .destructive(Text("삭제")) {
                        removeInquiry()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationBarTitle("문의 상세", displayMode: .inline)
        .padding([.leading, .trailing], 18)
        .padding(.top, 16)
    }
    
    // Firebase에서 isRemove를 true로 설정하여 논리 삭제
    func removeInquiry() {
        guard let inquiryId = inquiry.id else { return }

        let db = Firestore.firestore()
        db.collection("inquiries").document(inquiryId).updateData([
            "isRemove": true
        ]) { error in
            if let error = error {
                print("문의 삭제 실패: \(error.localizedDescription)")
            } else {
                print("문의 삭제 완료")
                presentationMode.wrappedValue.dismiss()  // 삭제 후 뷰 닫기
            }
        }
    }
}


fileprivate func getUserId() -> String {
    let userDefaults = UserDefaults.standard
    let uuidKey = "userUUID"
    
    if userDefaults.string(forKey: uuidKey) == nil {
        let newUUID = UUID().uuidString
        userDefaults.set(newUUID, forKey: uuidKey)
        
        print("Generated new UUID: \(newUUID)")
        return newUUID
    } else if let storedUUID = userDefaults.string(forKey: uuidKey) {
        print("Existing UUID: \(storedUUID)")
        
        return storedUUID
    }
    
    return "unknown"
}

fileprivate func getAPNSToken() -> String {
    let userDefaults = UserDefaults.standard
    let tokenKey = "apnsToken"
    if let pushKey = userDefaults.string(forKey: tokenKey) {
        return pushKey
    }
    
    return "unknown"
}

// Inquiry 모델 정의
struct Inquiry: Identifiable, Codable {
    @DocumentID var id: String?  // Firestore 문서 ID
    var userId: String
    var inquiryText: String
    var timestamp: Date
    var comment: String  // 답변 내용
    var isRemove: Bool
}

// 날짜 포맷터
fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()


