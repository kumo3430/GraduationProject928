//
//  account.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/10/3.
//

import Foundation
import SwiftSMTP

func Send(verify: String,mail: String,completion: @escaping (String, String) -> Void) {
    DispatchQueue.global().async {
        Random() { message in
            let verify = message
            sendMail(verify: verify,mail: mail) { message in
                if (message == "Success") {
                    print("Send - 隨機變數為：\(verify)")
                    completion(verify, message)
                } else {
                    completion("0", message)
                }
            }
        }
    }
}
func Random( completion: @escaping (String) -> Void) {
    let verify = Int.random(in: 1..<99999999)
    print("regiest - 隨機變數為：\(verify)")
    completion(String(verify))
}
func sendMail(verify: String,mail: String,completion: @escaping (String) -> Void) {
    let smtp = SMTP(
        hostname: "smtp.gmail.com",     // SMTP server address
        email: "3430yun@gmail.com",        // username to login
        password: "knhipliavnpqxwty"            // password to login
    )
    print("mail:\(mail)")
    let megaman = Mail.User(name: "我習慣了使用者", email: mail)
    let drLight = Mail.User(name: "Yun", email: "3430yun@gmail.com")
    let mail = Mail(
        from: drLight,
        to: [megaman],
        subject: "歡迎使用我習慣了！這是您的驗證信件",
        text: "以下是您的驗證碼： \(String(verify))"
    )
    
    smtp.send(mail) { (error) in
        if let error = error {
            print("regiest - \(error)")
            completion("regiest - \(error)")
        } else {
            completion("Success")
            print("SEND: SUBJECT: \(mail.subject)")
            print("SEND: SUBJECT: \(mail.text)")
            print("FROM: \(mail.from)")
            print("TO: \(mail.to)")
            print("Send email successful")
            print("---------------------------------")
        }
    }
}

func handleLogin(data: Data, completion: @escaping (String) -> Void) {
    handleDecodableData(UserData.self, data: data) { userData in
        if (userData.message == "User login successfully") {
            print("============== loginView ==============")
            print("login - userDate:\(userData)")
            print("使用者ID為：\(userData.id)")
            print("使用者帳號為：\(userData.email)")
            UserDefaults.standard.set(true, forKey: "signIn")
            UserDefaults.standard.set("\(userData.id)", forKey: "uid")
            UserDefaults.standard.set("\(userData.email)", forKey: "userName")
            completion("Success")
            print("============== loginView ==============")
        }
    }
}
func handleRegister(data: Data, completion: @escaping (String) -> Void) {
    handleDecodableData(UserData.self, data: data) { userData in
        if (userData.message == "User registered successfully") {
            print("============== verifyView ==============")
            print("regiest - userDate:\(userData)")
            print("使用者ID為：\(userData.id)")
            print("使用者email為：\(userData.email)")
            print("註冊日期為：\(userData.create_at)")
            print("message：\(userData.message)")
            UserDefaults.standard.set(true, forKey: "signIn")
            UserDefaults.standard.set("\(userData.id)", forKey: "uid")
            UserDefaults.standard.set("\(userData.email)", forKey: "userName")
            completion("Success")
            print("============== verifyView ==============")
        } else if (userData.message == "not yet filled") {
            completion("not yet filled")
            print("verifyMessage：\(userData.message)")
//            messenge = "請確認電子郵件、使用者名稱、密碼都有輸入"
        } else if (userData.message == "email is registered") {
            completion("email is registered")
            print("verify - Message：\(userData.message)")
//            messenge = "電子郵件已被註冊過 請重新輸入"
        } else {
            completion("註冊失敗請重新註冊")
            print("verify - Message：\(String(data: data, encoding: .utf8)!)")
//            messenge = "註冊失敗請重新註冊"
        }
    }
}
