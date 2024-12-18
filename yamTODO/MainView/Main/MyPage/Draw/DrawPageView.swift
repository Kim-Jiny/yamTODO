//
//  DrawPageView.swift
//  yamTODO
//
//  Created by 김미진 on 12/18/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseDatabase

struct RewardProduct: Identifiable {
    let id: String
    let title: String
    let image: String
    let requiredCoins: Int
    let remainingQuantity: Int // 남은 수량
    let deadline: Date  // 응모 마감 날짜
    let resultAnnouncementDate: Date  // 결과 발표 날짜
    var applyCount: Int // 응모 여부
    var winnerUUID: String
}


struct DrawPageView: View {
    @State private var selectedTab: Int = 0
    @State private var userCoins = 0
    @State private var showPopup: Bool = false
    @State private var popupMessage: String = ""
    @State private var showClaimButton: Bool = false
    @State private var selectedProduct: RewardProduct? = nil
    
    func fetchUserData() {
        fetchUserData(userID: getUUID()) { result in
            switch result {
            case .success(let data):
                userCoins = data.coins
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
    
    let products: [RewardProduct] = [
        RewardProduct(
            id: "test",
            title: "스타벅스 금액권 [10,000원]",
            image: "https://search.pstatic.net/common/?src=http%3A%2F%2Fcafefiles.naver.net%2FMjAxOTA4MThfMTY3%2FMDAxNTY2MTE1MjIyNTE4.QEFIseep0-EdNRjWJ8BRdm1BWX-qBX62d--VdUoDrX8g.V5XFDPYbmw4hDw94TMaNyVuXU3YUba7keaOB8vopWkwg.JPEG%2Fnv_1566115218296.jpg&type=sc960_832",
            requiredCoins: 1,
            remainingQuantity: 10,
            deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date())!, // 3일 후 마감
            resultAnnouncementDate: Calendar.current.date(byAdding: .day, value: 10, to: Date())!, // 3일 후 마감
            applyCount: 0,
            winnerUUID: ""
        ),
        RewardProduct(
            id: "1",
            title: "메가커피 금액권 [10,000원]",
            image: "https://search.pstatic.net/common/?src=http%3A%2F%2Fshop1.phinf.naver.net%2F20190910_110%2F1568078412445Lf8y0_JPEG%2FsWZ5RAF5Ad.jpeg&type=sc960_832",
            requiredCoins: 1,
            remainingQuantity: 0,
            deadline: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, // 1일 전 마감
            resultAnnouncementDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            applyCount: 1, // 응모 완료
            winnerUUID: ""
        ),
        RewardProduct(
            id: "2",
            title: "메가커피 금액권 [10,000원]",
            image: "https://search.pstatic.net/common/?src=http%3A%2F%2Fshop1.phinf.naver.net%2F20190910_110%2F1568078412445Lf8y0_JPEG%2FsWZ5RAF5Ad.jpeg&type=sc960_832",
            requiredCoins: 1,
            remainingQuantity: 0,
            deadline: Calendar.current.date(byAdding: .day, value: -15, to: Date())!, // 1일 전 마감
            resultAnnouncementDate: Calendar.current.date(byAdding: .day, value: -8, to: Date())!,
            applyCount: 2, // 응모 완료
            winnerUUID: "1C999805-321A-41B5-AE31-5491C17478FD"
        ),
        RewardProduct(
            id: "3",
            title: "스타벅스 금액권 [10,000원]",
            image: "https://search.pstatic.net/common/?src=http%3A%2F%2Fcafefiles.naver.net%2FMjAxOTA4MThfMTY3%2FMDAxNTY2MTE1MjIyNTE4.QEFIseep0-EdNRjWJ8BRdm1BWX-qBX62d--VdUoDrX8g.V5XFDPYbmw4hDw94TMaNyVuXU3YUba7keaOB8vopWkwg.JPEG%2Fnv_1566115218296.jpg&type=sc960_832",
            requiredCoins: 1,
            remainingQuantity: 10,
            deadline: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, // 3일 후 마감
            resultAnnouncementDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, // 3일 후 마감
            applyCount: 2,
            winnerUUID: ""
        ),
        RewardProduct(
            id: "4",
            title: "메가커피 금액권 [10,000원]",
            image: "https://search.pstatic.net/common/?src=http%3A%2F%2Fshop1.phinf.naver.net%2F20190910_110%2F1568078412445Lf8y0_JPEG%2FsWZ5RAF5Ad.jpeg&type=sc960_832",
            requiredCoins: 1,
            remainingQuantity: 0,
            deadline: Calendar.current.date(byAdding: .day, value: -15, to: Date())!, // 1일 전 마감
            resultAnnouncementDate: Calendar.current.date(byAdding: .day, value: -8, to: Date())!,
            applyCount: 0, // 응모 완료
            winnerUUID: "1C999805-321A-41B5-AE31"
        )
    ]
    
    var body: some View {
        VStack {
            Picker("Select Tab", selection: $selectedTab) {
                Text("응모하기").tag(0)
                Text("당첨된 응모내역").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())

            HStack {
                Image(systemName: "creditcard.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.yellow)
                    .padding(.leading, 16)
                
                Text("내 얌코인")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(userCoins) 개")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.trailing, 16)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            if selectedTab == 0 {
                List(products) { product in
                    RewardProductView(product: product) { selectedProduct in
                        handleButtonAction(for: selectedProduct)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle()) // 심플 리스트 스타일
            }

            if showPopup {
                RewardPopupView(
                    message: popupMessage,
                    showClaimButton: showClaimButton,
                    onClaimAction: {
                        claimProduct()
                    },
                    onDismissAction: {
                        dismissPopup()
                    }
                )
            }
        }
        .onAppear(perform: fetchUserData)
    }

    private func handleButtonAction(for product: RewardProduct) {
        if product.deadline < Date() {
            if product.winnerUUID == getUUID() {
                showPopup(message: "축하합니다! \(product.title)에 당첨되었습니다.", showClaimButton: true)
            } else {
                showPopup(message: "다음 기회에...")
            }
        } else {
            // 응모 버튼 로직
            print("응모 버튼 클릭됨")
            userCoins = userCoins - product.requiredCoins
            applyForReward(productID: product.id, requiredCoins: product.requiredCoins) { result in
                switch result {
                case .success(let success):
                    showPopup(message: "응모 완료되었습니다.")
                case .failure(let failure):
                    showPopup(message: "응모에 실패했습니다.")
                }
            }
        }
    }

    private func showPopup(message: String, showClaimButton: Bool = false) {
        self.popupMessage = message
        self.showClaimButton = showClaimButton
        self.showPopup = true
    }

    private func dismissPopup() {
        self.showPopup = false
    }

    private func claimProduct() {
        dismissPopup()
        // 상품 수령 로직
        print("상품 수령 로직")
    }

    private func getUUID() -> String {
        let userDefaults = UserDefaults.standard
        let uuidKey = "userUUID"
        return userDefaults.string(forKey: uuidKey) ?? "unknown"
    }
    
    func fetchUserData(userID: String, completion: @escaping (Result<(coins: Int, appliedProductIDs: [String]), Error>) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("reward").document(userID)
        let userApplicationsRef = db.collection("yamRewardHistory").document(userID)
        
        // 병렬로 데이터를 읽기 위해 DispatchGroup 사용
        let dispatchGroup = DispatchGroup()
        
        var userCoins: Int = 0
        var appliedProductIDs: [String] = []
        var fetchError: Error?
        
        // Fetch user coins
        dispatchGroup.enter()
        userRef.getDocument { document, error in
            if let error = error {
                fetchError = error
            } else if let data = document?.data(), let coins = data["coin"] as? Int {
                userCoins = coins
            } else {
                fetchError = NSError(domain: "FetchUserData", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user coins."])
            }
            dispatchGroup.leave()
        }
        
        // Fetch applied product IDs
        dispatchGroup.enter()
        userApplicationsRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                appliedProductIDs = data?.keys.map { $0 } ?? []
            } else {
                appliedProductIDs = []
            }
            dispatchGroup.leave()
        }
        
        // Notify when all data is fetched
        dispatchGroup.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                completion(.success((coins: userCoins, appliedProductIDs: appliedProductIDs)))
            }
        }
    }

    func applyForReward(productID: String, requiredCoins: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("reward").document(getUUID())
        let rewardProductRef = db.collection("rewardProducts").document(productID)
        let userApplicationRef = db.collection("yamRewardHistory").document(getUUID()).collection(productID).document("yamReward")
        
        // 사용자 데이터 참조
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userData = document?.data(), let coins = userData["coin"] as? Int, coins >= requiredCoins else {
                completion(.failure(NSError(domain: "InsufficientCoins", code: 1, userInfo: [NSLocalizedDescriptionKey: "Not enough coins"])))
                return
            }
            
            // 코인 차감
            userRef.updateData([
                "coin": coins - requiredCoins
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // 보상 상품 적용 수 증가
                rewardProductRef.updateData([
                    "applyCount": FieldValue.increment(Int64(1))
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    // 사용자 신청 횟수 증가 및 yamRewardHistory 생성
                    // 최초 데이터 설정 및 업데이트
                    userApplicationRef.getDocument { document, error in
                        if let error = error {
                            completion(.failure(error))
                        } else if let document = document, !document.exists {
                            // 문서가 존재하지 않을 때 초기 데이터 추가
                            let initialData: [String: Any] = [
                                "applyCount": 1,
                                "latestUpdate": Timestamp()
                            ]
                            userApplicationRef.setData(initialData) { error in
                                if let error = error {
                                    completion(.failure(error))
                                } else {
                                    completion(.success(()))
                                }
                            }
                        } else {
                            // 기존 문서가 존재할 때 applyCount 증가 및 최신화
                            userApplicationRef.updateData([
                                "applyCount": FieldValue.increment(Int64(1)),
                                "latestUpdate": Timestamp()
                            ]) { error in
                                if let error = error {
                                    completion(.failure(error))
                                } else {
                                    completion(.success(()))
                                }
                            }
                        }
                    }

                }
            }
        }
    }


    
}


extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "MM월 dd일 a h시" // 월/일 및 오전/오후 시간 형식
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 형식
        return formatter
    }
    
    static var shortResultDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "MM월 dd일" // 년/월/일 형식
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 형식
        return formatter
    }
}
