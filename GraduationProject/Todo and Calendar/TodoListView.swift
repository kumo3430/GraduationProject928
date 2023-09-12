//
//  SpacedView.swift
//  SpacedRepetition
//
//  Created by heonrim on 5/1/23.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @AppStorage("uid") private var uid: String = ""
    @State private var showingActionSheet = false
    @State private var action: Action? = nil
    @State var hasLoadedData = false
    @State var ReviewChecked0: Bool
    @State var ReviewChecked1: Bool
    @State var ReviewChecked2: Bool
    @State var ReviewChecked3: Bool
    
    var switchViewAction: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                if taskStore.tasks.isEmpty {
                    // Display the message when there are no tasks
                    Text("尚未新增事項")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)  // Center the message
                } else {
                    List {
                        Text("間隔學習法")
                        ForEach(taskStore.tasks.indices, id: \.self) { index in
                            
                            NavigationLink(destination: SpaceDetailView(task: $taskStore.tasks[index])) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(taskStore.tasks[index].title)
                                        .font(.headline)
                                    Text(taskStore.tasks[index].description)
                                        .font(.subheadline)
                                    Text("Start time: \(formattedDate(taskStore.tasks[index].nextReviewDate))")
                                        .font(.caption)
                                }
                            }
                        }
                        Text("一般學習法")
                        ForEach(todoStore.todos.indices, id: \.self) { index in
                            NavigationLink(destination: StudyDetailView(todo: $todoStore.todos[index])) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(todoStore.todos[index].title)
                                        .font(.headline)
                                    Text(todoStore.todos[index].description)
                                        .font(.subheadline)
                                    Text("Start time: \(formattedDate(todoStore.todos[index].startDateTime))")
                                        .font(.caption)
                                }
                            }
                        }
                        Text("運動")
                        ForEach(sportStore.sports.indices, id: \.self) { index in
                            NavigationLink(destination: DetailSportView(sport: $sportStore.sports[index])) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(sportStore.sports[index].title)
                                        .font(.headline)
                                    Text(sportStore.sports[index].description)
                                        .font(.subheadline)
                                    Text("Start time: \(formattedDate(sportStore.sports[index].startDateTime))")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("待辦事項", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        switchViewAction()  // 切換視圖
                    }) {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    },
                trailing:
                    Button(action: {
                        self.showingActionSheet = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
            )
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("新增事項"), message: Text("選擇一個事件類型"), buttons: [
                    .default(Text("一般學習"), action: {
                        self.action = .generalLearning
                    }),
                    .default(Text("間隔學習"), action: {
                        self.action = .spacedLearning
                    }),
                    .default(Text("運動"), action: {
                        self.action = .sport
                    }),
                    .default(Text("作息"), action: {
                        self.action = .routine
                    }),
                    .default(Text("飲食"), action: {
                        self.action = .diet
                    }),
                    .cancel()
                ])
            }
            .fullScreenCover(item: $action) { item in
                switch item {
                case .generalLearning:
                    AddStudyView()
                case .spacedLearning:
                    AddSpaceView()
                case .sport:
                    AddSportView()
                case .diet:
                    AddDietView()
                default:
                    AddDietView()
                }
            }
        }
    }
    func listItem(title: String, description: String, date: Date, icon: String) -> some View {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color("Primary"))
                    .background(Color("IconBackground"))
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Start time: \(formattedDate(date))")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    // 用於將日期格式化為指定的字符串格式
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    
}

struct SpacedView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(ReviewChecked0: false, ReviewChecked1: false, ReviewChecked2: false, ReviewChecked3: false, switchViewAction: {})
        //        TodoListView(switchViewAction: {})
            .environmentObject(TaskStore())
            .environmentObject(TodoStore())
            .environmentObject(SportStore())
    }
}
