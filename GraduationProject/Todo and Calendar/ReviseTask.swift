//
//  ReviseTask.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/10/3.
//

import Foundation
func handleStudySpaceRevise(data: Data, completion: @escaping (String) -> Void) {
    handleReviseData(data: data, messageType: .reviseSpace, completion: completion)
}
func handleGeneralRevise(data: Data, completion: @escaping (String) -> Void) {
    handleReviseData(data: data, messageType: .revise, completion: completion)
}
func handleUpDateCompleteValue(data: Data, completion: @escaping (String) -> Void) {
    handleUpDateValue(data: data, messageType: .revise, completion: completion)
}

func handleReviseData(data: Data, messageType: Message, completion: @escaping (String) -> Void) {
    handleDecodableData(ReviseData.self, data: data) { userData in
        if userData.message == messageType.rawValue {
            print("============== \(messageType.rawValue) ==============")
            print("\(messageType.rawValue) - userDate:\(userData)")
            completion(Message.success.rawValue)
            print("============== \(messageType.rawValue) ==============")
        } else {
            completion(userData.message)
            print("\(messageType.rawValue) - Message：\(userData.message)")
        }
    }
}
func handleUpDateValue(data: Data, messageType: Message, completion: @escaping (String) -> Void) {
    handleDecodableData(UpdateValueData.self, data: data) { userData in
        if userData.message == messageType.rawValue {
            print("============== \(messageType.rawValue) ==============")
            print("\(messageType.rawValue) - userDate:\(userData)")
            completion(Message.success.rawValue)
            print("============== \(messageType.rawValue) ==============")
        } else {
            completion(userData.message)
            print("\(messageType.rawValue) - Message：\(userData.message)")
        }
    }
}
