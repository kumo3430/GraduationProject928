//
//  TodoManager.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import Foundation

enum Action: Int, Identifiable {
    var id: Int { rawValue }
    
    case generalLearning = 1
    case spacedLearning
    case sport
    case routine
    case diet
}
struct UserData: Decodable {
    var id: String
    var userName: String
    var email: String
    var create_at: String
    var message: String
}
struct ReviseData: Decodable {
    var todo_id: Int
    var label: String
    var reminderTime: String
    var dueDateTime: String?
    var todoNote: String?
    var message: String
}

struct UpdateValueData: Decodable {
    var todo_id: Int
    var RecurringStartDate: String
    var RecurringEndDate: String
    var completeValue: Float
    var message: String
}

struct TaskData: Decodable {
    var todo_id: [String]
    var userId: String?
    var category_id: Int
    var todoTitle: [String]
    var todoIntroduction: [String]
    var todoLabel: [String?]
    var startDateTime: [String]
    var reminderTime: [String]
    var repetition1Status: [String?]
    var repetition2Status: [String?]
    var repetition3Status: [String?]
    var repetition4Status: [String?]
    var repetition1Count: [String]
    var repetition2Count: [String]
    var repetition3Count: [String]
    var repetition4Count: [String]
    var todoStatus: [String]
    var message: String
}

struct TodoData: Decodable {
    var userId: String?
    var todo_id: [String]

    var category_id: Int
    var todoTitle: [String]
    var todoIntroduction: [String]
    var todoLabel: [String?]
    var startDateTime: [String]
    
    var studyValue: [String]
    var studyUnit: [String]
    
    var frequency: [String]
    var reminderTime: [String]
    var todoStatus: [String?]
    var dueDateTime: [String]
    var todoNote: [String]
    
    var RecurringStartDate: [String]
    var RecurringEndDate: [String]
    var completeValue: [String]

    var message: String
}

struct SportData: Decodable {
    var userId: String?
    var todo_id: [String]
    
    var category_id: Int
    var todoTitle: [String]
    var todoIntroduction: [String]
    var todoLabel: [String?]
    var startDateTime: [String]
    
    var sportType: [String]
    var sportValue: [String]
    var sportUnit: [String]
    
    var frequency: [String]
    var reminderTime: [String]
    var todoStatus: [String?]
    var dueDateTime: [String]
    var todoNote: [String]
    
    var RecurringStartDate: [String]
    var RecurringEndDate: [String]
    var completeValue: [String]
    
    var message: String
}

struct DietData: Decodable {
    var userId: String?
    var todo_id: [String]
    
    var category_id: Int
    var todoTitle: [String]
    var todoIntroduction: [String]
    var todoLabel: [String?]
    var startDateTime: [String]
    
    var dietsType: [String]
    var dietsValue: [String]
    
    var frequency: [String]
    var reminderTime: [String]
    var todoStatus: [String?]
    var dueDateTime: [String]
    var todoNote: [String]
    
    var RecurringStartDate: [String]
    var RecurringEndDate: [String]
    var completeValue: [String]
    
    var message: String
}

struct TickerData: Decodable {
    var userId: String?
    var ticker_id: [String]
    var name: [String]
    var deadline: [String]
    var exchange: [String?]
    var message: String
}
struct addTaskData : Decodable {
    var userId: String?
    //        var id: Int
    var category_id: Int
    var todoLabel: String?
    var todoTitle: String
    var todoIntroduction: String
    var startDateTime: String
    var reminderTime: String
    var todo_id: Int
    var repetition1Count: String
    var repetition2Count: String
    var repetition3Count: String
    var repetition4Count: String
    
    var message: String
}
struct addTodoData : Decodable {
    var userId: String?
    var category_id: Int
    var todoLabel: String?
    var todoTitle: String
    var todoIntroduction: String
    var startDateTime: String
    
    var studyValue: Float
    var studyUnit: Int
    
    var frequency: Int
    var todoStatus: Int
    var reminderTime: String
    var dueDateTime: String
    var todo_id: Int
    var todoNote: String?
    var message: String
}
struct addSportData : Decodable {
    var userId: String?
    var category_id: Int
    var todoLabel: String?
    var todoTitle: String
    var todoIntroduction: String
    var startDateTime: String
    
    var sportType: String
    var sportValue: Float
    var sportUnit: Int
    
    var frequency: Int
    var todoStatus: Int
    var reminderTime: String
    var dueDateTime: String
    var todo_id: Int
    var todoNote: String?
    var message: String
}
struct addDietData: Decodable {
    var userId: String?
    var category_id: Int
    var todoLabel: String?
    var todoTitle: String
    var todoIntroduction: String
    var startDateTime: String
    
    var dietType: String
    var dietValue: Int
    
    var todoStatus: Int
    var reminderTime: String
    var frequency: Int
    var dueDateTime: String
    var todo_id: Int
    var todoNote: String?
    var message: String
}

struct FirstDay: Decodable {
    var id: Int
    var todo_id: Int
    var RecurringStartDate: String
    var message: String
}

struct CheckList: Decodable {
    var checkDate: [String]
    var completeValue: [String]
    var message: String
}
class TodoStore: ObservableObject {
    //    @Published var todos = [Todo]()
    @Published var todos: [Todo] = []
    
    func todosForDate(_ date: Date) -> [Todo] {
        let filteredTodos = todos.filter { todo in
            return isDate(date, inRangeOf: todo.startDateTime, and: todo.dueDateTime, description: todo.description)
        }
        return filteredTodos
    }
    
    func isDate(_ date: Date, inRangeOf startDate: Date, and endDate: Date, description: String) -> Bool {
        return date >= startDate && date <= endDate
            || Calendar.current.isDate(date, inSameDayAs: startDate)
            || Calendar.current.isDate(date, inSameDayAs: endDate)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTodos() {
        todos = []
    }
}


class TaskStore: ObservableObject {
    // 具有一個已發佈的 tasks 屬性，該屬性存儲任務的數組
    @Published var tasks: [Task] = []
    // 根據日期返回相應的任務列表
    func tasksForDate(_ date: Date) -> [Task] {
        let formattedSelectedDate = formattedDate(date)
        let filteredTasks = tasks.filter { task in
            return formattedSelectedDate == formattedDate(task.nextReviewDate) ||
            formattedSelectedDate == formattedDate(task.repetition1Count) ||
            formattedSelectedDate == formattedDate(task.repetition2Count) ||
            formattedSelectedDate == formattedDate(task.repetition3Count) ||
            formattedSelectedDate == formattedDate(task.repetition4Count)
        }
        return filteredTasks
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTasks() {
        tasks = []
    }
}

class SportStore: ObservableObject {
    //    @Published var todos = [Todo]()
    @Published var sports: [Sport] = []
    
    func sportsForDate(_ date: Date) -> [Sport] {
        let filteredTodos = sports.filter { todo in
            return isDate(date, inRangeOf: todo.startDateTime, and: todo.dueDateTime)
        }
        return filteredTodos
    }
    
    func isDate(_ date: Date, inRangeOf startDate: Date, and endDate: Date) -> Bool {
        return date >= startDate && date <= endDate
            || Calendar.current.isDate(date, inSameDayAs: startDate)
            || Calendar.current.isDate(date, inSameDayAs: endDate)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTodos() {
        sports = []
    }
    func updateSport(withID id: Int, newValue: Float) {
           if let index = sports.firstIndex(where: { $0.id == id }) {
               sports[index].completeValue = newValue
           }
       }
}

class DietStore: ObservableObject {
    @Published var diets: [Diet] = []
    
    func dietForDate(_ date: Date) -> [Diet] {
        let filteredDiets = diets.filter { diet in
            return isDate(date, inRangeOf: diet.startDateTime, and: diet.dueDateTime)
        }
        return filteredDiets
    }
    
    func isDate(_ date: Date, inRangeOf startDate: Date, and endDate: Date) -> Bool {
        return date >= startDate && date <= endDate
            || Calendar.current.isDate(date, inSameDayAs: startDate)
            || Calendar.current.isDate(date, inSameDayAs: endDate)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTodos() {
        diets = []
    }
}

class SleepStore: ObservableObject {
    @Published var sleeps: [Sleep] = []
    
    func sleepsForDate(_ date: Date) -> [Sleep] {
        let filteredSleeps = sleeps.filter { sleep in
            return isDate(date, inRangeOf: sleep.bedtime, and: sleep.wakeTime)
        }
        return filteredSleeps
    }
    
    func isDate(_ date: Date, inRangeOf startDate: Date, and endDate: Date) -> Bool {
        return date >= startDate && date <= endDate
            || Calendar.current.isDate(date, inSameDayAs: startDate)
            || Calendar.current.isDate(date, inSameDayAs: endDate)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func clearSleeps() {
        sleeps = []
    }
}

class TickerStore: ObservableObject {
    //    @Published var todos = [Todo]()
    @Published var tickers: [Ticker] = []
    
    func tickersForDate(_ date: Date) -> [Ticker] {
           let formattedSelectedDate = formattedDate(date)
           let filteredTickers = tickers.filter { ticker in
               return formattedSelectedDate == formattedDate(ticker.deadline)
           }
           return filteredTickers
       }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTodos() {
        tickers = []
    }
}
