// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import SDWebImageSwiftUI
import Combine

public protocol ZKIdentifiableView: View, Identifiable, AccessibilityRotorContent {
    var id: UUID { get }
}

struct Test: ZKIdentifiableView {
    
    var id = UUID()
    
    var body: some View {
        HStack {
            
        }
    }
}
public struct ZKBannerView: View {
    
    let viewsArr: Array<any ZKIdentifiableView>
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
    
    public init(viewsArr: Array<any ZKIdentifiableView> , height: CGFloat = 200, width: CGFloat = UIScreen.main.bounds.width - 40, autoPlay: Binding<Bool> , loop: Double = 5) {
        self.viewsArr = viewsArr
        self.currentIndex = 0
        self.height = height
        self.width = width
        _autoPlay = autoPlay
        self.timer = Timer.publish(every: loop, on: .main, in: .common).autoconnect()
    }
    
    public var body: some View {
        HStack{
            ForEach(presentViews(), id: \.id) { view in
                view
//                    .frame(width: width, height: height)
//                    .clipped()
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
                            newIndex = viewsArr.count - 1
                        } else {
                            newIndex = currentIndex - 1
                        }
                    }
                    // 向左拖动，显示下一张
                    if value.translation.width < 50 {
                        if currentIndex == viewsArr.count - 1 {
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
                if currentIndex == viewsArr.count - 1 {
                    newIndex = 0
                } else {
                    newIndex = currentIndex + 1
                }
                changeBanner(newIndex: newIndex)
            }
        }
    }
    
    // 前台展示的3张图片
    func presentViews() -> [any ZKIdentifiableView] {
        let currentView = viewsArr[currentIndex]
        let preView = currentIndex == 0 ? viewsArr.last! : viewsArr[currentIndex - 1]
        let nextView = currentIndex == viewsArr.count - 1 ? viewsArr.first! : viewsArr[currentIndex + 1]
        return [preView, currentView, nextView]
    }
    // 轮播动画
    func changeBanner(newIndex: Int) {
        withAnimation(.linear(duration: 0.5)) {
            currentIndex = newIndex
            offset = .zero
        }
    }
}


