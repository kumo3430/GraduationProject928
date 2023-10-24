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


enum IndicatorType: String, CaseIterable {
    case week = "週"
    case month = "月"
    case year = "年"
}

enum TaskCategory: String, CaseIterable {
    case generalLearning = "一般學習"
    case spacedLearning = "間隔學習"
    case sport = "運動"
    case diet = "飲食"
    case habits = "習慣"
}

struct HabitTask: Identifiable {
    let id = UUID()
    let name: String
}
class CompletionRatesViewModel: ObservableObject {
    @Published var completionRates: [String: Double] = ["": 0.0]

    func updateCompletionRate(date: Date, newValue: Double) {
        let formattedDate = GraduationProject.formattedDate(date)
        completionRates.updateValue(newValue, forKey: formattedDate)
    }
}
    
struct HabitTrackingIndicatorView: View {
    @State private var selectedCategory = TaskCategory.generalLearning
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @EnvironmentObject var dietStore: DietStore
    @State private var tasks: [HabitTask] = [
        HabitTask(name: "背英文單字"),
        HabitTask(name: "游泳"),
        HabitTask(name: "減糖")
    ]
    @State private var selectedTask: TaskItem?
    
    var body: some View {
        VStack {
            // Header
            Text("習慣追蹤指標")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#6B6B6B"))
                .padding()
            
            // Filter Buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(TaskCategory.allCases, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category.rawValue)
                                .fontWeight(.medium)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(self.selectedCategory == category ? Color(hex: "#3B82F6") : Color.clear)
                                .cornerRadius(10)
                                .foregroundColor(self.selectedCategory == category ? .white : Color(hex: "#6B6B6B").opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical, 10)
            
            // Task List
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(tasksForCategory(selectedCategory).indices, id: \.self) { index in
                        TaskRow(task: tasksForCategory(selectedCategory)[index], selectedTask: $selectedTask, selectedCategory: $selectedCategory)
                    }
                }
                .padding()
            }
            .background(Color(hex: "#EFEFEF").edgesIgnoringSafeArea(.all))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom))
    }
    
    func tasksForCategory(_ category: TaskCategory) -> [Any] {
        switch category {
        case .generalLearning:
            return todoStore.todos // Replace with the actual property from your data store
        case .spacedLearning:
            return taskStore.tasks // Replace with the actual property from your data store
        case .sport:
            return sportStore.sports // Replace with the actual property from your data store
        case .diet:
            return sportStore.sports // Replace with the actual property from your data store
        case .habits:
            return tasks // Replace with your habit tasks array
        }
    }
    
    struct TaskItem: Identifiable {
        var id: Int
        var task: Any
        var name: String
        var targetvalue: Float
        
        init(id: Int, task: Any, taskName: String,targetvalue: Float) {
            self.id = id
            self.task = task
            self.name = taskName
            self.targetvalue = targetvalue
        }
    }
    
    struct TaskRow: View {
        var task: Any
        @State private var id:Int = 0
        @State private var name:String = "TaskName"
        @State private var targetvalue:Float? = 0.0
        @Binding var selectedTask: TaskItem?
        @Binding var selectedCategory: TaskCategory
        var body: some View {
            Button(action: {
                print("印出來的內容：\(task)")
                let result = selectedTaskFromStore(store: task, selectedCategory)
                print("result:\(result)")
                id = result.id
                name = result.name
                targetvalue = result.targetvalue
                print("targetvalue:\(targetvalue)")
                print(type(of: targetvalue))
                let selected = TaskItem(id: id,task: task, taskName: name, targetvalue: targetvalue ?? 0.0)
                $selectedTask.wrappedValue = selected
                print("selectedTask:\(selectedTask)")
                
            }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#91A3B0"))
                        .padding([.leading, .trailing], 15)
                    Text(taskTitle(for: task))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#6B6B6B"))
                        .padding([.top, .bottom, .trailing], 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(item: $selectedTask) { task in
                TaskDetailView(task: task,id: task.id, taskName: task.name, targetvalue: task.targetvalue)
            }
        }
        
        func taskTitle(for task: Any) -> String {
            if let todo = task as? Todo {
                return todo.title
            } else if let task = task as? Task {
                return task.title
            } else if let sport = task as? Sport {
                return sport.title
            } else if let habit = task as? HabitTask {
                return habit.name
            }
            return ""
        }
        
        func selectedTaskFromStore(store: Any, _ category: TaskCategory) -> (id: Int, name: String, targetvalue: Float) {
            
            switch category {
            case .generalLearning:
                return ((store as! Todo).id, (store as! Todo).title, (store as! Todo).studyValue)
            case .spacedLearning:
                return ((store as! Task).id, (store as! Task).title, 0.0)
            case .sport:
                return ((store as! Sport).id, (store as! Sport).title, (store as! Sport).sportValue)
            case .diet:
                return ((store as! Sport).id, (store as! Sport).title, (store as! Sport).sportValue)
            case .habits:
                return (0, "", 0.0)
            }
            
        }
    }
}


struct TaskDetailView: View {
    var task: Any
    var id: Int?
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
            // 這句要改
//            Group {
//                if selectedIndicator == .week {
//                    EnhancedWeekReportView(id: id ?? 0, targetvalue: targetvalue)
//                } else if selectedIndicator == .month {
//                    //                    EnhancedMonthReportView(task: task)
//                    EnhancedMonthReportView(id: id ?? 0, targetvalue: targetvalue)
//                } else if selectedIndicator == .year {
//                    YearIndicatorView(id: id ?? 0, targetvalue: targetvalue)
//                }
//            }
//            .transition(.slide)
            
            ReportView(id: id ?? 0, targetvalue: targetvalue,selectedIndicator: selectedIndicator)
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
//    var completionRates: [String: [Double]] {
//        let rates = [
//            "2023": [0.5, 0.7, 1.0, 0.4, 0.8, 0.6, 0.9, 0.3, 0.6, 0.8, 0.5, 0.7]
//        ]
//        return rates
//    }
    var completionRates: [String: Double] {
        let rates = [
            "一月": 0.5,
            "三月": 0.7,
            "四月": 1.0,
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
//                VStack(spacing: 10) {
//                    let yearString = DateFormatter.dateOnlyFormatter.string(from: selectedDate).prefix(4)
//                    let rates = completionRates[String(yearString)] ?? Array(repeating: 0.0, count: 12)
//                    ForEach(0..<rates.count) { index in
//                        HStack {
//                            Text(months[index])
//                                .font(.system(size: 16, weight: .medium, design: .rounded))
//                                .foregroundColor(.gray)
//                                .frame(alignment: .leading)
//
//                            Spacer()
//
//                            ProgressBar(value: rates[index])
//                                .frame(width: 235, height: 20)
//                                .animation(.easeInOut(duration: 1.0))
//                                .background(Color(hex: "#EFEFEF").cornerRadius(5))
//                                .padding(5)
//                        }
//                        .padding(.vertical, 5)
//                    }
//                }
                VStack(spacing: 10) {
                    ForEach(months, id: \.self) { date in
                        let formattedDate = date
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

struct ReportView: View {
    let id: Int
    let targetvalue: Float?
    let selectedIndicator: IndicatorType
//    let dates: [Date]
//    let completionRates: [String: Double]
    @State private var selectedDate = Date()
    @State private var Instance_id: Int = 0
//    @State private var completionRates: [String: Double] = ["":0.0]
//    @ObservedObject var completionRatesViewModel: CompletionRatesViewModel
    let completionRatesViewModel = CompletionRatesViewModel()
   var formattedDate = ""
    // week
    var datesOfWeek: [String] {
//        var dates: [Date] = []
        var dates: [String] = []
        let calendar = Calendar.current
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: selectedDate) {
                dates.append(GraduationProject.formattedDate(date))
            }
        }
        return dates
    }
    
    // month
    var datesOfMonth: [String] {
        var dates: [String] = []
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        
        guard let startOfMonth = calendar.date(from: components),
              let rangeOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth) else { return dates }
        
        for day in rangeOfMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                dates.append(GraduationProject.formattedDate(date))
            }
        }
        return dates
    }
    
    // year
    let months = [
        "一月", "二月", "三月", "四月",
        "五月", "六月", "七月", "八月",
        "九月", "十月", "十一月", "十二月"
    ]
    func dayList(cycleCategory: IndicatorType) -> ([String]) {
        switch cycleCategory {
        case .week:
            return datesOfWeek
        case .month:
            return datesOfMonth
        case .year:
            return months
        }
    }
    
    var body: some View {
        VStack {
            // 共用部分，如日期選擇和標題
//            DateSelectionView(id:id,targetvalue:targetvalue, selectedIndicator: selectedIndicator, completionRatesViewModel: CompletionRatesViewModel
            DateSelectionView(id: id, targetvalue: targetvalue, selectedIndicator: selectedIndicator, selectedDate: $selectedDate, completionRatesViewModel: completionRatesViewModel)
            
            ScrollView {
                VStack(spacing: 10) {
                    // 這句要改
//                    ForEach(dates, id: \.self) { date in
                       
                    ForEach(dayList(cycleCategory: selectedIndicator), id: \.self) { date in
//                        ForEach(datesOfWeek, id: \.self) { date in   // week
//                        ForEach(datesOfMonth, id: \.self) { date in   // month
                        //ForEach(months, id: \.self) { date in         // year
//                        let formattedDate = date                      //year
//                        let formattedDate = DateFormatter.dateOnlyFormatter.string(from: date)
                        HStack {
//                            Text(self.formattedDate)
                            Text(date)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                                .frame(alignment: .leading)
                            
                            Spacer()
                            
//                            ProgressBar(value: completionRates[formattedDate] ?? 0)
//                            ProgressBar(value: completionRates[date] ?? 0)
                            ProgressBar(value: completionRatesViewModel.completionRates[date] ?? 0)
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
                            print("date: \(GraduationProject.formattedDate(date))")
                            completionRatesViewModel.updateCompletionRate(date: date, newValue: newValue)
                        } else {
                            print("Key is not a valid date")
                        }
                    }
                    print(completionRatesViewModel)
                }
            }
        }
        // 共用部分，如背景和陰影
        .background(Color(hex: "#FAFAFA"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.all, 10)
    }
}

struct DateSelectionView: View {
    let id: Int
    let targetvalue: Float?
    let selectedIndicator: IndicatorType
    @Binding var selectedDate: Date
//    let completionRatesViewModel: CompletionRatesViewModel
    @ObservedObject var completionRatesViewModel: CompletionRatesViewModel
    // 要改成傳進來的方式
    @State private var value = 0
//    @State private var selectedDate = Date()
    @State private var selectedDateToString = ""
    @State private var Instance_id: Int = 0
//    @State private var completionRates: [String: Double] = ["":0.0]

    
    func arrowSelectedDateToString(arrow:String, cycleCategory: IndicatorType) -> String {
        if (arrow == "left") {
            value = -1
        } else if (arrow == "right"){
            value = 1
        } else {
            value = 0
        }
        switch cycleCategory {
        case .week:
            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: value, to: selectedDate) ?? selectedDate
            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: selectedDate)!
            let startOfWeekToString = DateFormatter.weekFormatter.string(from: startOfWeek)
            let endOfWeekToString = DateFormatter.weekFormatter.string(from: endOfWeek)

            return "\(startOfWeekToString) - \(endOfWeekToString)"
        case .month:
            selectedDate = Calendar.current.date(byAdding: .month, value: value, to: selectedDate) ?? selectedDate
            let formattedDate = DateFormatter.monthFormatter.string(from: selectedDate)
            return "\(formattedDate)"
        case .year:
            selectedDate = Calendar.current.date(byAdding: .year, value: value, to: selectedDate) ?? selectedDate
            let formattedDate = DateFormatter.yearFormatter.string(from: selectedDate)
            return "\(formattedDate)"
        }
    }

    var body: some View {
        HStack {
            Button(action: {
                // 左箭頭按鈕操作
//
//                // week
//                selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
//                // month
//                selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
//                // year
//                selectedDate = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? selectedDate
                
                selectedDateToString = arrowSelectedDateToString(arrow:"left", cycleCategory: selectedIndicator)
            }) {
                Image(systemName: "arrow.left")
            }
            
            Spacer()
            
            // week
//            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
//            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: selectedDate)!
//            Text("\(selectedDate, formatter: DateFormatter.weekFormatter) - \(endOfWeek, formatter: DateFormatter.weekFormatter)")
//                .font(.headline)
//                .onTapGesture {
//                    selectedDate = Date()
//                }
//
//            // month
//            Text("\(selectedDate, formatter: DateFormatter.monthFormatter)")
//                .font(.headline)
//                .onTapGesture {
//                    selectedDate = Date()
//                }
//
//            // year
//            Text("\(selectedDate, formatter: DateFormatter.yearFormatter)") // 使用新的年份格式化器
//                .font(.headline)
//                .onTapGesture {
//                    // 点击时返回当前年
//                    selectedDate = Date()
//                }
            
            Text("\(selectedDateToString)")
                .font(.headline)
                .onTapGesture {
                    selectedDate = Date()
                }
            
            Spacer()
            
            Button(action: {
                // 右箭頭按鈕操作
                
                // week
//                selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) ?? selectedDate
//                // month
//                selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
//                // year
//                selectedDate = Calendar.current.date(byAdding: .year, value: 1, to: selectedDate) ?? selectedDate
                
                selectedDateToString = arrowSelectedDateToString(arrow:"right", cycleCategory: selectedIndicator)
            }) {
                Image(systemName: "arrow.right")
            }
        }
        .onAppear() {
            selectedDateToString = arrowSelectedDateToString(arrow:"today", cycleCategory: selectedIndicator)
        }
        .padding()
    }
}

struct HabitTrackingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackingIndicatorView()
    }
}
