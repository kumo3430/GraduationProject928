//
//  account.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/10/3.
//

import Foundation

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
