//
//  PHPUrl.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/9/28.
//

import Foundation

var server = "http://127.0.0.1:8888"

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

func phpUrl(php: String,type: String,body: [String:Any],store: (any ObservableObject)? = nil, completion: @escaping (String) -> Void) {
    // 在這裡使用傳入的參數
//    let server = "http://127.0.0.1:8888"
    var url: URL?
    
    url = URL(string: "\(server)/\(type)/\(php).php")
    print("新的url\(String(describing: url))")
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
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
//            handleDataForPHP(php: php, data: data,store: store, completion: completion)
            handleDataForPHP(php: php, data: data, store: store) { message in
                           completion(message) // 调用回调闭包传递 message
                       }
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

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}

func formattedTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter.string(from: date)
}

func handleDataForPHP(php: String, data: Data,store: (any ObservableObject)? = nil, completion: @escaping (String) -> Void) {
    switch php {
    case "login":
    handleLogin(data: data, completion: completion)
    case "register":
        handleRegister(data: data, completion: completion)
    case "StudySpaceList":
    handleStudySpaceList(data: data,store: store as! TaskStore, completion: completion)
    case "addStudySpaced":
        handleStudySpaceAdd(data: data,store: store as! TaskStore, completion: completion)
        
    case "StudyGeneralList":
        handleStudyGeneralList(data: data,store: store as! TodoStore, completion: completion)
    case "addStudyGeneral":
        handleStudyGeneralAdd(data: data,store: store as! TodoStore, completion: completion)
        
    case "SportList":
        handleSportList(data: data,store: store as! SportStore, completion: completion)
    case "addSport":
        handleSportAdd(data: data,store: store as! SportStore, completion: completion)
        
    case "DietList":
        handleDietList(data: data,store: store as! DietStore, completion: completion)
    case "addDiet":
        handleDietAdd(data: data,store: store as! DietStore, completion: completion)
        
    case "tickersList":
        handletickersList(data: data,store: store as! TickerStore, completion: completion)
    default:
        break
    }
}

func handleDecodableData<T: Decodable>(_ type: T.Type, data: Data, handler: (T) -> Void) {
    do {
        let decoder = JSONDecoder()
        let userData = try decoder.decode(type, from: data)
        print("\(type): \(String(data: data, encoding: .utf8)!)")
        handler(userData)
    } catch {
        print("解碼失敗：\(error)")
    }
}
