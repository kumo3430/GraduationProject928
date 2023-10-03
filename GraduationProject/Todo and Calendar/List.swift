//
//  List.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/9/29.
//

import Foundation

// 定義一個通用的函數處理頻率轉換
func ConvertFrequency(frequency: String) -> String {
    switch frequency {
    case "1":
        return "每日"
    case "2":
        return "每週"
    case "3":
        return "每月"
    default:
        return ""
    }
}

// 定義一個通用的函數處理狀態轉換
func ConvertTodoStatus(todoStatus: String) -> Bool {
    return todoStatus != "0"
}

func handleStudySpaceList(data: Data,store: TaskStore, completion: @escaping (String) -> Void) {
    handleDecodableData(TaskData.self, data: data) { userData in
        for index in userData.todoTitle.indices {

            if let startDate = convertToDate(userData.startDateTime[index]),
               let repetition1Count = convertToDate(userData.repetition1Count[index]),
               let repetition2Count = convertToDate(userData.repetition2Count[index]),
               let repetition3Count = convertToDate(userData.repetition3Count[index]),
               let repetition4Count = convertToDate(userData.repetition4Count[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {

                let ReviewChecked0 = userData.repetition1Status[index] == "1"
                let ReviewChecked1 = userData.repetition2Status[index] == "1"
                let ReviewChecked2 = userData.repetition3Status[index] == "1"
                let ReviewChecked3 = userData.repetition4Status[index] == "1"

                let taskId = Int(userData.todo_id[index])
                let task = Task(id: taskId!,label: userData.todoLabel[index]!, title: userData.todoTitle[index], description: userData.todoIntroduction[index], nextReviewDate: startDate, nextReviewTime: reminderTime, repetition1Count: repetition1Count, repetition2Count: repetition2Count, repetition3Count: repetition3Count, repetition4Count: repetition4Count, isReviewChecked0: ReviewChecked0, isReviewChecked1: ReviewChecked1, isReviewChecked2: ReviewChecked2, isReviewChecked3: ReviewChecked3)
                DispatchQueue.main.async {
                    store.tasks.append(task)
                }
            } else {
                print("StudySpaceList - 日期或時間轉換失敗")
            }
        }
    }
    completion("Success")
}

func handleStudyGeneralList(data: Data, store: TodoStore, completion: @escaping (String) -> Void) {
    handleDecodableData(TodoData.self, data: data) { userData in
        for index in userData.todoTitle.indices {
            
            var studyUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime[index]),
               let dueDateTime = convertToDate(userData.dueDateTime[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {

                if (userData.studyUnit[index] == "0" ){
                    studyUnit = "小時"
                } else  if (userData.studyUnit[index] == "1" ) {
                    studyUnit = "次"
                }

                let frequency = userData.frequency[index]
                let recurringUnit = ConvertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus[index]
                let isTodoStatus = ConvertTodoStatus(todoStatus: todoStatus ?? "0")
                
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
                                todoStatus: isTodoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote[index])
                DispatchQueue.main.async {
                    store.todos.append(todo)
                }
            } else {
                print("StudyGeneralList - 日期或時間轉換失敗")
            }
        }
    }
    completion("Success")
}

func handleSportList(data: Data,store: SportStore, completion: @escaping (String) -> Void) {
    handleDecodableData(SportData.self, data: data) { userData in
        for index in userData.todoTitle.indices {

            var sportUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime[index]),
               let dueDateTime = convertToDate(userData.dueDateTime[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {

                if (userData.sportUnit[index] == "0" ){
                    sportUnit = "小時"
                } else  if (userData.sportUnit[index] == "1" ) {
                    sportUnit = "次"
                } else  if (userData.sportUnit[index] == "2" ) {
                    sportUnit = "卡路里"
                }

                let frequency = userData.frequency[index]
                let recurringUnit = ConvertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus[index]
                let isTodoStatus = ConvertTodoStatus(todoStatus: todoStatus ?? "0")

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
                                todoStatus: isTodoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote[index])
                DispatchQueue.main.async {
                    store.sports.append(sport)
                }
            } else {
                print("SportList - 日期或時間轉換失敗")
            }
        }
    }
    completion("Success")
}

func handleDietList(data: Data,store: DietStore, completion: @escaping (String) -> Void) {
    handleDecodableData(DietData.self, data: data) { userData in
        for index in userData.todoTitle.indices {

            if let startDate = convertToDate(userData.startDateTime[index]),
               let dueDateTime = convertToDate(userData.dueDateTime[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {

                let frequency = userData.frequency[index]
                let recurringUnit = ConvertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus[index]
                let isTodoStatus = ConvertTodoStatus(todoStatus: todoStatus ?? "0")
                
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
                                todoStatus: isTodoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote[index])
                DispatchQueue.main.async {
                    store.diets.append(diet)
                }
            } else {
                print("DietList - 日期或時間轉換失敗")
            }
        }
    }
    completion("Success")
}

func handletickersList(data: Data,store: TickerStore, completion: @escaping (String) -> Void) {
    handleDecodableData(TickerData.self, data: data) { userData in
        for index in userData.ticker_id.indices {
            if let deadline = convertToDateTime(userData.deadline[index]) {
                var exchange: String?
                if userData.exchange[index] == nil {
                    exchange = "尚未兌換"
                } else {
                    exchange = (userData.exchange[index]!)
                }
                let taskId = userData.ticker_id[index]
                let task = Ticker(id: taskId, name: userData.name[index], deadline: deadline, exchage: exchange!)

                DispatchQueue.main.async {
                    store.tickers.append(task)
                }

            } else {
                print("TickerList - 尚未兌換")
            }
        }
    }
    completion("Success")
}
