// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import SDWebImageSwiftUI
import Combine

public struct ZKBannerView: View {
    
    let imageArr: Array<String>
    let width: CGFloat
    let height: CGFloat
    @State var offset: CGFloat = .zero
    @State public var currentIndex: Int
    public var currentBinding: Binding<Int> {
          Binding(
              get: { self.currentIndex },
              set: { self.currentIndex = $0 }
          )
      }
    @Binding public var autoPlay: Bool
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    public init(imageArr: Array<String> , height: CGFloat = 200, width: CGFloat = UIScreen.main.bounds.width - 40, autoPlay: Binding<Bool> , loop: Double = 5) {
        self.imageArr = imageArr
        self.currentIndex = 0
        self.height = height
        self.width = width
        _autoPlay = autoPlay
        self.timer = Timer.publish(every: loop, on: .main, in: .common).autoconnect()
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
                    autoPlay = false
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
            if autoPlay {
                var newIndex = 0
                if currentIndex == imageArr.count - 1 {
                    newIndex = 0
                } else {
                    newIndex = currentIndex + 1
                }
                changeBanner(newIndex: newIndex)
            }
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

#if DEBUG

fileprivate struct TestView: View {
    @State private var autoPlay: Bool = true
    let images = [
        "https://images.unsplash.com/photo-1739036462754-6e86520998a2?q=80&w=1475&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://plus.unsplash.com/premium_photo-1738935667408-42e1eec024ec?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1739104627818-d9159a7daa8d?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1738599937833-1413fe3fa64f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ]
    var body: some View {
        VStack{
            ZKBannerView(imageArr: images, autoPlay: $autoPlay)
                .padding()
            
            Button("autoPlay") {
                self.autoPlay.toggle()
            }
        }
    }
}

#Preview {
    TestView()
}

#endif

