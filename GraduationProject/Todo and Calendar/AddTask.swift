//
//  AddTask.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/9/29.
//

import Foundation

// 定義一個通用的函數處理頻率轉換
func convertFrequency(frequency: Int) -> String {
    switch frequency {
    case 1:
        return "每日"
    case 2:
        return "每週"
    case 3:
        return "每月"
    default:
        return ""
    }
}

// 定義一個通用的函數處理重複選項計算
func calculateRecurringOption(dueDateTime: Date, startDate: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year], from: startDate, to: dueDateTime)
    return components.year! >= 5 ? 2 : 1
}

// 定義一個通用的函數處理狀態轉換
func convertTodoStatus(todoStatus: Int) -> Bool {
    return todoStatus != 0
}

func handleStudySpaceAdd(data: Data,store: TaskStore, completion: @escaping (String) -> Void) {
    handleDecodableData(addTaskData.self, data: data) { userData in
        if (userData.message == "User New StudySpaced successfully") {
            let ReviewChecked0 = false
            let ReviewChecked1 = false
            let ReviewChecked2 = false
            let ReviewChecked3 = false
            if let startDate = convertToDate(userData.startDateTime),
               let repetition1Count = convertToDate(userData.repetition1Count),
               let repetition2Count = convertToDate(userData.repetition2Count),
               let repetition3Count = convertToDate(userData.repetition3Count),
               let repetition4Count = convertToDate(userData.repetition4Count),
               let reminderTime = convertToTime(userData.reminderTime) {
                
                let taskId = Int(userData.todo_id)
                let task = Task(id: taskId,
                                label: userData.todoLabel ?? "",
                                title: userData.todoTitle,
                                description: userData.todoIntroduction,
                                nextReviewDate: startDate, nextReviewTime: reminderTime,
                                repetition1Count: repetition1Count, repetition2Count: repetition2Count,
                                repetition3Count: repetition3Count, repetition4Count: repetition4Count,
                                isReviewChecked0: ReviewChecked0, isReviewChecked1: ReviewChecked1,
                                isReviewChecked2: ReviewChecked2, isReviewChecked3: ReviewChecked3)
                DispatchQueue.main.async {
                    store.tasks.append(task)
                }
                completion("Success")
            } else {
                print("StudySpaceList - 日期或時間轉換失敗")
            }
        }
    }
}


func handleStudyGeneralAdd(data: Data,store: TodoStore, completion: @escaping (String) -> Void) {
    handleDecodableData(addTodoData.self, data: data) { userData in
        if (userData.message == "User New StudyGeneral successfullyUser New first RecurringInstance successfully") {
            var studyUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime),
               let dueDateTime = convertToDate(userData.dueDateTime),
               let reminderTime = convertToTime(userData.reminderTime) {

                let frequency = userData.frequency
                let recurringUnit = convertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus
                let isTodoStatus = convertTodoStatus(todoStatus: todoStatus)

                if (userData.studyUnit == 0 ){
                    studyUnit = "小時"
                } else  if (userData.studyUnit == 1 ) {
                    studyUnit = "次"
                }
                
                let taskId = Int(userData.todo_id)
                let todo = Todo(id: taskId,
                                label: userData.todoLabel ?? "",
                                title: userData.todoTitle,
                                description: userData.todoIntroduction,
                                startDateTime: startDate,
                                studyValue: userData.studyValue,
                                studyUnit: studyUnit,
                                recurringUnit: recurringUnit,
                                recurringOption: recurringOption,
                                todoStatus: isTodoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote ?? "")
                DispatchQueue.main.async {
                    store.todos.append(todo)
                }
                completion("Success")
            } else {
                print("StudyGeneralList - 日期或時間轉換失敗")
            }
            
        }
    }
}

func handleSportAdd(data: Data,store: SportStore, completion: @escaping (String) -> Void) {
    handleDecodableData(addSportData.self, data: data) { userData in
        if (userData.message == "User New Sport successfullyUser New first RecurringInstance successfully") {
            var sportUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime ),
               let dueDateTime = convertToDate(userData.dueDateTime ),
               let reminderTime = convertToTime(userData.reminderTime ) {
                
                let frequency = userData.frequency
                let recurringUnit = convertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus
                let isTodoStatus = convertTodoStatus(todoStatus: todoStatus)
                
                if (userData.sportUnit  == 0 ){
                    sportUnit = "小時"
                } else  if (userData.sportUnit  == 1 ) {
                    sportUnit = "次"
                } else  if (userData.sportUnit  == 2 ) {
                    sportUnit = "卡路里"
                }
                
                let taskId = Int(userData.todo_id )
                let sport = Sport(id: taskId,
                                  label: userData.todoLabel ?? "",
                                  title: userData.todoTitle ,
                                  description: userData.todoIntroduction ,
                                  startDateTime: startDate,
                                  selectedSport: userData.sportType ,
                                  sportValue: userData.sportValue ,
                                  sportUnits: sportUnit,
                                  recurringUnit: recurringUnit,
                                  recurringOption: recurringOption,
                                  todoStatus: isTodoStatus,
                                  dueDateTime: dueDateTime,
                                  reminderTime: reminderTime,
                                  todoNote: userData.todoNote ?? "" )
                DispatchQueue.main.async {
                    store.sports.append(sport)
                }
                completion("Success")
            } else {
                print("SportList - 日期或時間轉換失敗")
            }
        }
    }
}
func handleDietAdd(data: Data,store: DietStore, completion: @escaping (String) -> Void) {
    handleDecodableData(addDietData.self, data: data) { userData in
        if (userData.message == "User New diet successfullyUser New first RecurringInstance successfully") {
            
            if let startDate = convertToDate(userData.startDateTime ),
               let dueDateTime = convertToDate(userData.dueDateTime ),
               let reminderTime = convertToTime(userData.reminderTime ) {
                
                let frequency = userData.frequency
                let recurringUnit = convertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus
                let isTodoStatus = convertTodoStatus(todoStatus: todoStatus)
                
                let taskId = Int(userData.todo_id )
                let diet = Diet(id: taskId,
                                label: userData.todoLabel ?? "",
                                title: userData.todoTitle ,
                                description: userData.todoIntroduction ,
                                startDateTime: startDate,
                                selectedDiets: userData.dietType ,
                                dietsValue: userData.dietValue,
                                recurringUnit: recurringUnit,
                                recurringOption: recurringOption,
                                todoStatus: isTodoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote ?? "" )
                DispatchQueue.main.async {
                    store.diets.append(diet)
                }
                completion("Success")
            } else {
                print("DietList - 日期或時間轉換失敗")
            }
        }
    }
}
