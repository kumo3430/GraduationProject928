//
//  QuoteView.swift
//  GraduationProject
//
//  Created by heonrim on 8/17/23.
//

import SwiftUI

struct QuoteView: View {
    var quote: String = "這裡是一句感人的語錄。"
    var source: String = "感人的來源"
    
    @State private var showShareSheet = false
    @State private var imageToShare: UIImage?

    var body: some View {
        ZStack {
            // 背景
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            // 語錄內容
            VStack(spacing: 20) {
                Text(quote)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("— \(source)")
                    .font(.headline)
                    .italic()
            }
            
            // 喜歡和分享按鈕
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // 喜歡按鈕的動作
                    }) {
                        Image(systemName: "heart")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 10)
                    
                    Button(action: {
                        self.imageToShare = captureView()
                        self.showShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .sheet(isPresented: $showShareSheet, content: {
                        if let img = self.imageToShare {
                            ShareSheet(activityItems: [img])
                        }
                    })
                    .padding()
                }
            }
        }
    }
    
    func captureView() -> UIImage? {
        // Capture the current view as UIImage
        // This method needs to be implemented to capture the view
        // There are various ways to implement this depending on your needs
        nil
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {}
}
