// CheckStudyView.swift
// GraduationProject
//
// Created by [Your Name] on [Current Date].

import SwiftUI

struct CheckStudyComponent: View {
    @State var studyValue: Float = 0.0
    @State var studyUnit: String = "次"
    let studyUnits = ["次", "小時"]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                TextField("輸入數值", value: $studyValue, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .frame(width: 80, alignment: .center)
                
                Picker("選擇單位", selection: $studyUnit) {
                    ForEach(studyUnits, id: \.self) { unit in
                        Text(unit)
                            .font(.system(size: 12))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 150, alignment: .trailing)
                
                Spacer()
            }
            Button("檢核學習", action: checkStudy)
        }
    }
    
    func checkStudy() {
        // 使用假值
        let userId = "1234"
        let todoId = "5678"
        
        // 构造请求体
        let body: [String: Any] = [
            "userId": userId,
            "todoId": todoId,
            "studyValue": studyValue,
            "studyUnit": studyUnit,
        ]
        
        let url = URL(string: "http://127.0.0.1:8888/checkStudy.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("CheckStudyComponent - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("CheckStudyComponent - HTTP error: \(httpResponse.statusCode)")
            } else {
                print("CheckStudyComponent - Success!")
            }
        }
        .resume()
    }
}

struct CheckStudyView_Previews: PreviewProvider {
    static var previews: some View {
        CheckStudyView()
            .environmentObject(TodoStore())
    }
}
