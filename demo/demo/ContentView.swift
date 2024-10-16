//
//  ContentView.swift
//  demo
//
//  Created by 雷子康 on 2024/10/9.
//

import SwiftUI
import ZKBannerSwiftUI

struct ContentView: View {
    let images = [
         "https://images.unsplash.com/photo-1720048171596-6a7c81662434?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
         "https://img0.baidu.com/it/u=597753977,1250737874&fm=253&fmt=auto&app=120&f=JPEG?w=801&h=500",
         "https://img1.baidu.com/it/u=1795072984,4227544674&fm=253&fmt=auto&app=120&f=JPEG?w=654&h=363",
         "https://i2.hdslb.com/bfs/archive/b4c0c3907e1f64c2de50edb35a7524d3af48e0f8.jpg"
     ]
    @State var autoPlay: Bool = true
    var body: some View {
        VStack {
            ZKBannerView(imageArr: images, autoPlay: $autoPlay)
                .frame(maxWidth: .infinity, alignment: .top)
                .padding()
            
            Toggle("自动轮播", isOn: $autoPlay)
            
            Text("轮播Banner")
                .padding(.top, 20)
            
            Spacer()
            
          
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
