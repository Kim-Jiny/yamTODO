//
//  RewardPopupView.swift
//  yamTODO
//
//  Created by 김미진 on 12/18/24.
//

import SwiftUI

struct RewardPopupView: View {
    var message: String
    var showClaimButton: Bool
    var onClaimAction: (() -> Void)?
    var onDismissAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            if showClaimButton {
                Button(action: {
                    onClaimAction?()
                }) {
                    Text("상품 수령하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }

            Button(action: {
                onDismissAction?()
            }) {
                Text("닫기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
