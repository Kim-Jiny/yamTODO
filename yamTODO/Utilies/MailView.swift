//
//  MailView.swift
//  yamTODO
//
//  Created by Jiny on 11/17/23.
//
import SwiftUI
import MessageUI

struct MailComposeViewController: UIViewControllerRepresentable {
    @Binding var isShowing: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        mailComposeVC.setToRecipients(["kjinyz@naver.com"]) // 개발자 이메일 주소 입력
        mailComposeVC.setSubject(String(localized: "Send app-related inquiries")) // 이메일 제목 설정
        mailComposeVC.setMessageBody(String(localized: "Please enter your inquiry about the app."), isHTML: false) // 이메일 내용 설정

        return mailComposeVC
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeViewController

        init(parent: MailComposeViewController) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            self.parent.isShowing = false
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
}
