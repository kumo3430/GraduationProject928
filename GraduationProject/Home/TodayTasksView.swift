//
//  TodayTasksView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/21.
//

import SwiftUI

enum TaskType: String {
    case sport, space, study
}

struct DailyTask {
    var id: Int
    var name: String
    var type: TaskType
}

struct TodayTasksView: View {
    var tasks: [DailyTask] = [
        
        DailyTask(id: 2, name: "學習", type: .study),
        DailyTask(id: 1, name: "跑步", type: .sport),
        DailyTask(id: 3, name: "第一次複習", type: .space)
    ]
    
    @State private var selectedTaskId: Int? // 添加这一行来存储选中的任务ID
    
    var cardSpacing: CGFloat = 50
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: cardSpacing) {
                    ForEach(tasks, id: \.id) { task in
                        ScrollView(.horizontal) {
                            HStack{
                                //                        ZStack {
                                getTaskView(for: task.type)
                                    .background(getBackgroundColor(for: task.type, selected: task.id == selectedTaskId)) // 修改这一行来传递selected参数
                                //                        }
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1))
                                    .padding(20)
                                    .accessibilityLabel("\(task.name)")
                                    .accessibilityHint("This is a \(task.type.rawValue) task")
                                    .onTapGesture {
                                        withAnimation {
                                            self.selectedTaskId = self.selectedTaskId == task.id ? nil : task.id
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("今日任務")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.default)
        }
    }
    
    func getTaskView(for type: TaskType) -> some View {
        switch type {
        case .sport:
            return AnyView(CheckSportView(RecurringStartDate: Date(), RecurringEndDate: Date(), completeValue: 0.0))
        case .study:
            return AnyView(CheckStudyView())
        case .space:
            return AnyView(CheckSpaceView())
        }
    }
    
//    func getTaskView(for type: TaskType) -> some View {
//        switch type {
//        case .sport:
//            return AnyView(CheckSportView().frame(width: 300, height: 200).clipShape(RoundedRectangle(cornerRadius: 10)))
//        case .study:
//            return AnyView(CheckStudyView().frame(width: 300, height: 200).clipShape(RoundedRectangle(cornerRadius: 10)))
//        case .space:
//            return AnyView(CheckSpaceView().frame(width: 300, height: 200).clipShape(RoundedRectangle(cornerRadius: 10)))
//        }
//    }

    
    func getBackgroundColor(for type: TaskType, selected: Bool) -> Color {
        let baseColor: Color
        switch type {
        case .sport:
            baseColor = Color.blue
        case .study:
            baseColor = Color.green
        case .space:
            baseColor = Color.orange
        }
        return selected ? baseColor : baseColor.opacity(0.1)
    }
}

struct TodayTasksView_Previews: PreviewProvider {
    static var previews: some View {
        TodayTasksView()
    }
}
