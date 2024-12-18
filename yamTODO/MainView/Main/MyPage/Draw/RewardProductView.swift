//
//  RewardProductView.swift
//  yamTODO
//
//  Created by 김미진 on 12/18/24.
//

import SwiftUI

struct RewardProductView: View {
    let product: RewardProduct
    let onButtonTapped: (RewardProduct) -> Void

    private var isExpired: Bool {
        product.deadline < Date()
    }
    
    private var isResultAnnouncement: Bool {
        product.resultAnnouncementDate < Date()
    }
    
    var body: some View {
        VStack {
            if let url = URL(string: product.image) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(width: 100, height: 100)
                    case .success(let image):
                        image.resizable().scaledToFit().frame(width: 100, height: 100)
                    case .failure:
                        Image(systemName: "photo").resizable().scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo").resizable().scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
            
            Text(product.title)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("\(product.requiredCoins) 코인 필요")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if !isExpired {
                Text("수량: \(product.remainingQuantity)")
                    .font(.footnote)
                    .foregroundColor(product.remainingQuantity > 0 ? .green : .red)
            }
            
            if !isExpired {
                Text("\(product.deadline, formatter: DateFormatter.shortDate) 마감")
                    .font(.footnote)
                    .foregroundColor(.gray)
            } else {
                Text("마감됨").font(.footnote).foregroundColor(.gray)
            }
            
            if !isResultAnnouncement {
                Text("\(product.resultAnnouncementDate, formatter: DateFormatter.shortResultDate) 발표")
                    .font(.footnote)
                    .foregroundColor(.gray)
            } else {
                Text("당첨자 추첨 완료").font(.footnote).foregroundColor(.gray)
            }
            
            Button(action: { onButtonTapped(product) }) {
                Text(buttonText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(buttonBackgroundColor)
                    .cornerRadius(8)
            }
            .disabled(buttonDisabled)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }

    private var buttonText: String {
        if isExpired {
            return (product.applyCount > 0) ? (isResultAnnouncement ? "당첨 확인" : "응모 완료") : "마감"
        } else {
            return (product.applyCount > 0) ? "응모 완료" : "응모 하기"
        }
    }

    private var buttonBackgroundColor: Color {
        if isExpired {
            return (product.applyCount > 0) && isResultAnnouncement ? Color.blue : Color.gray
        } else {
            return !(product.applyCount > 0) ? Color.blue : Color.gray
        }
    }

    private var buttonDisabled: Bool {
        if isExpired {
            return !((product.applyCount > 0) && isResultAnnouncement)
        } else {
            return (product.applyCount > 0)
        }
    }
}
