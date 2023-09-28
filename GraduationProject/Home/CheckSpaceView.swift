//
//  CheckSpaceView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/24.
//

import SwiftUI
import Lottie

struct CheckSpaceView: View {
    @State var accumulatedValue: Float = 0.0
    @State var targetValue: Float = 1.0
    @State var taskName: String = "學習"
    @State var studyPhase: String = "學習"
    let studyPhases = ["學習", "第一次複習", "第二次複習", "第三次複習", "第四次複習"]
    @State var studyUnit: String = "次"

    @State private var isCompleted: Bool = false
    @State private var showCelebration: Bool = false
    let animationName: String = "animation_lmvsn755"
    let titleColor = Color.gray
    let customBlue = Color(UIColor.systemBlue).opacity(0.7)
    let completedOverlayColor = Color.gray.opacity(0.3)
    let habitType: String = "間隔學習"

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(taskName)
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundColor(titleColor)
                    .padding(.bottom, 2)

                Text("習慣類型：\(habitType)")
                    .font(.system(size: 15, weight: .medium, design: .default))
                    .foregroundColor(Color.secondary)
                    .padding(.bottom, 2)

                Text("學習階段: \(studyPhase)")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(customBlue)
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

                Button(action: {
                    accumulatedValue += 1
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
                .padding(.horizontal, 10)
            }
            .padding(15)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).overlay(isCompleted ? RoundedRectangle(cornerRadius: 15).fill(completedOverlayColor) : nil).shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4))
            .frame(height: 160)

            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 40))
            }

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

struct CheckSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        CheckSpaceView()
    }
}
