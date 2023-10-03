//
//  AddTask.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/9/29.
//

import Foundation

var frequency:Int = 0
var recurringUnit: String = ""
var recurringOption: Int = 0
var TodoStatus: Bool = false
var todoStatus:Int = 0

func frequency(frequency:Int) {
    if (frequency == 1 ){
        recurringUnit = "每日"
    } else  if (frequency == 2 ) {
        recurringUnit = "每週"
    } else  if (frequency == 3 ) {
        recurringUnit = "每月"
    }
}
func year(dueDateTime:Date,startDate:Date) {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year], from: startDate, to: dueDateTime)
    if let yearsDifference = components.year, yearsDifference >= 5 {
        recurringOption = 2
    } else {
        recurringOption = 1
    }
}
func Status(todoStatus:Int) {
    if (todoStatus  == 0 ){
        TodoStatus = false
    } else {
        TodoStatus = true
    }
}

func toChange(frequency:Int,dueDateTime:Date,startDate:Date,todoStatus:Int){
    
}
func handleStudySpaceAdd(data: Data,store: TaskStore) {
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
            } else {
                print("StudySpaceList - 日期或時間轉換失敗")
            }
        }
    }
}


func handleStudyGeneralAdd(data: Data,store: TodoStore) {
    handleDecodableData(addTodoData.self, data: data) { userData in
        if (userData.message == "User New StudyGeneral successfullyUser New first RecurringInstance successfully") {
            var studyUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime),
               let dueDateTime = convertToDate(userData.dueDateTime),
               let reminderTime = convertToTime(userData.reminderTime) {
                
                frequency = userData.frequency
                todoStatus = userData.todoStatus
                toChange(frequency: frequency,dueDateTime:dueDateTime,startDate:startDate,todoStatus: todoStatus)
                
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
                                todoStatus: TodoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote ?? "")
                DispatchQueue.main.async {
                    store.todos.append(todo)
                    
                }
            } else {
                print("StudyGeneralList - 日期或時間轉換失敗")
            }
            
        }
    }
}

func handleSportAdd(data: Data,store: SportStore) {
    handleDecodableData(addSportData.self, data: data) { userData in
        if (userData.message == "User New Sport successfullyUser New first RecurringInstance successfully") {
            var sportUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime ),
               let dueDateTime = convertToDate(userData.dueDateTime ),
               let reminderTime = convertToTime(userData.reminderTime ) {
                
                frequency = userData.frequency
                todoStatus = userData.todoStatus
                toChange(frequency: frequency,dueDateTime:dueDateTime,startDate:startDate,todoStatus: todoStatus)
                
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
                                  todoStatus: TodoStatus,
                                  dueDateTime: dueDateTime,
                                  reminderTime: reminderTime,
                                  todoNote: userData.todoNote ?? "" )
                DispatchQueue.main.async {
                    store.sports.append(sport)
                }
            } else {
                print("SportList - 日期或時間轉換失敗")
            }
        }
    }
}
func handleDietAdd(data: Data,store: DietStore) {
    handleDecodableData(addDietData.self, data: data) { userData in
        if (userData.message == "User New diet successfullyUser New first RecurringInstance successfully") {
            
            if let startDate = convertToDate(userData.startDateTime ),
               let dueDateTime = convertToDate(userData.dueDateTime ),
               let reminderTime = convertToTime(userData.reminderTime ) {
                
                frequency = userData.frequency
                todoStatus = userData.todoStatus
                toChange(frequency: frequency,dueDateTime:dueDateTime,startDate:startDate,todoStatus: todoStatus)
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
                                todoStatus: TodoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote ?? "" )
                DispatchQueue.main.async {
                    store.diets.append(diet)
                }
            } else {
                print("DietList - 日期或時間轉換失敗")
            }
        }
    }
}
