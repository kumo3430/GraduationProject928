//
//  AddSpaceView.swift
//  GraduationProject
//
//  Created by heonrim on 8/6/23.
//

import Foundation
import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    //    @ObservedObject var taskStore: TaskStore
    //    @StateObject var taskStore: TaskStore
    @EnvironmentObject var taskStore: TaskStore
    
    @State var title = ""
    @State var description = ""
    @State var label: String = ""
    @State var nextReviewDate = Date()
    @State var nextReviewTime = Date()
    @State var repetition1Count = Date()
    @State var repetition2Count = Date()
    @State var repetition3Count = Date()
    @State var repetition4Count = Date()
    @State var messenge = ""
    @State var isError = false
    
    struct UserData : Decodable {
        var userId: String?
        //        var id: Int
        var category_id: Int
        var label: String
        var todoTitle: String
        var todoIntroduction: String
        var startDateTime: String
        var reminderTime: String
        var todo_id: String
        var repetition1Count: String
        var repetition2Count: String
        var repetition3Count: String
        var repetition4Count: String
        var message: String
    }
    
    //    @State var isReviewChecked: [Bool] = Array(repeating: false, count: 4)
    var nextReviewDates: [Date] {
        let intervals = [1, 3, 7, 14]
        return intervals.map { Calendar.current.date(byAdding: .day, value: $0, to: nextReviewDate)! }
    }
    
    var body: some View {
        NavigationView {
            Form {
                // 此部分為欄位上面小小的字
                Section {
                    TextField("標題", text: $title)
                    TextField("內容", text: $description)
                }
                Section {
                        HStack {
                            Image(systemName: "tag.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit) // 保持圖示的原始寬高比
                                .foregroundColor(.white) // 圖示顏色設為白色
                                .padding(6) // 確保有足夠的空間顯示外框和背景色
                                .background(Color.yellow) // 設定背景顏色
                                .clipShape(RoundedRectangle(cornerRadius: 8)) // 設定方形的邊框，並稍微圓角
                                .frame(width: 30, height: 30) // 這裡的尺寸是示例，您可以根據需要調整
                            TextField("標籤", text: $label)
                        }
                    }
                Section {
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("選擇時間", selection: $nextReviewDate, displayedComponents: [.date])
                    }
                    HStack {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.purple)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("提醒時間", selection: $nextReviewTime, displayedComponents: [.hourAndMinute])
                    }
                }

                Section {
                    ForEach(0..<4) { index in
                        HStack {
                            Text("第\(formattedInterval(index))天： \(formattedDate(nextReviewDates[index]))")
                        }
                    }
                }
                if(isError) {
                    Text(messenge)
                        .foregroundColor(.red)
                }
            }
            // 一個隱藏的分隔線
            .listStyle(PlainListStyle())
            .navigationBarTitle("間隔學習")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("返回")
                    .foregroundColor(.blue)
            },
                                trailing: Button("完成") { addStudySpaced() }
                                // 如果 title 為空，按鈕會被禁用，即無法點擊。
                .disabled(title.isEmpty)
                .onDisappear() {
                    repetition1Count = nextReviewDates[0]
                    repetition2Count = nextReviewDates[1]
                    repetition3Count = nextReviewDates[2]
                    repetition4Count = nextReviewDates[3]
                }
            )
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
        return formatter.string(from: date)
    }
    func formattedInterval(_ index: Int) -> Int {
        let intervals = [1, 3, 7, 14]
        return intervals[index]
    }
    
    func addStudySpaced() {
        class URLSessionSingleton {
            static let shared = URLSessionSingleton()
            let session: URLSession
            private init() {
                let config = URLSessionConfiguration.default
                config.httpCookieStorage = HTTPCookieStorage.shared
                config.httpCookieAcceptPolicy = .always
                session = URLSession(configuration: config)
            }
        }
        
        let url = URL(string: "http://127.0.0.1:8888/addStudySpaced.php")!
        //        let url = URL(string: "http://10.21.1.164:8888/account/register.php")!
        var request = URLRequest(url: url)
        //        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "POST"
        let body = ["title": title, "description": description, "label": label, "nextReviewDate": formattedDate(nextReviewDate),"nextReviewTime": formattedTime(nextReviewTime),"First": formattedDate(nextReviewDates[0]),"third": formattedDate(nextReviewDates[1]),"seventh": formattedDate(nextReviewDates[2]),"fourteenth": formattedDate(nextReviewDates[3]) ]
        print("AddSpacedView - body:\(body)")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("AddSpacedView - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("AddSpacedView - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    //                    確認api會印出的所有內容
                    print("AddSpacedView - Data : \(String(data: data, encoding: .utf8)!)")
                    let userData = try decoder.decode(UserData.self, from: data)
                    if (userData.message == "User New StudySpaced successfully") {
                        print("============== AddSpacedView ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("addStudySpaced - userDate:\(userData)")
                        print("使用者ID為：\(userData.userId ?? "N/A")")
                        print("事件id為：\(userData.todo_id)")
                        print("事件種類為：\(userData.category_id)")
                        print("事件名稱為：\(userData.todoTitle)")
                        print("事件簡介為：\(userData.todoIntroduction)")
                        print("事件種類為：\(userData.label)")
                        print("開始時間為：\(userData.startDateTime)")
                        print("提醒時間為：\(userData.reminderTime)")
                        print("事件編號為：\(userData.todo_id)")
                        print("第一次間隔重複時間為：\(userData.repetition1Count)")
                        print("第二次間隔重複時間為：\(userData.repetition2Count)")
                        print("第三次間隔重複時間為：\(userData.repetition3Count)")
                        print("第四次間隔重複時間為：\(userData.repetition4Count)")
                        print("addStudySpaced - message：\(userData.message)")
                        DispatchQueue.main.async {
                            isError = false
                            // 如果沒有錯才可以關閉視窗並且把此次東西暫存起來
                            let task = Task(id: Int(userData.todo_id)!, label: label,title: title, description: description, nextReviewDate: nextReviewDate, nextReviewTime: nextReviewTime, repetition1Count: repetition1Count, repetition2Count: repetition2Count, repetition3Count: repetition3Count, repetition4Count: repetition4Count, isReviewChecked0: false, isReviewChecked1: false, isReviewChecked2: false, isReviewChecked3: false)
                            taskStore.tasks.append(task)
                            presentationMode.wrappedValue.dismiss()
                        }
                        print("============== AddSpacedView ==============")
                    } else if (userData.message == "The Todo is repeated") {
                        isError = true
                        print("AddSpacedView - message：\(userData.message)")
                        messenge = "已建立過，請重新建立"
                    } else if (userData.message == "New Todo - Error: <br>Incorrect integer value: '' for column 'uid' at row 1") {
                        isError = true
                        print("AddSpacedView - message：\(userData.message)")
                        messenge = "登入出錯 請重新登入"
                    } else  {
                        isError = true
                        print("AddSpacedView - message：\(userData.message)")
                        messenge = "建立失敗，請重新建立"
                    }
                } catch {
                    isError = true
                    print("AddSpacedView - 解碼失敗：\(error)")
                    messenge = "建立失敗，請重新建立"
                }
            }
            // 測試
            //            guard let data = data else {
            //                print("No data returned from server.")
            //                return
            //            }
            //            if let content = String(data: data, encoding: .utf8) {
            //                print(content)
            //            }
        }
        .resume()
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
            .environmentObject(TaskStore())
    }
}
