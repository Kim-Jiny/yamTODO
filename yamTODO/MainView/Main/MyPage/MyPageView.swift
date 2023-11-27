//
//  MyPageView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/31.
//

import SwiftUI
import UIKit
import MessageUI
import GoogleMobileAds

struct MyPage: View {
    @ObservedObject var userColor: UserColorObject
//    @StateObject var viewModel = ColorSettingViewModel()
    @State private var latestVersion: String = String(localized: "Store version Loading...")
    @State private var isNewVersion: Bool = true
    @State private var isShowingMailView = false
    @State private var showFailedMailAlert = false
    @State private var result: Result<MFMailComposeResult, Error>?
    @State private var isShowNotice: Bool = false
    @State var isShowRepeatView: Bool = false
    @State private var isAppNotice: Bool = false
  // MARK: Body
    @ViewBuilder func admob() -> some View {
            // admob
        AdmobBannerView(adType: .subBN).frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
    }
  
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    appInfoSection
                    taskInfoSection
                    forDeveloper
                    adSection
                }
            }
                .navigationBarTitle("My Page")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            checkForUpdate()
        }
    }
}


private extension MyPage {
  // MARK: View
    var appInfoSection: some View {
      Section(header: Text("App settings").fontWeight(.medium)) {
          if isNewVersion {
              if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                  Text("App version v\(appVersion) 최신 버전 입니다.")
                      .frame(height: 44)
              }
          }else {
              if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                  NavigationLink(destination: ColorSettingMainView(userColor: userColor)) {
                      Text("App version v\(appVersion) 최신 버전이 아닙니다.")
                          .frame(height: 44)
                  }
              }
          }
          
          NavigationLink(destination: ColorSettingMainView(userColor: userColor)) {
              Text("Setting App Color")
                  .frame(height: 44)
          }
      }
    }
  var taskInfoSection: some View {
    Section(header: Text("Recurring schedule").fontWeight(.medium)) {
        NavigationLink(destination: RepeatSettingView(userColor: userColor)) {
            Text("Setting up a recurring schedule")
        }
        .frame(height: 44)
    }
  }
  
    var adSection: some View {
        Section(header: Text("광고").fontWeight(.medium)) {
            admob()

        //      productHeightPicker
        }
    }
    var forDeveloper: some View {
      Section(header: Text("Communication").fontWeight(.medium)) {
          
          Button {
              if MFMailComposeViewController.canSendMail() {
                  self.isShowingMailView.toggle()
              } else {
                  self.showFailedMailAlert = true
              }
          } label: {
              Text("Send feedback to the developer (Inquiry)")
          }
          .sheet(isPresented: $isShowingMailView) {
              MailComposeViewController(isShowing: self.$isShowingMailView)
          }.alert(isPresented: $showFailedMailAlert) {
              Alert(title: Text("Unable to send email"), message: Text("You cannot send emails from this device."), dismissButton: .default(Text("OK")))
          }
          .frame(height: 44)
        
      }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "알림 제목"
        content.body = "알림 본문"
        content.sound = UNNotificationSound.default

        // 알림이 표시되는 시간 설정 (예: 10초 후)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // 요청을 notification center에 추가
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            } else {
                print("Notification request added successfully")
            }
        }
    }
    
    func checkForUpdate() {
        AppVersionCheck.isUpdateAvailable { version in
            if let version = version {
                // 비동기로 가져온 최신 버전을 UI에 반영하기 위해 메인 스레드에서 업데이트
                DispatchQueue.main.async {
                    self.latestVersion = String(localized: "Store version v\(version)")
                }
                
                isNewVersion = AppVersionCheck.isNewVersion(version)
            } else {
                // 최신 버전을 가져오는 데 실패한 경우, 에러 처리 또는 기본값 표시 등을 수행
                DispatchQueue.main.async {
                    self.latestVersion = "Failed to fetch version"
                }
            }
        }
    }
}

extension ContentView {
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}

extension Result {
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }

    var isFailure: Bool {
        return !isSuccess
    }
}

class AppVersionCheck {
    // 코드작성
    static func isUpdateAvailable(completion: @escaping (String?) -> Void) {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/kr/lookup?id=6472643559") else {
                completion(nil)
                return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                if let results = json?["results"] as? [Any],
                   let result = results.first as? [String: Any],
                   let version = result["version"] as? String {
                    completion(version)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    static func isNewVersion(_ storeV: String) -> Bool {
        let verFloat = NSString.init(string: storeV).floatValue
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return true
        }
        let currentVerFloat = NSString.init(string: currentVersion).floatValue
        
        return verFloat >= currentVerFloat
    }
    
    func appUpdate() {
        let appleId = "6472643559"        // 앱 스토어에 일반 정보의 Apple ID 입력
        // UIApplication 은 Main Thread 에서 처리
        DispatchQueue.main.async {
            if let url = URL(string: "itms-apps://itunes.apple.com/app/\(appleId)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

