# swiftui-by-example-study

[Hacking with iOS: SwiftUI Edition](https://www.hackingwithswift.com/books/ios-swiftui) 을 보며 내용 정리


## References
https://www.hackingwithswift.com/books/ios-swiftui  
https://github.com/twostraws/HackingWithSwift


# ViewsAndModifiers


## Overview


### intro
이번 프로젝트는 기술 프로젝트이다. SwiftUI의 기능들을 왜 그러한 방법으로 어떻게 동작하는지 살며보며 페이스를 조절한다. 이번 프로젝트는 view와 view modifier들을 자세히 살펴볼 것이며 SwiftUI는 왜 view를 위해 struct를 사용하는지, some View는 왜 많이 사용하는지, modifier는 어ㄸ허게 동작하는지에 대한 물음에 답을 한다.


## Concepts


### SwiftUI는 view를 위해 왜 struct를 사용하는가?
UIKit 또는 AppKit으로 작업을한 적이 있다면 당신은 struct보단 class로 이루어져 있는 것을 알고있다. SwiftUI에서는 그렇지 않고 struct를 사용해야하는데 거기에는 몇가지 이유가 있다.

첫 번째는 성능이다. struct가 class보다 더 간단하고 더 빠르다. 많은 사람들의 이것이 SwiftUI가 struct를 사용하는 주요 이유라 생각하지만, 이는 큰 것 중 일부일 뿐이다.

UIKit 에서는 모든 view들이 매우 많은 property들과 method가 있는 UIView의 자식이다. UIView와 UIView의 subclass 들은 이러한 상속구조 때문에 property들과 method를 모두 가져야한다.

이것이 때로는 문제가 되지 않지만, 특정한 예로 UIStackView가 있는데, 이는 layout을 쉽게 구성하기 위해 non-rendering view 타입으로 디자인되었다. 그러나 이것은 상속 덕분에 backgroundColor를 가질 수 있지 실제로는 backgroundColor가 존재하지 않는다.

SwiftUI에서는 모든 view들이 사소한 struct이고 거의 만드는데 자유롭다. 이것에 대해 생각해보면, 만약 당신이 하나의 정수만이 있는 struct를 만든다면, 이 struct의 전체 사이즈는 하나의 정수 사이즈이다. 부모, 그 조상, 조상의 조상으로 부터 상속된 여분의 값 없이 struct는 정확하게 보이는 것만 가지고 나머지는 없다.

현대의 아이폰의 힘 덕분에, 천개의 정수 혹은 십만개의 정수를 만드는것에 대해 고려하지 않아도 되는 것처럼 SwiftUI에서도 천개의 view와 십만개의 view를 만들어도 걱정할 필요가 없다.

view를 struct로 사용하는데 성능도 중요한 이유이지만 더 중요한 이유가 있다. 그것은 우리에게 깔끔한 방법으로 독립적인 상태(state)를 생각하도록 강제한다는 것이다. 당신이 알듯이 class들은 자유롭게 그들의 value를 변경할 수 있다. 이는 코드를 엉망으로 만들 수 있다. SwiftUI는 UI를 업데이트를 하기 위해 언제 값이 변경되었는지 알 수 있는가?

변하지 않는 view들을 생성함으로써, SwiftUI는 보다 기능적인 디자인 설계 접근 방식으로 전환하도록 권장한다. 우리의 view들은 제어할 수 없게 되는 지능적인 것이 아니라, 데이터를 UI로 변환하는 단순하고 비활성 적인 것이 된다.

당신이 view가 될 수 있는 것들의 종류를 볼 때 실제로 동작하는 것을 볼 수 있다. 우린 이미 Color.rec와 LinearGradient를 적은 데이터를 가진 사소한 타입의 view로서 사용했다. 사실 당신은 Color.red를 view로서 사용하는것 보다 더 간단할 수 없다. 이것은 "나의 공간을 빨간색으로 채워라" 외에는 정보다 없다.

Apple의 UIView 문서와 비교하면, UIView에는 대략 200개의 property와 method가 있으며, 이것들을 subclass에서 필요하든 그렇지 않든 모두 전달한다.

Tip: 만약 당신이 view를 class로 만든다면 컴파일되지 않거나 런타임에서 크래시가 발생한다. 믿고 struct를 사용하자.


### 메인 SwiftUI view 뒤에 있는 것은 무엇인가?
```swift
struct ContentView: View  {
  var body: some View {
    Text("Hello World")
  }
}
```
SwiftUI를 처음 시작하면 위와 같은 코드가 생성되고, text view의 background color를 주면 스크린 전체를 채울 것이라 생각한다. 하지만 작은 text view에만 색깔이 채워지고 나머지는 배경은 흰색이다. 이는 사람들을 혼란스럽게 하고 view 뒤에 있는 것을 색으로 채우려면 어떻게 해야하는가?

SwiftUI 개발자들에게 명확하게 말해면 view 뒤에는 아무것도 없다. 

최소한 UIHostingController라는 content view 뒤에 무엇인가 있다. 이는 UIKit과 SwiftUI의 브릿지이다. 하지만 이것을 수정하려 한다면 Apple의 다른 플랫폼에서 코드가 더이상 동작하지 않으며, iOS에서는 동작이 완전히 멈출 것이다.

위에서 본 문제의 정답은 text view가 더 많은 공간을 차지하게 하는 것이다.
```swift
Text("Hello World")
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Color.red)
  .edgesIgnoringSafeArea(.all)
```


### modifier 순서가 왜 중요한가?
우리가 view에 modifier를 적용할 때 실제로는 기존의 view를 수정하는 것이 아니라 새로운 view를 만든 것이다. view는 우리가 제공한 property만 유지한다.

```swift
Button("Hello World") {
  print(type(of: self.body))
}
.background(Color.red)
.frame(width: 200, height: 200)
```
이 코드를 실행하면 200x200의 빨간색 버튼이 생길 것이라 생각할 수 있지만 실제로는 빨간색 Hello World와 그 주변이 비어있는 200x200 사각형의 버튼 표시된다. modifier가 동작하는 방법을 생각해보면 이해할 수 있는데 modifier는 view에 속성을 설정하는 대신 각각 새로운 struct를 생성하는 것이다.

Swift의 type(of:) 메소드는 특정 값의 정확한 타입을 출력한다. 그리고 위의 버튼은 이렇게 출력한다.
```
ModifiedContent<ModifiedContent<Button<Text>, _BackgroundModifier<Color>>, _FrameLayout>
```
- view를 수정할 때마다 SwiftUI는 generic을 사용하여 modifier를 적용한다.
- 다수의 modifier를 적용할 때 modifier는 쌓여간다.

어떤 타입인지 보기 위해서 안쪽부터 밖으로 읽어 나간다.
- 가장 안쪽 타입은 ModifiedContent<Button<Text>, _BackgroundModifier<Color>> 으로 버튼은 text를 가지며 background color가 적용됐다.
- 그 밖으로 ModifiedContent<..., _FrameLayout>으로, 첫번째 view를 가져오고 더 큰 frame을 적용했다.

여기서 볼 수 있듯이 view를 직접 수정하는 대신 변환할 각각의 view를 가져와 실제 변경사항을 적용하여 ModifiedContent를 쌓아가는 방식이다. **이것은 modifier의 순서가 중요함을 의미한다.** 우리의 코드에서 background를 frame 다음에 오도록 수정하면 기대하는 결과를 얻을 수 있다.
```swift
Button("Hello World") {
  print(type(of: self.body))
}
.frame(width: 200, height: 200)
.background(Color.red)
```
modifier를 사용하는데 중요한 부작용은 같은 효과를 여러번 적용할 수 있다는 것이다. 각각은 이전에 있었던게 무엇이든 단순히 추가만 한다. 예를들어
```swift
Text("Hello World")
  .padding()
  .background(Color.red)
  .padding()
  .background(Color.blue)
  .padding()
  .background(Color.green)
  .padding()
  .background(Color.yellow)
```
.padding()을 지워보면 알 수 있다.


### SwiftUI는 왜 "some View" 타입을 사용하는가?
SwiftUI는 당신이 매번 작성하는 some View에서 볼 수 있듯이 Swift의 강력한 기능 "opaque return types"에 의지한다. 

some View의 리턴은 그냥 View를 리턴 하는 것과 중요한 두가지 차이점이 있다.
1. 항상 같은 타입의 View를 리턴 해야한다.
2. 원래 타입이 무엇인지 모르지만 컴파일은 되어야한다.

첫번째 차이점은 성능을 위해 중요하다. 두번째 차이점은 SwiftUI가 ModifiedContent를 사용하기 때문에 중요하다(이전장에서 봤던것). View 프로토콜은 associatedType이 포함되어 있고, 이는 View자체로는 어떤 의미도 없다는 Swift의 방식을 말한다. 우린 어떤 종류의 타입인지 정확하게 말해야한다.
```swift
struct ContentView: View {
  var body: View {
    Text("Hello World")
  }
}
```
그래서 위처럼 작성하는 것은 허용되지 않고
```swift
struct ContentView: View {
  var body: Text {
    Text("Hello World")
  }
}
```
이렇게 작성하는 것이 완벽하게 합법적이다.

View를 리턴하는 것은 의미가 없다. Swift는 View 내부에 어떤것이 있는지 알고싶어 하기 때문이다. Text를 리턴하는 것은 View가 무엇인지 Swift가 알 수 있기 때문에 괜찮다. 그럼 다음 코드를 보자.
```swift
Button("Hello World") {
  print(type(of: self.body))
}
.frame(width: 200, height: 200)
.background(Color.red)
```
우린 body property에서 하나의 타입을 리턴하길 원하는데 어떻게 작성해야 하는가? 정확한 방법으로는 ModifiedContent generics의 조합으로 작성하길 시도하겠지만 이는 매우 고통스럽다. 

some View는 우리에게 "이것은 Button 혹은 Text처림 View의 특정한 하나의 타입을 리턴할 것이지만, 무엇인지는 말하고싶지 않다." 라고 말하는 것이다. 그래서 길고 정확하게 작성할 필요가 없고, 리턴하는 조건에도 만족한다.

#### Want to go further?
이제 VStack같은 것은 SwiftUI에서 어떻게 다룰 수 있는지 궁금할 수 있다. 만약 VStack안에 두개의 Text가 있다고 생각하면, SwiftUI는 두개의 view를 가질 수 있는 TupleView라는 특정한 타입을 생성한다. 그래서 VStack은 두개의 Text를 포함하는 TupleView라는 view의 종류로 구성되고, 만약 더 많은 Text를 가지면 TupleView가 그만큼 포함한다. 
```swift
TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>
```
이런 식으로 쌓여하기 때문에 SwiftUI는 부모안으로 10개보다 많은 view를 가질 수 없도록 되어있다.


## Advanced Usage


### Conditional modifiers
특정 조건에서만 작동하는 modifier는 일반적이며, SwiftUI에서 가장 쉬운 방법은 삼항 연산자이다.
```swift
struct ContentView: Viewe {
  @State private var useRedText = false

  var body: some View {
    Button("Hello World") {
      self.useRedText.toggle()
    }
    .foregroundColor(useRedText ? .red : .blue)
  }
}
```
useRedText가 true이면 빨강, false이면 파랑이 되는데 이는 SwiftUI가 @State 프로퍼티의 변화를 지켜보며 body 프로퍼티를 재호출 하기 때문이다.

조건문을 사용해서 상태에 따라 다르게 생긴 View를 리턴할 수도 있다. 그러나 이는 적은 상황에서만 사용 가능하고 아래와 같은 예제는 허용되지 않는다.
```swift
var body: some View {
  if self.useRedText {
    return Text("Hello World")
  } else {
    return Text("Hello World")
             .background(Color.red)
  }
}
```
some View를 리턴하면서 Text(...) 또는 Text(...).background(Color.red)를 리턴하는 것은 허용하지 않는다.


### Environment modifiers
많은 modifier들은 container에 적용이 가능하다. 예를들어 4개의 Text가 있고 모두 같은 modifier를 적용하고 싶다면, VStack에 적용한다.
```swift
VStack {
  Text("Gryffindor")
  Text("Hufflepuff")
  Text("Ravenclaw")
  Text("Slytherin")
}
.font(.title)
```
이는 environment modifier라 불리며, 일반 modifier와 다르다.

코드의 관점에서는 일반적인 modifier의 방법과 동일하게 사용되었지만, 만약 Text 중 같은 modifier를 사용하면 Text에 우선순위가 있다는 점에서 다르다.
```swift
VStack {
  Text("Gryffindor")
    .font(.largeTitle)
  Text("Hufflepuff")
  Text("Ravenclaw")
  Text("Slytherin")
}
.font(.title)
```
여기서 font()가 environment modifier이다. 이는 Text("Gryffindor")가 커스텀으로 재정의할 수 있다는 의미이다.

그러나 blur 효과는 하나의 Text에서 불가능하다.
```swift
VStack {
  Text("Gryffindor")
    .blur(radius: 0)
  Text("Hufflepuff")
  Text("Ravenclaw")
  Text("Slytherin")
}
.blur(radius: 5)
```
blur()는 일반적인 modifier이므로 같은 방법으로 동작하지 않는다. 모든 Text들은 VStack에 적용된 modifier가 적용된다.

environment modifier와 일반적인 modifier를 미리 구별하는 것은 불가능하며 경험이 필요하다. 하나의 modifier로 모든 곳에 적용하는 것이 각각의 모든 곳에 modifier를 붙여넣기 하는 방법보다 낫다.
