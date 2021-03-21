# swiftui-by-example-study

[Hacking with iOS: SwiftUI Edition](https://www.hackingwithswift.com/books/ios-swiftui) 을 보며 내용 정리


## References
https://www.hackingwithswift.com/books/ios-swiftui  
https://github.com/twostraws/HackingWithSwift

# Animations
Spruce up your UI with springs, bounces, and more


## Overview


### intro
이번 기술 프로젝트에서는 빠르고, 아름답고, 정말로 저평가된 애니메이션을 볼 것이다. 애니메이션의 존재 이유 몇가지 중 하나는 사용자에게 우리의 프로그램에서 무슨 일이 일어나고 있는지 이해를 돕기위해 UI를 더 보기 좋게 하기 위함이다.

이번 기술 프로젝트에서 SwiftUI의 애니메니션과 트랜지션들을 살펴본다.


### 암시적 애니메이션 생성
암시적 애니메이션은 SwiftUI에서 가장 간단한 애니메이션 타입이다. 매우 간단하다.
```swift
Button("Tap Me") {
    // do nothing
}
.padding(50)
.background(Color.red)
.foregroundColor(.white)
.clipShape(Circle())
```
이 버튼이 탭 될 때마다 더 커지도록 하려면 scaleEffect() modifier를 사용할 수 있다. 0보다 큰 값으로 사이즈를 제공할 수 있고, 1.0은 버튼의 100% 사이즈를 나타낸다. 

버튼이 탭 될 때마다 사이즈의 변화를 주고 싶으므로 @State property가 필요하다.
```swift
@State private var animationAmount: CGFloat = 1
```

 이제 프로퍼티를 사용하여 버튼에 scaleEffect() modifier를 추가한다.
 ```swift
 .scaleEffect(animationAmount)
 ```

 마지막으로 버튼이 탭 될 때마다 animationAmount를 증가시킨다.
 ```swift
 self.animationAmount += 1
 ```

 코드를 실행하여 버튼을 탭 하면 버튼은 즉시 스케일업된다. 이제 스케일링이 부드럽게 일어나도록 변화를 위해 SwiftUI에 암시적 애니메이션을 요청할 수 있다. animation() modifier를 버튼에 추가한다.
 ```swift
 .animation(.default)
 ```

 이 암시적 애니메이션은 변경되는 뷰의 모든 프로퍼티들에게 영향을 미치는데, 더 많은 modifier를 추가하면 모두 함께 변경된다. 예를들어 .blur() modifier를 추가할 수 있다.
 ```swift
 .blur(radius: (animationAmount - 1) * 3)
 ```

 이제 실행하면 스케일과 블러가 부드럽게 적용됨을 볼 수 있다.

 포인트는 우리가 어디에도 애니메이션이 어떻게 보여야하는지, 애니메이션의 시작과 끝이 언제인지 SwiftUI에게 언급하지 않았다. 대신에 우리의 애니메이션은 view와 같이 상태의 함수가 된다.


 ### SwiftUI 애니메이션 커스터마이징
 .animation(.default) modifier를 사용하였을 때 SwiftUI는 view의 변화를 자동으로 기본 시스템 애니메이션을 사용하여 그렸다.

 우린 modifier에 다른 값으로 애니메이션 타입을 전달할 수 있다.
 ```swift
 .animation(.easeOut)
 ```

spring 애니메이션도 있다.
```swift
.animation(.interpolatingSpring(stiffness: 50, damping: 1))
```

특정 초 단위를 제공하여 애니메이션의 지속시간을 커스텀할 수도 있다.
```swift
struct ContentView: View {
  @State private var animationAmount: CGFloat = 1
  
  var body: some View {
    Button("Tap Me") {
      self.animationAmount += 1
    }
    .padding(50)
    .background(Color.red)
    .foregroundColor(.white)
    .clipShape(Circle())
    .scaleEffect(animationAmount)
    .animation(.easeInOut(duration:2))
  }
}
```

.easeInOut(duration: 2)를 적용하면 실제로는 자체 modifier를 가지고 있는 Animation struct 인스턴스를 생성한다. 그래서 우린 직접적으로 애니메이션에 딜레이를 주는 modifier를 추가할 수 있다.
```swift
.animation(
  Animation.easeInOut(duration: 2)
    .delay(1)
)
```

또한 애니메이션이 주어진 수만큼 반복되고, 앞뒤로 바운스할 수 있도록 설정할 수 있다.
```swift
.animation(
  Animation.easeInOut(duration: 1)
    .repeatCount(3, autoreverses: true)
)
```

지속적인 애니메이션을 위해서 repeatForever() modifier를 사요할 수도 있다.
```swift
.animation(
  Animation.easeInOut(duration: 1)
    .repeatForever(autoreverses: true)
)
```

애니메이션을 view의 생명주기동안 즉시 시작하여 지속 되도록 만들기위해 repeatForever()를 onAppear와 조합해서 사용할 수 있다. 이를 위해 버튼의 애니메이션을 삭제하고 overlay() modifer를 추가한다.
```swift
.overlay(
  Circle()
    .stroke(Color.red)
    .scaleEffect(animationAmount)
    .opacity(Double(2 - animationAmount))
    .animation(
      Animation.easeOut(duration: 1)
        .repeatForever(autoreverses: false)
    )
)
```

이는 버튼 위에 빨간 원을 그리고, opacity를 1~0으로 조절한다. 버턴의 scaleEffect() modifier와 탭했을 때의 코드 animationAmount += 1을 삭제한다. 그리고 onAppear() modifier를 버튼에 추가하고 animationAmount 를 2로 설정한다. repeatForever의 autoreverses가 false 이므로 원이 커지면서 사라지는 모습이 지속적으로 반복된다.

```swift
Button("Tap Me") {
  // self.animationAmount += 1
}
.padding(40)
.background(Color.red)
.foregroundColor(.white)
.clipShape(Circle())
.overlay(
  Circle()
    .stroke(Color.red)
    .scaleEffect(animationAmount)
    .opacity(Double(2 - animationAmount))
    .animation(
      Animation.easeOut(duration: 1)
        .repeatForever(autoreverses: false)
      )
)
.onAppear {
  self.animationAmount = 2
}
```


### 애니메이션 바인딩
animation() modifier는 모든 SwiftUI 바인딩에 적용될 수 있으며, 이는 현재의 값과 새로운 값의 사이에서 애니메이션이 되도록 한다. 