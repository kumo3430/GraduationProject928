//
//  TaskCompletionIndicatorCardView.swift
//  GraduationProject
//
//  Created by heonrim on 8/28/23.
//

import SwiftUI

struct TaskCompletionIndicatorCardView: View {
    @State private var selectedIndicator: TimeIndicator = .week

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("任務完成指標")
                    .font(.headline)
                
                Picker("選擇時間指標", selection: $selectedIndicator) {
                    ForEach(TimeIndicator.allCases) { indicator in
                        Text(indicator.rawValue).tag(indicator)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // Your data calculation based on the selectedIndicator goes here, for simplicity I'm using a static progress for now
                ProgressView(value: 0.7)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                
                Text("70% 已完成")
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}


struct TaskCompletionIndicatorCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCompletionIndicatorCardView()
    }
}
