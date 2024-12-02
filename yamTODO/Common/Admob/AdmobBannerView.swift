//
//  AdmobBannerView.swift
//  yamTODO
//
//  Created by 김미진 on 11/22/23.
//

import Foundation
import SwiftUI
import GoogleMobileAds

enum AdType {
    case mainBN, subBN, fullSC, reward, rewardTest, test
    
    var key: String {
        switch self {
        case .mainBN:
            return "ca-app-pub-2707874353926722/9147943308"
        case .subBN:
            return "ca-app-pub-2707874353926722/7553071866"
        case .fullSC:
            return "ca-app-pub-2707874353926722/9615148482"
        case .reward:
            return "ca-app-pub-2707874353926722/1983452541"
        case .rewardTest:
            return "ca-app-pub-3940256099942544/1712485313"
        case .test:
            return "ca-app-pub-3940256099942544/2934735716"
        }
    }
}

struct AdmobBannerView: UIViewControllerRepresentable {
    let adType: AdType
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = adType.key
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }

    func updateUIViewController(_ viewController: UIViewController, context: Context) {

    }
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
          print("bannerViewDidReceiveAd")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewDidDismissScreen")
        }
      }
}
