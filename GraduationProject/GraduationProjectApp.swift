//
//  GraduationProjectApp.swift
//  GraduationProject
//
//  Created by heonrim on 5/20/23.
//

import SwiftUI
import FirebaseCore

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
    @AppStorage("uid") private var uid:String = ""
    @AppStorage("userName") private var userName:String = ""
    @AppStorage("password") private var password:String = ""
    
    @StateObject var taskStore = TaskStore()
    @StateObject var todoStore = TodoStore()
    @StateObject var sportStore = SportStore()
    @StateObject var dietStore = DietStore()
    @StateObject var tickerStore = TickerStore()
    var body: some Scene {
        WindowGroup {
            if !isSignIn {
                LoginView()
                    .onAppear() {
                        taskStore.clearTasks()
                        todoStore.clearTodos()
                        sportStore.clearTodos()
                        dietStore.clearTodos()
                        tickerStore.clearTodos()
                        UserDefaults.standard.set("", forKey: "uid")
                        UserDefaults.standard.set("", forKey: "userName")
                        UserDefaults.standard.set("", forKey: "password")
                    }
                
            } else {
                TabBarView()
                    .environmentObject(taskStore)
                    .environmentObject(todoStore)
                    .environmentObject(sportStore)
                    .environmentObject(dietStore)
                    .environmentObject(tickerStore)
                    .onAppear() {
//                        StudySpaceList()
                        List()
                        print("AppView-AppStorageUid:\(uid)")
                        print("AppView-AppStorageUserName:\(userName)")
                        print("AppView-AppStoragePassword:\(password)")
                    }
            }
        }
    }
    
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
    
    private func List() {
        StudySpaceList {
            self.StudyGeneralList {
                self.SportList {
                    self.DietList {
                        self.tickersList {
                        }
                    }
                }
            }
        }
    }

    private func StudySpaceList(completion: @escaping () -> Void) {
        phpUrl(php: "StudySpaceList")
        completion()
    }

    private func StudyGeneralList(completion: @escaping () -> Void) {
        phpUrl(php: "StudyGeneralList")
        completion()
    }

    private func SportList(completion: @escaping () -> Void) {
        phpUrl(php: "SportList")
        completion()
    }

    private func DietList(completion: @escaping () -> Void) {
        phpUrl(php: "DietList")
        completion()
    }

    private func tickersList(completion: @escaping () -> Void) {
        phpUrl(php: "tickersList")
        completion()
    }
    func phpUrl(php: String) {
        // 在這裡使用傳入的參數
        let server = "http://127.0.0.1:8888"
        var url: URL?
        url = URL(string: "\(server)/list/\(php).php")
        print("新的url\(String(describing: url))")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let body: [String: Any] = ["uid": uid]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                //                completion(.failure(error))
                print("\(php) - Connection error: \(error)")
            }else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("StudySpaceList - HTTP error: \(httpResponse.statusCode)")
            }else if let data = data {
                //                completion(.success(data))
                handleDataForPHP(php: php, data: data)
            }
        }.resume()
    }
  
    func convertToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
    
    func convertToTime(_ timeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.date(from: timeString)
    }
    
    func convertToDateTime(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dateString)
    }
    
    private func handleDataForPHP(php: String, data: Data) {
        switch php {
        case "StudySpaceList":
            handleTaskData(data: data)
        case "StudyGeneralList":
            handleTodoData(data: data)
        case "SportList":
            handleSportData(data: data)
        case "DietList":
            handleDietData(data: data)
        case "tickersList":
            handleTickerData(data: data)
        default:
            break
        }
    }

    private func handleTaskData(data: Data) {
        handleDecodableData(TaskData.self, data: data) { userData in
            for index in userData.todoTitle.indices {
                let ReviewChecked0: Bool
                let ReviewChecked1: Bool
                let ReviewChecked2: Bool
                let ReviewChecked3: Bool
                if let startDate = convertToDate(userData.startDateTime[index]),
                   let repetition1Count = convertToDate(userData.repetition1Count[index]),
                   let repetition2Count = convertToDate(userData.repetition2Count[index]),
                   let repetition3Count = convertToDate(userData.repetition3Count[index]),
                   let repetition4Count = convertToDate(userData.repetition4Count[index]),
                   let reminderTime = convertToTime(userData.reminderTime[index]) {

                    if (userData.repetition1Status[index] == "0" ){
                        ReviewChecked0 = false
                    } else {
                        ReviewChecked0 = true
                    }
                    if (userData.repetition2Status[index] == "0" ){
                        ReviewChecked1 = false
                    } else {
                        ReviewChecked1 = true
                    }
                    if (userData.repetition3Status[index] == "0" ){
                        ReviewChecked2 = false
                    } else {
                        ReviewChecked2 = true
                    }
                    if (userData.repetition4Status[index] == "0" ){
                        ReviewChecked3 = false
                    } else {
                        ReviewChecked3 = true
                    }
                    let taskId = Int(userData.todo_id[index])
                    let task = Task(id: taskId!,label: userData.todoLabel[index]!, title: userData.todoTitle[index], description: userData.todoIntroduction[index], nextReviewDate: startDate, nextReviewTime: reminderTime, repetition1Count: repetition1Count, repetition2Count: repetition2Count, repetition3Count: repetition3Count, repetition4Count: repetition4Count, isReviewChecked0: ReviewChecked0, isReviewChecked1: ReviewChecked1, isReviewChecked2: ReviewChecked2, isReviewChecked3: ReviewChecked3)
                    DispatchQueue.main.async {
                        taskStore.tasks.append(task)

                    }
                } else {
                    print("StudySpaceList - 日期或時間轉換失敗")
                }
            }
        }
    }

    private func handleTodoData(data: Data) {
        handleDecodableData(TodoData.self, data: data) { userData in
            for index in userData.todoTitle.indices {
                var todoStatus: Bool = false
                var recurringOption: Int = 0
                var recurringUnit: String = ""
                var studyUnit: String = ""
                if let startDate = convertToDate(userData.startDateTime[index]),
                   let dueDateTime = convertToDate(userData.dueDateTime[index]),
                   let reminderTime = convertToTime(userData.reminderTime[index]) {

                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year], from: startDate, to: dueDateTime)
                    if let yearsDifference = components.year, yearsDifference >= 5 {
                        recurringOption = 2
                    } else {
                        recurringOption = 1
                    }
                    if (userData.frequency[index] == "1" ){
                        recurringUnit = "每日"
                    } else  if (userData.frequency[index] == "2" ) {
                        recurringUnit = "每週"
                    } else  if (userData.frequency[index] == "3" ) {
                        recurringUnit = "每月"
                    }
                    if (userData.studyUnit[index] == "0" ){
                        studyUnit = "小時"
                    } else  if (userData.studyUnit[index] == "1" ) {
                        studyUnit = "次"
                    }
                    if (userData.todoStatus[index] == "0" ){
                        todoStatus = false
                    } else {
                        todoStatus = true
                    }

                    let taskId = Int(userData.todo_id[index])
                    let todo = Todo(id: taskId!,
                                    label: userData.todoLabel[index]!,
                                    title: userData.todoTitle[index],
                                    description: userData.todoIntroduction[index],
                                    startDateTime: startDate,
                                    studyValue:  Float(userData.studyValue[index])!,
                                    studyUnit: studyUnit,
                                    recurringUnit: recurringUnit,
                                    recurringOption: recurringOption,

                                    todoStatus: todoStatus,
                                    dueDateTime: dueDateTime,
                                    reminderTime: reminderTime,
                                    todoNote: userData.todoNote[index])
                    DispatchQueue.main.async {
                        todoStore.todos.append(todo)

                    }
                } else {
                    print("StudyGeneralList - 日期或時間轉換失敗")
                }
            }
        }
    }

    private func handleSportData(data: Data) {
        handleDecodableData(SportData.self, data: data) { userData in
            for index in userData.todoTitle.indices {
                var todoStatus: Bool = false
                var recurringOption: Int = 0
                var recurringUnit: String = ""
                var sportUnit: String = ""
                if let startDate = convertToDate(userData.startDateTime[index]),
                   let dueDateTime = convertToDate(userData.dueDateTime[index]),
                   let reminderTime = convertToTime(userData.reminderTime[index]) {

                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year], from: startDate, to: dueDateTime)
                    if let yearsDifference = components.year, yearsDifference >= 5 {
                        recurringOption = 2
                    } else {
                        recurringOption = 1
                    }
                    if (userData.frequency[index] == "1" ){
                        recurringUnit = "每日"
                    } else  if (userData.frequency[index] == "2" ) {
                        recurringUnit = "每週"
                    } else  if (userData.frequency[index] == "3" ) {
                        recurringUnit = "每月"
                    }
                    if (userData.sportUnit[index] == "0" ){
                        sportUnit = "小時"
                    } else  if (userData.sportUnit[index] == "1" ) {
                        sportUnit = "次"
                    } else  if (userData.sportUnit[index] == "2" ) {
                        sportUnit = "卡路里"
                    }

                    if (userData.todoStatus[index] == "0" ){
                        todoStatus = false
                    } else {
                        todoStatus = true
                    }

                    let taskId = Int(userData.todo_id[index])
                    let sport = Sport(id: taskId!,
                                    label: userData.todoLabel[index]!,
                                    title: userData.todoTitle[index],
                                    description: userData.todoIntroduction[index],
                                    startDateTime: startDate,
                                    selectedSport: userData.sportType[index],
                                      sportValue:  Float(userData.sportValue[index])!,
                                    sportUnits: sportUnit,
                                    recurringUnit: recurringUnit,
                                    recurringOption: recurringOption,
                                    todoStatus: todoStatus,
                                    dueDateTime: dueDateTime,
                                    reminderTime: reminderTime,
                                    todoNote: userData.todoNote[index])
                    DispatchQueue.main.async {
                        sportStore.sports.append(sport)

                    }
                } else {
                    print("SportList - 日期或時間轉換失敗")
                }
            }
        }
    }

    private func handleDietData(data: Data) {
        handleDecodableData(DietData.self, data: data) { userData in
            for index in userData.todoTitle.indices {
                var todoStatus: Bool = false
                var recurringOption: Int = 0
                var recurringUnit: String = ""
                if let startDate = convertToDate(userData.startDateTime[index]),
                   let dueDateTime = convertToDate(userData.dueDateTime[index]),
                   let reminderTime = convertToTime(userData.reminderTime[index]) {

                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year], from: startDate, to: dueDateTime)
                    if let yearsDifference = components.year, yearsDifference >= 5 {
                        recurringOption = 2
                    } else {
                        recurringOption = 1
                    }

                    if (userData.frequency[index] == "1" ){
                        recurringUnit = "每日"
                    } else  if (userData.frequency[index] == "2" ) {
                        recurringUnit = "每週"
                    } else  if (userData.frequency[index] == "3" ) {
                        recurringUnit = "每月"
                    }

                    if (userData.todoStatus[index] == "0" ){
                        todoStatus = false
                    } else {
                        todoStatus = true
                    }

                    let taskId = Int(userData.todo_id[index])
                    let diet = Diet(id: taskId!,
                                    label: userData.todoLabel[index]!,
                                    title: userData.todoTitle[index],
                                    description: userData.todoIntroduction[index],
                                    startDateTime: startDate,
                                    selectedDiets: userData.dietsType[index],
                                    dietsValue: Int(userData.dietsValue[index])!,
                                    recurringUnit: recurringUnit,
                                    recurringOption: recurringOption,
                                    todoStatus: todoStatus,
                                    dueDateTime: dueDateTime,
                                    reminderTime: reminderTime,
                                    todoNote: userData.todoNote[index])
                    DispatchQueue.main.async {
                        dietStore.diets.append(diet)

                    }
                } else {
                    print("DietList - 日期或時間轉換失敗")
                }
            }
        }
    }

    private func handleTickerData(data: Data) {
        handleDecodableData(TickerData.self, data: data) { userData in
            for index in userData.ticker_id.indices {
                if let deadline = convertToDateTime(userData.deadline[index]) {
                    //var exchange: Date?  // 聲明 exchange 變數
                    var exchange: String?
                    if userData.exchange[index] == nil {
                        //exchange = nil  // 不需要賦值，因為 exchange 變數已經初始化為 nil
                        exchange = "尚未兌換"
                    } else {
                        exchange = (userData.exchange[index]!)
                    }
                    let taskId = userData.ticker_id[index]
                    let task = Ticker(id: taskId, name: userData.name[index], deadline: deadline, exchage: exchange!)

                    DispatchQueue.main.async {
                        tickerStore.tickers.append(task)
                    }
                } else {
                    print("TickerList - 尚未兌換")
                }
            }
        }
    }

    private func handleDecodableData<T: Decodable>(_ type: T.Type, data: Data, handler: (T) -> Void) {
        do {
            let decoder = JSONDecoder()
            let userData = try decoder.decode(type, from: data)
            print("\(type): \(String(data: data, encoding: .utf8)!)")
            handler(userData)
        } catch {
            print("解码失败：\(error)")
        }
    }
  
}
