import SwiftUI

struct Task {
    var id: Int
    var name: String
    var type: String // sport, space, study...
}

struct TodayTasksView: View {
    var tasks: [Task] = [
        Task(id: 1, name: "跑步", type: "sport"),
        Task(id: 2, name: "學習", type: "study"),
        Task(id: 3, name: "第一次複習", type: "space")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(tasks, id: \.id) { task in
                        if task.type == "sport" {
                            // Display CheckSportView
                            CheckSportView()
                                .padding()
                        } else if task.type == "study" {
                            // Display CheckStudyView
                            CheckStudyView()
                                .padding()
                        } else if task.type == "space" {
                            // Display CheckSpaceView
                            CheckSpaceView()
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("今日任務")
        }
    }
}

struct TodayTasksView_Previews: PreviewProvider {
    static var previews: some View {
        TodayTasksView()
    }
}
