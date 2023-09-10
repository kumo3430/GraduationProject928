//
//  HomeView.swift
//  GraduationProject
//
//  Created by heonrim on 8/3/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @State private var showQuoteView: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) { // Reduced spacing
                QuoteCardView()
                    .cardStyle()

                TaskCompletionIndicatorCardView()
                    .cardStyle()

                TodayTodoView()
                    .cardStyle()

                AchievementCardView(achievement: Achievement(title: "首次之旅", description: "第一次添加習慣", achieved: true, imageName: "plus.circle.fill"))
                    .cardStyle()

                CommunityCardView()
                    .cardStyle()
            }
            .padding()
        }
        .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

extension View {
    func cardStyle() -> some View {
        self.padding(.all, 10)
            .background(RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.7)).shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(TaskStore())
                .environmentObject(TodoStore())
        }
    }
}
