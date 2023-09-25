//
//  CheckSpaceView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/24.
//

import SwiftUI
import Lottie

struct CheckSpaceView: View {
    enum StudyStage: String, CaseIterable {
        case study = "學習"
        case firstReview = "第一次複習"
        case secondReview = "第二次複習"
        case thirdReview = "第三次複習"
        case fourthReview = "第四次複習"
    }
    
    @State private var currentStage: StudyStage = .study
    @State private var isCompleted: Bool = false
    @State private var showCelebration: Bool = false
    
    let animationName: String = "animation_lmvsn755"
    let titleColor = Color.gray
    let customBlue = Color(UIColor.systemBlue).opacity(0.7)
    let habitType: String = "學習空間"
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("學習空間")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundColor(titleColor)
                    .padding(.bottom, 2)
                
                Text("習慣類型：\(habitType)")
                    .font(.system(size: 15, weight: .medium, design: .default))
                    .foregroundColor(Color.secondary)
                    .padding(.bottom, 2)
                
                Text(currentStage.rawValue)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(customBlue)
                    .padding(.bottom, 2)
                
                Button(action: {
                    isCompleted = true
                    withAnimation {
                        showCelebration = true
                    }
                }) {
                    Text("標記為已完成")
                        .foregroundColor(Color.white)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(customBlue))
                }
                .disabled(isCompleted)
            }
            .padding(15)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4))
            .frame(height: 160)
            
            if showCelebration {
                celebrationView
            }
        }
    }
    
    var celebrationView: some View {
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

struct CheckSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        CheckSpaceView()
    }
}
