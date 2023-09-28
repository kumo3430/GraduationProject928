//
//  HabitTrackingIndicatorView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/20.
//

import SwiftUI

enum TaskFilter: String, CaseIterable {
    case all = "All"
    case generalLearning = "一般學習"
    case intervalLearning = "間隔學習"
    case exercise = "運動"
    case diet = "飲食"
    case routine = "作息"
}

enum IndicatorType: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct HabitTask: Identifiable {
    let id = UUID()
    let name: String
}

struct HabitTrackingIndicatorView: View {
    @State private var selectedFilter = TaskFilter.all
    @State private var tasks: [HabitTask] = [
        HabitTask(name: "Example Task 1"),
        HabitTask(name: "Example Task 2"),
        HabitTask(name: "Example Task 3")
    ]
    @State private var selectedTask: HabitTask?

    var body: some View {
        VStack {
            // App Title
            Text("Tasks Tracking App")
                .font(.largeTitle)
                .padding()

            // Filter section
            Picker("Filter", selection: $selectedFilter) {
                ForEach(TaskFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Tasks List
            List(tasks) { task in
                Button(action: {
                    selectedTask = task
                }) {
                    Text(task.name)
                }
                .sheet(item: $selectedTask) { task in
                    TaskDetailView(taskName: task.name)
                }
            }

            Spacer()

        }
        .padding()
    }
}

struct TaskDetailView: View {
    var taskName: String
    @State private var selectedIndicator = IndicatorType.week

    var body: some View {
        VStack {
            Text(taskName)
                .font(.largeTitle)
                .padding()

            // Indicator Selector
            Picker("Indicator", selection: $selectedIndicator) {
                ForEach(IndicatorType.allCases, id: \.self) { indicator in
                    Text(indicator.rawValue).tag(indicator)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Display the selected indicator
            switch selectedIndicator {
            case .week:
                WeekIndicatorView()
            case .month:
                MonthIndicatorView()
            case .year:
                YearIndicatorView()
            }

            Spacer()
        }
    }
}

struct WeekIndicatorView: View {
    // You can add the visualization for weekly data here
    var body: some View {
        Text("Weekly Data Visualization")
    }
}

struct MonthIndicatorView: View {
    // You can add the visualization for monthly data here
    var body: some View {
        Text("Monthly Data Visualization")
    }
}

struct YearIndicatorView: View {
    // You can add the visualization for yearly data here
    var body: some View {
        Text("Yearly Data Visualization")
    }
}


struct HabitTrackingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackingIndicatorView()
    }
}
