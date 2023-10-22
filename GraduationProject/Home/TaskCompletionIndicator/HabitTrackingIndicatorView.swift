//
//  HabitTrackingIndicatorView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/20.
//

import SwiftUI
import Foundation

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum TaskFilter: String, CaseIterable {
    case all = "全部"
    case generalLearning = "一般學習"
    case intervalLearning = "間隔學習"
    case exercise = "運動"
    case diet = "飲食"
    case routine = "作息"
}

enum IndicatorType: String, CaseIterable {
    case week = "週"
    case month = "月"
    case year = "年"
}

struct HabitTask: Identifiable {
    let id = UUID()
    let name: String
}

//struct HabitTrackingIndicatorView: View {
//
//    @EnvironmentObject var taskStore: TaskStore
//    @EnvironmentObject var todoStore: TodoStore
//    @EnvironmentObject var sportStore: SportStore
//    @EnvironmentObject var dietStore: DietStore
//    @State private var selectedFilter = TaskFilter.all
//    //    var selectedFilter = TaskFilter.all
//    @State private var tasks: [HabitTask] = [
//        HabitTask(name: "背英文單字"),
//        HabitTask(name: "游泳"),
//        HabitTask(name: "減糖")
//    ]
//    @State private var id:Int = 0
//    @State private var name:String = "TaskName"
//    @State private var targetvalue:Float? = 0.0
//    @State private var selectedTask: Task?
//    @State private var selectedTodo: Todo?
//    @State private var selectedSport: Sport?
//    @State private var selectedDiet: Diet?
//    @State private var selectedHabitTask: HabitTask?
//
//    var body: some View {
//        VStack {
//            Text("習慣追蹤指標")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .foregroundColor(Color(hex: "#6B6B6B"))
//                .padding()
//            // 上方選單
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 10) {
//                    ForEach(TaskFilter.allCases, id: \.self) { filter in
//                        Button(action: {
//                            selectedFilter = filter
//                            //                            if filter.rawValue == "一般學習" {
//                            //                                self.filteredTasks = todoStore.todos
//                            //                            } else if filter.rawValue == "間隔學習" {
//                            //                                self.filteredTasks = taskStore.tasks
//                            //                            } else if filter.rawValue == "運動" {
//                            //                                self.filteredTasks = sportStore.sports
//                            //                            } else if filter.rawValue == "飲食" {
//                            //                                self.filteredTasks = dietStore.diets
//                            //                            }
//                        }) {
//                            Text(filter.rawValue)
//                                .fontWeight(.medium)
//                                .padding(.horizontal, 20)
//                                .padding(.vertical, 10)
//                                .background(self.selectedFilter == filter ? Color(hex: "#3B82F6") : Color.clear)
//                                .cornerRadius(10)
//                                .foregroundColor(self.selectedFilter == filter ? .white : Color(hex: "#6B6B6B").opacity(0.5))
//                        }
//                    }
//                }
//                .padding(.horizontal, 10)
//            }
//            .padding(.vertical, 10)
//
//            // 下方內容
//            ScrollView {
//                LazyVStack(spacing: 20) { // 增加顶部间距
//
//                    if selectedFilter.rawValue == "一般學習" {
//                        ForEach(todoStore.todos.indices, id: \.self){ task in
//                            Button(action: {
//                                print(todoStore.todos[task])
//                                selectedTodo = todoStore.todos[task]
//                                id = todoStore.todos[task].id
//                                name = todoStore.todos[task].title
//                                targetvalue = todoStore.todos[task].studyValue
//                            }) {
//                                HStack {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(Color(hex: "#91A3B0"))
//                                        .padding([.leading, .trailing], 15) // 增加左右间距
//
//                                    Text(todoStore.todos[task].title)
//                                        .fontWeight(.medium)
//                                        .foregroundColor(Color(hex: "#6B6B6B"))
//                                        .padding([.top, .bottom, .trailing], 15) // 增加按钮高度
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            .sheet(item: $selectedTodo) { task in
//                                TaskDetailView(task: selectedTodo,id: id, taskName: name,targetvalue: targetvalue)
//                            }
//                        }
//                    } else if selectedFilter.rawValue == "間隔學習" {
//                        ForEach(taskStore.tasks.indices, id: \.self) { task in
//                            Button(action: {
//                                print(taskStore.tasks[task])
//                                selectedTask = taskStore.tasks[task]
//                                id = taskStore.tasks[task].id
//                                name = taskStore.tasks[task].title
//                            }) {
//                                HStack {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(Color(hex: "#91A3B0"))
//                                        .padding([.leading, .trailing], 15) // 增加左右间距
//
//                                    Text(taskStore.tasks[task].title)
//                                        .fontWeight(.medium)
//                                        .foregroundColor(Color(hex: "#6B6B6B"))
//                                        .padding([.top, .bottom, .trailing], 15) // 增加按钮高度
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            .sheet(item: $selectedTask) { task in
//                                TaskDetailView(task: selectedTask,id: id, taskName: name,targetvalue: 0)
//                            }
//                        }
//                    } else if selectedFilter.rawValue == "運動" {
//                        ForEach(sportStore.sports.indices, id: \.self) { task in
//                            Button(action: {
//                                print(sportStore.sports[task])
//                                selectedSport = sportStore.sports[task]
//                                id = sportStore.sports[task].id
//                                name = sportStore.sports[task].title
//                                targetvalue = sportStore.sports[task].sportValue
//                            }) {
//                                HStack {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(Color(hex: "#91A3B0"))
//                                        .padding([.leading, .trailing], 15) // 增加左右间距
//
//                                    Text(sportStore.sports[task].title)
//                                        .fontWeight(.medium)
//                                        .foregroundColor(Color(hex: "#6B6B6B"))
//                                        .padding([.top, .bottom, .trailing], 15) // 增加按钮高度
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            .sheet(item: $selectedSport) { task in
//                                TaskDetailView(task: selectedSport,id: id, taskName: name, targetvalue: targetvalue)
//                            }
//                        }
//                    } else if selectedFilter.rawValue == "飲食" {
//                        ForEach(sportStore.sports.indices, id: \.self) { task in
//                            Button(action: {
//                                print(sportStore.sports[task])
//                                selectedSport = sportStore.sports[task]
//                                id = sportStore.sports[task].id
//                                name = sportStore.sports[task].title
//                                targetvalue = sportStore.sports[task].sportValue
//                            }) {
//                                HStack {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(Color(hex: "#91A3B0"))
//                                        .padding([.leading, .trailing], 15) // 增加左右间距
//
//                                    Text(sportStore.sports[task].title)
//                                        .fontWeight(.medium)
//                                        .foregroundColor(Color(hex: "#6B6B6B"))
//                                        .padding([.top, .bottom, .trailing], 15) // 增加按钮高度
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            .sheet(item: $selectedTask) { task in
//                                TaskDetailView(task: selectedSport,id: id, taskName: name, targetvalue: targetvalue)
//                            }
//                        }
//                    } else {
//                        ForEach(tasks) { task in
//                            Button(action: {
//                                print(task)
//                                selectedHabitTask = task
//                            }) {
//                                HStack {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(Color(hex: "#91A3B0"))
//                                        .padding([.leading, .trailing], 15) // 增加左右间距
//
//                                    Text(task.name)
//                                        .fontWeight(.medium)
//                                        .foregroundColor(Color(hex: "#6B6B6B"))
//                                        .padding([.top, .bottom, .trailing], 15) // 增加按钮高度
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            .sheet(item: $selectedHabitTask) { task in
//                                TaskDetailView(task: task,id: 1, taskName: task.name, targetvalue: 0)
//                            }
//                        }
//                    }
//
//                }
//                .padding() // 统一增加四周间距
//            }
//            .background(Color(hex: "#EFEFEF").edgesIgnoringSafeArea(.all))
//            .cornerRadius(10)
//
//            Spacer()
//
//        }
//        .padding()
//        .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom))
//    }
//}

struct HabitTrackingIndicatorView: View {
    @State private var id:Int = 0
    @State private var name:String = "TaskName"
    @State private var targetvalue:Float? = 0.0
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @EnvironmentObject var dietStore: DietStore
    @State private var selectedFilter = TaskFilter.all
    @State private var tasks: [HabitTask] = [
        HabitTask(name: "背英文單字"),
        HabitTask(name: "游泳"),
        HabitTask(name: "減糖")
    ]
    // 初始化虚拟任务列表
//     @State private var tasks: [Task] = [
//         Task(id: 1, title: "Task 1", studyValue: 10.0),
//         Task(id: 2, title: "Task 2", studyValue: 15.0),
//         Task(id: 3, title: "Task 3", studyValue: 12.5)
//     ]
    
    var body: some View {
        VStack {
            Text("習慣追蹤指標")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#6B6B6B"))
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(TaskFilter.allCases, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter.rawValue)
                                .fontWeight(.medium)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(self.selectedFilter == filter ? Color(hex: "#3B82F6") : Color.clear)
                                .cornerRadius(10)
                                .foregroundColor(self.selectedFilter == filter ? .white : Color(hex: "#6B6B6B").opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical, 10)
            
            ScrollView {
                LazyVStack(spacing: 20) { // 增加顶部间距

                    if selectedFilter.rawValue == "一般學習" {
                        ForEach(todoStore.todos.indices, id: \.self){ task in
                            Button(action: {
//                                let result = selectClass(id: task, taskClass: selectedFilter.rawValue)
                                let result = selectedTaskFromStore(store: todoStore.todos, id: task, taskClass: selectedFilter.rawValue)
                                selectedTodo = result.task
                                id = result.id
                                name = result.name
                                targetvalue = result.targetvalue
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "#91A3B0"))
                                        .padding([.leading, .trailing], 15) // 增加左右间距

                                    Text(todoStore.todos[task].title)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color(hex: "#6B6B6B"))
                                        .padding([.top, .bottom, .trailing], 15) // 增加按钮高度
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .sheet(item: $selectedTodo) { task in
                                TaskDetailView(task: selectedTodo,id: id, taskName: name,targetvalue: targetvalue)
                            }
                        }
                    } else if selectedFilter.rawValue == "間隔學習" {
                        ForEach(taskStore.tasks.indices, id: \.self) { task in
                            Button(action: {
//                                let result = selectClass(id: task, taskClass: selectedFilter.rawValue)
                                let result = selectedTaskFromStore(store: taskStore.tasks, id: task, taskClass: selectedFilter.rawValue)
                                selectedTask = result.task
                                id = result.id
                                name = result.name
                                targetvalue = result.targetvalue
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "#91A3B0"))
                                        .padding([.leading, .trailing], 15) // 增加左右间距

                                    Text(taskStore.tasks[task].title)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color(hex: "#6B6B6B"))
                                        .padding([.top, .bottom, .trailing], 15) // 增加按钮高度
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .sheet(item: $selectedTask) { task in
                                TaskDetailView(task: selectedTask,id: id, taskName: name,targetvalue: 0)
                            }
                        }
                    } else if selectedFilter.rawValue == "運動" {
                        ForEach(sportStore.sports.indices, id: \.self) { task in
                            Button(action: {
//                                let result = selectClass(id: task, taskClass: selectedFilter.rawValue)
                                let result = selectedTaskFromStore(store: sportStore.sports, id: task, taskClass: selectedFilter.rawValue)
                                selectedSport = result.task
                                id = result.id
                                name = result.name
                                targetvalue = result.targetvalue
                                print(result)
                                print("selectedTask:\(selectedSport)")
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "#91A3B0"))
                                        .padding([.leading, .trailing], 15) // 增加左右间距

                                    Text(sportStore.sports[task].title)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color(hex: "#6B6B6B"))
                                        .padding([.top, .bottom, .trailing], 15) // 增加按钮高度
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .sheet(item: $selectedSport) { task in
                                TaskDetailView(task: selectedSport,id: id, taskName: name, targetvalue: targetvalue)
                            }
                        }
                    } else if selectedFilter.rawValue == "飲食" {
                        ForEach(sportStore.sports.indices, id: \.self) { task in
                            Button(action: {
//                                let result = selectClass(id: id, taskClass: selectedFilter.rawValue)
                                let result = selectedTaskFromStore(store: sportStore.sports, id: task, taskClass: selectedFilter.rawValue)
                                selectedSport = result.task
                                id = result.id
                                name = result.name
                                targetvalue = result.targetvalue
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "#91A3B0"))
                                        .padding([.leading, .trailing], 15) // 增加左右间距

                                    Text(sportStore.sports[task].title)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color(hex: "#6B6B6B"))
                                        .padding([.top, .bottom, .trailing], 15) // 增加按钮高度
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .sheet(item: $selectedTask) { task in
                                TaskDetailView(task: selectedTask,id: id, taskName: name, targetvalue: targetvalue)
                            }
                        }
                    } else {
                        ForEach(tasks) { task in
                            Button(action: {
                                print(task)
                                selectedHabitTask = task
//                                selectedTask = task
//                                let result = selectClass(id: 1, taskClass: selectedFilter.rawValue)
//                                selectedTask = result.task
//                                id = result.id
//                                name = result.name
//                                targetvalue = result.targetvalue
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "#91A3B0"))
                                        .padding([.leading, .trailing], 15) // 增加左右间距

                                    Text(task.name)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color(hex: "#6B6B6B"))
                                        .padding([.top, .bottom, .trailing], 15) // 增加按钮高度
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .sheet(item: $selectedHabitTask) { task in
                                TaskDetailView(task: task,id: 1, taskName: name, targetvalue: 0)
                            }
                        }
                    }

                }
                .padding() // 统一增加四周间距
            }
            .background(Color(hex: "#EFEFEF").edgesIgnoringSafeArea(.all))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom))
    }
    
//    var filteredTasks: [Task] {
//        switch selectedFilter {
//        case .all:
//            return tasks
//        case .generalLearning:
//            return todoStore.todos
//        case .spacedRepetition:
//            return taskStore.tasks
//        case .exercise:
//            return sportStore.sports
//        case .diet:
//            return dietStore.diets
//        }
//    }
    
    func selectedTaskFromStore<T>(store: [T], id: Int, taskClass: String) -> (task: T?, id: Int, name: String, targetvalue: Float) {
        guard id >= 0 && id < store.count else {
            return (nil, 0, "", 0.0)
        }

        let selectedTask = store[id]

        if let todo = selectedTask as? Todo, taskClass == "一般學習" {
            return (todo as? T, todo.id, todo.title, todo.studyValue)
        } else if let task = selectedTask as? Task, taskClass == "間隔學習" {
            return (task as? T, task.id, task.title, 0.0)
        } else if let sport = selectedTask as? Sport, (taskClass == "運動" || taskClass == "飲食") {
            return (sport as? T, sport.id, sport.title, sport.sportValue)
        } else {
            return (nil, 0, "", 0.0)
        }
    }
    
//    func selectClass(id: Int, taskClass: String) -> (task: Any, id: Int, name: String, targetvalue: Float) {
//        var selectedTask: Any?
//        var taskId: Int = 0
//        var taskName: String = ""
//        var taskTargetValue: Float = 0.0
//
//        switch taskClass {
//        case "一般學習":
//            if id < todoStore.todos.count && id >= 0 {
//                selectedTask = todoStore.todos[id]
//                taskId = todoStore.todos[id].id
//                taskName = todoStore.todos[id].title
//                taskTargetValue = todoStore.todos[id].studyValue
//            }
//        case "間隔學習":
//            if id < taskStore.tasks.count && id >= 0 {
//                selectedTask = taskStore.tasks[id]
//                taskId = taskStore.tasks[id].id
//                taskName = taskStore.tasks[id].title
//                // 不需要设置 taskTargetValue
//            }
//        case "運動":
//            if id < sportStore.sports.count && id >= 0 {
//                selectedTask = sportStore.sports[id]
//                taskId = sportStore.sports[id].id
//                taskName = sportStore.sports[id].title
//                taskTargetValue = sportStore.sports[id].sportValue
//            }
//        case "飲食":
//            if id < sportStore.sports.count && id >= 0 {
//                selectedTask = sportStore.sports[id]
//                taskId = sportStore.sports[id].id
//                taskName = sportStore.sports[id].title
//                taskTargetValue = sportStore.sports[id].sportValue
//            }
//        default:
//            selectedTask = nil
//        }
//
//        return (selectedTask, taskId, taskName, taskTargetValue)
//    }

    
//    func selectClass(id: Int, taskClass: String) -> (task:Any, id: Int, name: String, targetvalue: Float) {
//        switch  taskClass {
//        case "一般學習":
//            print(todoStore.todos[id])
//            let selectedTodo = todoStore.todos[id]
//            let id = todoStore.todos[id].id
//            let name = todoStore.todos[id].title
//            let targetvalue = todoStore.todos[id].studyValue
//            return (selectedTodo,id, name, targetvalue)
//        case "間隔學習":
//            print(taskStore.tasks[id])
//            let selectedTask = taskStore.tasks[id]
//            let id = taskStore.tasks[id].id
//            let name = taskStore.tasks[id].title
//            return (selectedTask,id, name, 0.0)
//        case "運動":
//            print(sportStore.sports[id])
//            let selectedSport = sportStore.sports[id]
//            let id = sportStore.sports[id].id
//            let name = sportStore.sports[id].title
//            let targetvalue = sportStore.sports[id].sportValue
//            return (selectedSport,id, name, targetvalue)
//        case "飲食":
//            print(sportStore.sports[id])
//            let selectedSport = sportStore.sports[id]
//            let id = sportStore.sports[id].id
//            let name = sportStore.sports[id].title
//            let targetvalue = sportStore.sports[id].sportValue
//            return (selectedSport,id, name, targetvalue)
//        default:
//            return ([HabitTask].self,1,"TaskName",0)
//        }
//    }


//    var filteredTasks: [Task] {
//        switch selectedFilter {
//        case .all:
//            return tasks
//        case .generalLearning:
//            return todoStore.todos.map { todo in
//                Task(id: todo.id, title: todo.title, studyValue: todo.studyValue)
//            }
//        case .spacedRepetition:
//            return taskStore.tasks.map { task in
//                Task(id: task.id, title: task.title, studyValue: task.studyValue)
//            }
//        case .exercise:
//            return sportStore.sports.map { sport in
//                Task(id: sport.id, title: sport.title, studyValue: sport.sportValue)
//            }
//        case .diet:
//            return dietStore.diets.map { diet in
//                Task(id: diet.id, title: diet.title, studyValue: 0.0)
//            }
//        }
//    }
    @State private var selectedTodo: Todo?
    @State private var selectedTask: Task?
//    @State private var selectedTask: Task?
    @State private var selectedSport: Sport?
    @State private var selectedHabitTask: HabitTask?
}


struct TaskDetailView: View {
    var task: Any
    var id: Int
    var taskName: String
    var targetvalue: Float? = 0.0
    @State private var selectedIndicator = IndicatorType.week
    
    var body: some View {
        VStack(spacing: 20) {
            Text(taskName)
                .font(.system(size: 30, weight: .semibold, design: .default))
                .foregroundColor(Color(hex: "#4A4A4A"))
                .padding(.top, 20)
            
            Picker("Indicator", selection: $selectedIndicator) {
                ForEach(IndicatorType.allCases, id: \.self) { indicator in
                    Text(indicator.rawValue).tag(indicator)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 10)
            .background(Color(hex: "#EFEFEF"))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
            
                Group {
                if selectedIndicator == .week {
                    EnhancedWeekReportView(id: id, targetvalue: targetvalue)
                } else if selectedIndicator == .month {
                    //                    EnhancedMonthReportView(task: task)
                    EnhancedMonthReportView(id: id, targetvalue: targetvalue)
                } else if selectedIndicator == .year {
                    YearIndicatorView(id: id, targetvalue: targetvalue)
                }
            }
            .transition(.slide)
            
            Spacer()
        }
        .onAppear() {
            print(task)
        }
        .padding()
        .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom))
    }
}

extension DateFormatter {
    static let weekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年M月d日"
        return formatter
    }()
    
    static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        formatter.dateFormat = "YYYY年MM月"
        return formatter
    }()
    static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年"
        return formatter
    }()
}

struct EnhancedWeekReportView: View {
    
    let id: Int
    let targetvalue: Float?
    @State private var selectedDate = Date()
    @State private var Instance_id: Int = 0
    @State private var completionRates: [String: Double] = ["":0.0]
    
    var datesOfWeek: [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: selectedDate) {
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "arrow.left")
                }
                
                Spacer()
                
                let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
                let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: selectedDate)!
                Text("\(selectedDate, formatter: DateFormatter.weekFormatter) - \(endOfWeek, formatter: DateFormatter.weekFormatter)")
                    .font(.headline)
                    .onTapGesture {
                        selectedDate = Date()
                    }
                
                Spacer()
                
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "arrow.right")
                }
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(datesOfWeek, id: \.self) { date in
                        let formattedDate = DateFormatter.dateOnlyFormatter.string(from: date)
                        HStack {
                            Text(formattedDate)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                                .frame(alignment: .leading)
                            
                            Spacer()
                            
                            ProgressBar(value: completionRates[formattedDate] ?? 0)
                                .frame(width: 235, height: 20)
                                .animation(.easeInOut(duration: 1.0))
                                .background(Color(hex: "#EFEFEF").cornerRadius(5))
                                .padding(5)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.all, 10)
            }
            .frame(width: 325)
        }
        .onAppear() {
            TrackingFirstDay(id:id) { selectedDate, instanceID in
                self.selectedDate = selectedDate
                self.Instance_id = instanceID
                RecurringCheckList(id:instanceID, targetvalue:targetvalue!) { message in
                    for (key, value) in message {
                        print("message: \(message)")
                        print("Key: \(key), Value: \(value)")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd" // 设置日期格式，确保与日期字符串的格式匹配
                        if let date = dateFormatter.date(from: key) {
                            let floatValue = Double(value)
                            let target = targetvalue ?? 1.0 // 使用默认值或其他逻辑来获取 targetvalue
                            let newValue = floatValue! / Double(target)
                            print("newValue: \(newValue)")
                            print("date: \(formattedDate(date))")
                            completionRates.updateValue(newValue, forKey: formattedDate(date))
                        } else {
                            print("Key is not a valid date")
                        }
                    }
                    print(completionRates)
                }
            }
        }
        .background(Color(hex: "#FAFAFA"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.all, 10)
    }
}
//func TrackingFirstDay(id: Int, completion: @escaping (Date, Int) -> Void) {
//    let body = ["id": id] as [String : Any]
//    phpUrl(php: "TrackingFirstDay" ,type: "Tracking",body:body,store: nil) { message in
//        for (key, value) in message {
//            if let selectedDate = convertToDate(key), let Instance_id = Int(value) {
//                completion(selectedDate, Instance_id)
//            }
//            
//        }
//    }
//}
//
//
//func RecurringCheckList(id: Int,targetvalue:Float,completion: @escaping ([String:String]) -> Void) {
//    let body = ["id": id] as [String : Any]
//    phpUrl(php: "RecurringCheckList", type: "Tracking", body: body, store: nil) { message in
//        completion(message)
//    }
//}

struct EnhancedMonthReportView: View {
    //    let task: HabitTask
    @State private var selectedDate = Date()
    let id: Int
    let targetvalue: Float?
    var completionRates: [String: Double] {
        let rates = [
            "2023-10-01": 0.5,
            "2023-10-02": 0.7,
            "2023-10-03": 1.0,
        ]
        return rates
    }
    
    var datesOfMonth: [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        
        guard let startOfMonth = calendar.date(from: components),
              let rangeOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth) else { return dates }
        
        for day in rangeOfMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "arrow.left")
                }
                
                Spacer()
                
                Text("\(selectedDate, formatter: DateFormatter.monthFormatter)")
                    .font(.headline)
                    .onTapGesture {
                        selectedDate = Date()
                    }
                
                Spacer()
                
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "arrow.right")
                }
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(datesOfMonth, id: \.self) { date in
                        let formattedDate = DateFormatter.dateOnlyFormatter.string(from: date)
                        HStack {
                            Text(formattedDate)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                                .frame(alignment: .leading)
                            
                            Spacer()
                            
                            ProgressBar(value: completionRates[formattedDate] ?? 0)
                                .frame(width: 235, height: 20)
                                .animation(.easeInOut(duration: 1.0))
                                .background(Color(hex: "#EFEFEF").cornerRadius(5))
                                .padding(5)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.all, 10)
            }
            .frame(width: 325)
        }
        .background(Color(hex: "#FAFAFA"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.all, 10)
    }
}

struct YearIndicatorView: View {
    //    let task: HabitTask
    @State private var selectedDate = Date()
    let id: Int
    let targetvalue: Float?
    var completionRates: [String: [Double]] {
        let rates = [
            "2023": [0.5, 0.7, 1.0, 0.4, 0.8, 0.6, 0.9, 0.3, 0.6, 0.8, 0.5, 0.7]
        ]
        return rates
    }
    
    let months = [
        "一月", "二月", "三月", "四月",
        "五月", "六月", "七月", "八月",
        "九月", "十月", "十一月", "十二月"
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 减少一年
                    selectedDate = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "arrow.left")
                }
                
                Spacer()
                
                Text("\(selectedDate, formatter: DateFormatter.yearFormatter)") // 使用新的年份格式化器
                    .font(.headline)
                    .onTapGesture {
                        // 点击时返回当前年
                        selectedDate = Date()
                    }
                
                Spacer()
                
                Button(action: {
                    // 增加一年
                    selectedDate = Calendar.current.date(byAdding: .year, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "arrow.right")
                }
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 10) {
                    let yearString = DateFormatter.dateOnlyFormatter.string(from: selectedDate).prefix(4)
                    let rates = completionRates[String(yearString)] ?? Array(repeating: 0.0, count: 12)
                    ForEach(0..<rates.count) { index in
                        HStack {
                            Text(months[index])
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                                .frame(alignment: .leading)
                            
                            Spacer()
                            
                            ProgressBar(value: rates[index])
                                .frame(width: 235, height: 20)
                                .animation(.easeInOut(duration: 1.0))
                                .background(Color(hex: "#EFEFEF").cornerRadius(5))
                                .padding(5)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.all, 10)
            }
            .frame(width: 325)
        }
        .background(Color(hex: "#FAFAFA"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.all, 10)
    }
}

struct ProgressBar: View {
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(hex: "#E0E0E0"))
                    .cornerRadius(5)
                
                Rectangle()
                    .fill(Color(hex: "#91A3B0"))
                    .cornerRadius(5)
                    .frame(width: geometry.size.width * CGFloat(value))
            }
        }
        .overlay(
            Text("\(Int(value * 100))%")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "#6B6B6B"))
        )
    }
}

struct HabitTrackingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackingIndicatorView()
    }
}
