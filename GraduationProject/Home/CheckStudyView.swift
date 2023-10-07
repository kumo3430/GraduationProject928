//
// CheckStudyView.swift
// GraduationProject
//
//  Created by heonrim on 9/22/23.
//

import SwiftUI
import Lottie

struct CheckStudyView: View {
    @EnvironmentObject var todoStore: TodoStore
    @State var studyValue: Float = 0.0
    @State var accumulatedValue: Float = 0.0
    @State var targetValue: Float = 5.0
    @State var taskName: String = "學習SwiftUI"
    let studyUnits = ["次", "小時"]
    let studyUnit: String = "次"
    let habitType: String = "一般學習" // 新添加的習慣類型
    
    @State private var isCompleted: Bool = false
    @State private var showCelebration: Bool = false
    let animationName: String = "animation_lmvsn755"
    let titleColor = Color.gray
    let customBlue = Color(UIColor.systemBlue).opacity(0.7)
    var cardSpacing: CGFloat = 50
    var body: some View {
        ForEach(0..<5) { todo in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.white, Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(taskName)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(titleColor)
                        .padding(.bottom, 2)
                    
                    Text("習慣類型：\(habitType)")
                        .font(.system(size: 15, weight: .medium, design: .default))
                        .foregroundColor(Color.secondary)
                        .padding(.bottom, 2)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("目標")
                                .font(.system(size: 14, weight: .medium, design: .serif))
                                .foregroundColor(Color.secondary)
                            
                            Text("\(targetValue, specifier: "%.1f") \(studyUnit)")
                                .font(.system(size: 18, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("已完成")
                                .font(.system(size: 14, weight: .medium, design: .serif))
                                .foregroundColor(Color.secondary)
                            
                            Text("\(accumulatedValue, specifier: "%.1f") \(studyUnit)")
                                .font(.system(size: 18, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    HStack {
                        TextField("數值", value: $studyValue, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 70, height: 35)
                            .padding(6)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white).shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3))
                            .cornerRadius(8)
                            .font(.system(size: 18, weight: .regular, design: .monospaced))
                            .disabled(isCompleted)
                        
                        Text(studyUnit)
                            .font(.system(size: 18, weight: .regular, design: .monospaced))
                            .foregroundColor(customBlue)
                            .frame(width: 100, alignment: .trailing)
                        
                        Button(action: {
                            accumulatedValue += studyValue
                            if accumulatedValue >= targetValue {
                                isCompleted = true
                                withAnimation {
                                    showCelebration = true
                                }
                            }
                        }) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.white)
                                .padding(8)
                                .background(Capsule().fill(customBlue).shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2))
                        }
                        .disabled(isCompleted)
                    }
                    .padding(.horizontal, 10)
                }
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4))
                .frame(height: 160)
                
                if showCelebration {
                    VStack {
                        Text("恭喜！任務完成！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        LottieView(animation: .named(animationName))
                            .play(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                            .animationDidFinish { _ in
                                withAnimation {
                                    showCelebration = false
                                }
                            }
                            .frame(width: 200, height: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
            }
        }
    }
}

struct CheckStudyView_Previews: PreviewProvider {
    static var previews: some View {
//        @State var todo = Todo(id: 001,
//                               label:"我是標籤",
//                               title: "英文",
//                               description: "背L2單字",
//                               startDateTime: Date(),
//                               studyValue: 3.0,
//                               studyUnit: "小時",
//                               recurringUnit:"每週",
//                               recurringOption:2,
//                               todoStatus: false,
//                               dueDateTime: Date(),
//                               reminderTime: Date(),
//                               todoNote: "我是備註")
        CheckStudyView()
    }
}

//這個檔案作為動畫參考
