// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import SDWebImageSwiftUI

public struct ZKBannerView: View {
    
    let imageArr: Array<String>
    let width: CGFloat = UIScreen.main.bounds.width - 40
    let height: CGFloat = 200
    @State var offset: CGFloat
    @State var currentIndex: Int
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    public init(imageArr: Array<String>, offset: CGFloat = .zero, currentIndex: Int = 0) {
        self.imageArr = imageArr
        self.offset = offset
        self.currentIndex = currentIndex
    }
    
    public var body: some View {
        HStack{
            ForEach(getImges(), id: \.self) { img in
                WebImage(url: URL(string: img))
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: img == imageArr[currentIndex] ? height : height * 0.8)
                    .clipped()
            }
        }
        .offset(x: offset)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    offset = value.translation.width
                })
                .onEnded({ value in
                    var newIndex = 0
                    // 向右拖动，显示上一张
                    if value.translation.width > 50 {
                        if currentIndex == 0 {
                            newIndex = imageArr.count - 1
                        } else {
                            newIndex = currentIndex - 1
                        }
                    }
                    // 向左拖动，显示下一张
                    if value.translation.width < 50 {
                        if currentIndex == imageArr.count - 1 {
                            newIndex = 0
                        } else {
                            newIndex = currentIndex + 1
                        }
                    }
                    
                    changeBanner(newIndex: newIndex)
                })
        )
        .onReceive(timer) { _ in
            var newIndex = 0
            if currentIndex == imageArr.count - 1 {
                newIndex = 0
            } else {
                newIndex = currentIndex + 1
            }
            changeBanner(newIndex: newIndex)
        }
    }
    
    // 前台展示的3张图片
    func getImges() -> [String] {
        let currentImage = imageArr[currentIndex]
        let preImage = currentIndex == 0 ? imageArr.last! : imageArr[currentIndex - 1]
        let nextImage = currentIndex == imageArr.count - 1 ? imageArr.first! : imageArr[currentIndex + 1]
        return [preImage, currentImage, nextImage]
    }
    // 轮播动画
    func changeBanner(newIndex: Int) {
        withAnimation(.linear(duration: 0.5)) {
            currentIndex = newIndex
            offset = .zero
        }
    }
}

#Preview {
    let images = [
         "https://images.unsplash.com/photo-1720048171596-6a7c81662434?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
         "https://img0.baidu.com/it/u=597753977,1250737874&fm=253&fmt=auto&app=120&f=JPEG?w=801&h=500",
         "https://img1.baidu.com/it/u=1795072984,4227544674&fm=253&fmt=auto&app=120&f=JPEG?w=654&h=363",
         "https://i2.hdslb.com/bfs/archive/b4c0c3907e1f64c2de50edb35a7524d3af48e0f8.jpg"
     ]
    ZKBannerView(imageArr: images)
}
