//
//  GraduationProjectApp.swift
//  GraduationProject
//
//  Created by heonrim on 5/20/23.
//

import SwiftUI
import FirebaseCore
import Foundation

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
        phpUrl(php: "StudySpaceList" ,type: "list",uid:uid,store: taskStore)
        completion()
    }

    private func StudyGeneralList(completion: @escaping () -> Void) {
        phpUrl(php: "StudyGeneralList",type: "list",uid:uid,store: todoStore)
        completion()
    }

    private func SportList(completion: @escaping () -> Void) {
        phpUrl(php: "SportList",type: "list",uid:uid,store: sportStore)
        completion()
    }

    private func DietList(completion: @escaping () -> Void) {
        phpUrl(php: "DietList",type: "list",uid:uid,store: dietStore)
        completion()
    }

    private func tickersList(completion: @escaping () -> Void) {
        phpUrl(php: "tickersList",type: "list",uid:uid,store: tickerStore)
        completion()
    }
    
  
}
