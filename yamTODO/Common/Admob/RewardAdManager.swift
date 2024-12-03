//
//  RewardAdManager.swift
//  yamTODO
//
//  Created by 김미진 on 12/2/24.
//
import GoogleMobileAds
import SwiftUI
import FirebaseFirestore

final class RewardAdManager: NSObject, ObservableObject {
    var rewardedAd: GADRewardedAd?
    @Published var isRewardGiven = false

    func loadAd(adUnitID: String) {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad: \(error.localizedDescription)")
                return
            }
            print("Rewarded ad loaded successfully.")
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
        }
    }

    func showAd(from rootViewController: UIViewController) {
        guard let ad = rewardedAd else {
            print("Ad is not ready.")
            return
        }
        ad.present(fromRootViewController: rootViewController) { [weak self] in
            let reward = ad.adReward
            print("User earned reward of \(reward.amount) \(reward.type).")
            self?.isRewardGiven = true
            
            self?.ensureUserExistsAndReward(userId: self?.getUserId() ?? "unknown", by: 1) { error in
                if let error = error {
                    print("Error updating coins: \(error.localizedDescription)")
                } else {
                    print("User \(self?.getUserId()) rewarded with \(1) coin(s).")
                }
            }
        }
    }
    
    private func getUserId() -> String {
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

    // 최초 등록 후 coin 값을 업데이트하는 함수
    func ensureUserExistsAndReward(userId: String, by amount: Int, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        // 경로: reward/user/{userId}
        let userRef = db.collection("reward").document(userId)

        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(error)
                return
            }

            if let document = document, document.exists {
                // 문서가 이미 존재하면 coin 값을 업데이트
                self.updateCoin(for: userId, by: amount, completion: completion)
            } else {
                // 문서가 없으면 새로운 문서를 생성하고 coin 값을 기본값으로 설정
                userRef.setData(["coin": amount]) { error in
                    if let error = error {
                        print("Failed to create document: \(error.localizedDescription)")
                        completion(error)
                    } else {
                        print("Document created with initial coin value.")
                        completion(nil)
                    }
                }
            }
        }
    }

    // coin 값을 업데이트하는 함수
    func updateCoin(for userId: String, by amount: Int, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        // 경로: reward/user/{userId}
        let userRef = db.collection("reward").document(userId)
        
        // coin 값 업데이트
        userRef.updateData([
            "coin": FieldValue.increment(Int64(amount))
        ]) { error in
            if let error = error {
                print("Failed to update coin: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Coin updated successfully.")
                completion(nil)
            }
        }
    }

}

extension RewardAdManager: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad dismissed.")
        rewardedAd = nil // Ad is no longer valid after being shown.
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present with error: \(error.localizedDescription)")
    }
}
