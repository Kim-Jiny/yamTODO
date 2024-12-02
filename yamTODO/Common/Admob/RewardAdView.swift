//
//  RewardAdView.swift
//  yamTODO
//
//  Created by 김미진 on 12/2/24.
//

import Foundation
import SwiftUI

struct RewardAdView: View {
    @StateObject private var adManager = RewardAdManager()
    @State private var isAdReady = false

    var body: some View {
        VStack {
            if isAdReady {
                Button("심심할 때 광고 보기") {
                    if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                        adManager.showAd(from: rootViewController)
                    }
                }
            } else {
                Text("광고를 불러오고 있습니다.")
                    .foregroundColor(.gray)
            }
            
            Text("(지급되는 리워드가 없습니다.)")
                .font(.footnote) // 작은 텍스트 크기
                .foregroundColor(.gray)
//                .padding(.top, 5)
        }
        .onAppear {
            adManager.loadAd(adUnitID: AdType.reward.key)
            checkAdReady()
        }
        .onChange(of: adManager.isRewardGiven) { isGiven in
            if isGiven {
                print("Reward granted to the user.")
                // Add logic to provide reward to the user.
            }
        }
    }

    /// 주기적으로 광고 준비 상태를 확인하는 함수
    private func checkAdReady() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 1초 간격으로 확인
            isAdReady = adManager.rewardedAd != nil
            if !isAdReady {
                checkAdReady() // 광고가 준비되지 않았다면 다시 호출
            }
        }
    }
}
