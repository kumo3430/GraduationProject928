//
// CheckSportView.swift
// GraduationProject
//
// Created by heonrim on 2023/9/23.
//

import SwiftUI
import Lottie

struct CheckSportView: View {
    @EnvironmentObject var sportStore: SportStore
    @State var sportValue: Float = 0.0
    @State var accumulatedValue: Float = 0.0
        @State var targetValue: Float = 5.0
        @State var taskName: String = "運動"
        @State var sportType: String = "跑步"
    let sports = ["跑步", "單車騎行", "散步", "游泳", "爬樓梯", "健身", "瑜伽", "舞蹈"]
        @State var sportUnit: String = "次"
    
    @State private var isCompleted: Bool = false
    @State private var showCelebration: Bool = false
    let animationName: String = "animation_lmvsn755"
    let titleColor = Color.gray
    let customBlue = Color(UIColor.systemBlue).opacity(0.7)
    let habitType: String = "運動"
    @State var id :Int = 0
    @State var RecurringStartDate : Date
    @State var RecurringEndDate : Date
    @State var completeValue : Float
    var body: some View {
        ForEach(sportStore.sportsForDate(Date()).indices, id: \.self) { index in
//        ForEach(0..<5) { todo in
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.white, Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(sportStore.sportsForDate(Date())[index].title)
//                    Text(taskName)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(titleColor)
                        .padding(.bottom, 2)
                    
                    Text("習慣類型：運動")
                        .font(.system(size: 15, weight: .medium, design: .default))
                        .foregroundColor(Color.secondary)
                        .padding(.bottom, 2)
                    
                    Text("運動類型: \(sportStore.sportsForDate(Date())[index].selectedSport)")
//                    Text("習慣類型：\(habitType)")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(customBlue)
                        .padding(.bottom, 2)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("目標")
                                .font(.system(size: 14, weight: .medium, design: .serif))
                                .foregroundColor(Color.secondary)
                            
                            Text("\(sportStore.sportsForDate(Date())[index].sportValue, specifier: "%.1f") \(sportStore.sportsForDate(Date())[index].sportUnits)")
//                            Text("\(targetValue, specifier: "%.1f") \(sportUnit)")
                                .font(.system(size: 18, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("已完成")
                                .font(.system(size: 14, weight: .medium, design: .serif))
                                .foregroundColor(Color.secondary)
                            
                            Text("\(sportStore.sportsForDate(Date())[index].completeValue, specifier: "%.1f") \(sportStore.sportsForDate(Date())[index].sportUnits)")
//                            Text("\(accumulatedValue, specifier: "%.1f") \(sportUnit)")
                                .font(.system(size: 18, weight: .semibold, design: .default))
                                .foregroundColor(customBlue)
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    HStack {
                        TextField("數值", value: $sportValue, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 70, height: 35)
                            .padding(6)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white).shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3))
                            .cornerRadius(8)
                            .font(.system(size: 18, weight: .regular, design: .monospaced))
                            .disabled(isCompleted)
                        
                        Text(sportStore.sportsForDate(Date())[index].sportUnits)
//                        Text(sportUnit)
                            .font(.system(size: 18, weight: .regular, design: .monospaced))
                            .foregroundColor(customBlue)
                            .frame(width: 100, alignment: .trailing)
                        
                        Button(action: {

                            accumulatedValue = sportStore.sportsForDate(Date())[index].completeValue
                            print("C1=\(sportStore.sportsForDate(Date())[index].completeValue)")
                            accumulatedValue += sportValue
                            print("C2=\(accumulatedValue)")
                            sportStore.updateSport(withID: sportStore.sportsForDate(Date())[index].id, newValue: accumulatedValue)
                            print("C3=\(sportStore.sportsForDate(Date())[index].completeValue)")
                            if sportStore.sportsForDate(Date())[index].completeValue >= sportStore.sportsForDate(Date())[index].sportValue {
                                isCompleted = true
                                withAnimation {
                                    showCelebration = true
                                }
                            }
                            id = sportStore.sportsForDate(Date())[index].id
                            RecurringStartDate =  sportStore.sportsForDate(Date())[index].RecurringStartDate
                            RecurringEndDate =  sportStore.sportsForDate(Date())[index].RecurringEndDate
                            completeValue =  sportStore.sportsForDate(Date())[index].completeValue
                            upDateCompleteValue{_ in }
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
    
    func upDateCompleteValue(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": id,
            "RecurringStartDate": formattedDate(RecurringStartDate),
            "RecurringEndDate": formattedDate(RecurringEndDate),
            "completeValue": completeValue,
        ]
        phpUrl(php: "upDateCompleteValue" ,type: "reviseTask",body:body, store: nil){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
//            completion(message[0])
            completion(message["message"]!)
        }
    }
}

struct CheckSportView_Previews: PreviewProvider {
    static var previews: some View {
        //        @State var sport = Sport(id: 001,
        //                                 label:"我是標籤",
        //                                 title: "英文",
        //                                 description: "背L2單字",
        //                                 startDateTime: Date(),
        //                                 selectedSport: "溜冰",
        //                                 sportValue: 1.1,
        //                                 sportUnits: "次",
        //                                 recurringUnit: "每週",
        //                                 recurringOption:2,
        //                                 todoStatus: false,
        //                                 dueDateTime: Date(),
        //                                 reminderTime: Date(),
        //                                 todoNote: "我是備註")
        CheckSportView(RecurringStartDate: Date(), RecurringEndDate: Date(), completeValue: 0.0)
            .environmentObject(SportStore())
    }
}
