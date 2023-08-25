//
//  TodoManager.swift
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

enum TimeFrame: String, CaseIterable, Identifiable {
    case day = "日"
    case week = "週"
    case month = "月"
    
    var id: String { self.rawValue }
}

struct TaskCompletionView: View {
    @State private var isViewByDate = true
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


    var body: some View {
        NavigationView {
            VStack {
                            DatePicker("選擇日期", selection: $selectedDate, displayedComponents: .date) // 2. Add this DatePicker
                                .padding()
                // Header Stats
                HStack {
                    StatView(value: "\(tasksByDate.reduce(0, { $0 + $1.completedTasks }))", label: "已完成")
                    Spacer()
                    StatView(value: "\(tasksByDate.reduce(0, { $0 + $1.totalTasks }) - tasksByDate.reduce(0, { $0 + $1.completedTasks }))", label: "未完成")
                    Spacer()
                    StatView(value: "\(tasksByDate.reduce(0, { $0 + $1.totalTasks }))", label: "總任務")
                }
                .padding()

                // Picker
                Picker("檢視方式", selection: $isViewByDate) {
                    Text("按時間").tag(true)
                    Text("按事項").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // ScrollView
                if isViewByDate && tasksByDate.isEmpty || !isViewByDate && tasksByEvent.isEmpty {
                                    Text("過去一年內沒有任務數據")
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            if isViewByDate {
                                ForEach(tasksByDate, id: \.title) { task in
                                    CompletionCard(taskInfo: task)
                                }
                            } else {
                                ForEach(tasksByEvent, id: \.title) { task in
                                    CompletionCard(taskInfo: task)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("待辦事項完成指標")
        }
    }
}

struct StatView: View {
    var value: String
    var label: String

    var body: some View {
        VStack {
            Text(value)
                .font(.largeTitle)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct CompletionCard: View {
    var taskInfo: TaskInfo
    @State private var showDetails = false

    // Color palette
    let bgColor: Color = Color("CardBackground", bundle: nil) // Custom color defined in Assets.xcassets
    let primaryColor: Color = .blue
    let secondaryColor: Color = .green
    let completedColor: Color = .orange

    var isCompleted: Bool {
        taskInfo.completedTasks == taskInfo.totalTasks
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(taskInfo.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(isCompleted ? completedColor : primaryColor)
                Spacer()
                Button(action: {
                    if !taskInfo.dailyTasks.isEmpty {
                        showDetails.toggle()
                    }
                }) {
                    Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                        .foregroundColor(isCompleted ? completedColor : primaryColor)
                }
            }
            
            // Progress bar with icon
            HStack {
                Image(systemName: isCompleted ? "star.fill" : "checkmark.circle.fill")
                    .foregroundColor(isCompleted ? completedColor : secondaryColor)
                ProgressView(value: Float(taskInfo.completedTasks), total: Float(taskInfo.totalTasks))
                    .progressViewStyle(LinearProgressViewStyle(tint: isCompleted ? completedColor : secondaryColor))
            }
            
            Text("\(taskInfo.completedTasks)/\(taskInfo.totalTasks)")
                .font(.subheadline)
                .foregroundColor(.gray)

            if showDetails {
                ForEach(0..<taskInfo.dailyTasks.count, id: \.self) { index in
                    let (completed, total) = taskInfo.dailyTasks[index]
                    ProgressView(value: Float(completed), total: Float(total))
                        .progressViewStyle(LinearProgressViewStyle(tint: primaryColor))
                        .padding(.top, 4)

                    Text("Day \(index + 1): \(completed)/\(total)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 2)
                }
            }
        }
        .padding()
        .background(isCompleted ? completedColor.opacity(0.2) : bgColor)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

struct TaskCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCompletionView()
    }
}
