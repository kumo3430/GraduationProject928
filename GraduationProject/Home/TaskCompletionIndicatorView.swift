//
//  TaskCompletionIndicator.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI
import Foundation

struct TaskInfo {
    var title: String
    var date: Date
    var completedTasks: Int
    var totalTasks: Int
    var dailyTasks: [(Int, Int)]
}

enum TimeIndicator: String, CaseIterable, Identifiable {
    case week = "週指標"
    case month = "月指標"
    case year = "年指標"
    
    var id: String { self.rawValue }
}

struct TimeIndicatorPicker: View {
    @Binding var selectedIndicator: TimeIndicator
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(TimeIndicator.allCases) { indicator in
                    Text(indicator.rawValue)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(indicator == selectedIndicator ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(indicator == selectedIndicator ? .white : .gray)
                        .cornerRadius(20)
                        .onTapGesture {
                            selectedIndicator = indicator
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct TaskCompletionIndicatorView: View {
    @State private var selectedIndicator: TimeIndicator = .week
    @State private var selectedDate: Date = Date()
    
    let tasksByDate: [TaskInfo] = [
        TaskInfo(title: "日", date: Date(timeIntervalSince1970: 1666940370.91056), completedTasks: 10, totalTasks: 10, dailyTasks: []),
        TaskInfo(title: "週", date: Date(timeIntervalSince1970: 1681290092.910595), completedTasks: 25, totalTasks: 25, dailyTasks: Array(repeating: (7, 7), count: 7)),
        TaskInfo(title: "月", date: Date(timeIntervalSince1970: 1692800674.910603), completedTasks: 15, totalTasks: 30, dailyTasks: Array(repeating: (2, 3), count: 30))
    ]
    
    let tasksByEvent: [TaskInfo] = [
        TaskInfo(title: "A事件", date: Date(timeIntervalSince1970: 1677140165.910656), completedTasks: 4, totalTasks: 10, dailyTasks: []),
        TaskInfo(title: "B事件", date: Date(timeIntervalSince1970: 1665865885.910686), completedTasks: 8, totalTasks: 10, dailyTasks: []),
        TaskInfo(title: "C事件", date: Date(timeIntervalSince1970: 1668463267.910706), completedTasks: 7, totalTasks: 10, dailyTasks: [])
    ]
    
    var dateRangeForIndicator: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        switch selectedIndicator {
        case .week:
            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
            return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
        case .month:
            let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
            let endOfMonth = Calendar.current.date(byAdding: .month, value: 1, to: startOfMonth)!
            return "\(formatter.string(from: startOfMonth)) - \(formatter.string(from: endOfMonth))"
        case .year:
            let startOfYear = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: selectedDate))!
            let endOfYear = Calendar.current.date(byAdding: .year, value: 1, to: startOfYear)!
            return "\(formatter.string(from: startOfYear)) - \(formatter.string(from: endOfYear))"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text("待辦事項完成指標")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                    .foregroundColor(Color.primary.opacity(0.8))
                    
                // Time Indicator Picker
                TimeIndicatorPicker(selectedIndicator: $selectedIndicator)
                
                // Date Navigation
                DateNavigator(selectedDate: $selectedDate, dateRange: dateRangeForIndicator)
                    
                // Tasks Bar Graph
                TasksBarGraph(tasks: tasksByDate, indicator: selectedIndicator)
                    
            }
            .padding(.bottom, 20)
            .background(LinearGradient(gradient: Gradient(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        }
    }
}

struct TasksBarGraph: View {
    var tasks: [TaskInfo]
    var indicator: TimeIndicator

    var body: some View {
        VStack {
            switch indicator {
            case .week:
                ForEach(0..<7, id: \.self) { day in
                    TaskBar(task: tasks[day])
                }
            case .month:
                ForEach(tasks, id: \.date) { task in
                    TaskBar(task: task)
                }
            case .year:
                ForEach(0..<12, id: \.self) { month in
                    TaskBar(task: tasks[month])
                }
            }
        }
    }
}

struct TaskBar: View {
    var task: TaskInfo
    
    var completionPercentage: Double {
        return Double(task.completedTasks) / Double(task.totalTasks)
    }
    
    var body: some View {
        HStack {
            Text(task.title)
                .bold()
                .frame(width: 50)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 20)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .frame(width: CGFloat(completionPercentage) * UIScreen.main.bounds.width * 0.6, height: 20)
            }
            .padding(.horizontal)
            Text("\(Int(completionPercentage * 100))%")
                .foregroundColor(Color.blue)
        }
    }
}

struct DateNavigator: View {
    @Binding var selectedDate: Date
    var dateRange: String
    
    var body: some View {
        HStack {
            Button(action: { /* adjust date backwards */ }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
            }
            .padding(.horizontal)
            
            Text(dateRange)
                .font(.headline)
                .bold()
                .foregroundColor(Color.primary.opacity(0.7))
            
            Button(action: { /* adjust date forwards */ }) {
                Image(systemName: "arrow.right")
                    .font(.title2)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
}

struct TaskCompletionIndicator_Previews: PreviewProvider {
    static var previews: some View {
        TaskCompletionIndicatorView()
    }
}
