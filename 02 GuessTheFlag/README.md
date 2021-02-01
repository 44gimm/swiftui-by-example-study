# swiftui-by-example-study

[Hacking with iOS: SwiftUI Edition](https://www.hackingwithswift.com/books/ios-swiftui) 을 보며 내용 정리


## References
https://www.hackingwithswift.com/books/ios-swiftui  
https://github.com/twostraws/HackingWithSwift

# GuessTheFlag


***
## overview


### intro
두번째 프로젝트는 국기를 학습하는 게임을 만들것이다. 여전히 단순한 프로젝트이지만 stacks, buttons, images, alerts, asset catalogs 등에 대해서 소개한다.


### stack 사용하기
body 에서 여러개의 항목을 리턴하기 원할 때 HStack, VStack, ZStack은 유용하다.
```swift
var body: some View {
  Text("Hello World")
  Text("This is inside a stack")
}
```
SWiftUI에서는 하나의 view를 리턴하도록 해야한다.
```swift
VStack(spacing: 20) {
  Text("Hello World")
  Text("This is inside a stack")  
}
```
다른 view들과 마찬가지로 stack도 코드블럭 안으로 최대 10개의 자식 항목을 가질 수 있다. VStack과 HStack은 자동으로 그들의 컨텐츠에 맞춰 사이즈가 잡히고, 이용가능한 공간에서 센터에 위치한다. 이를 변경하기 위해서는 Spacer view를 사용해서 stack의 컨텐츠들을 한쪽으로 밀어낼 수 있다.
```swift
VStack {
  Text("First")
  Text("Second")
  Spacer()
}
```
Spacer를 더 추가하면 이용가능한 공간에서 공간을 나누어 차지한다.


### color와 frame
```swift
ZStack {
  Color.red
  Text("Your content")
}
```
Color.red는 사실 하나의 view다. 그래서 모양과 텍스트처럼 사용할 수 있다. 이는 자동으로 이용가능한 전체 공간을 차지하지만, frame() modifier로 특정 사이즈를 지정할 수 있다.
```swift
Color.red.frame(width: 200, height: 200)
```
SwiftUI는 Color.blue, Color.green, Color.primary등과 같이 빌트인된 color들을 제공하지만, 사용자가 커스텀하게 생성할 수도 있다.
```swift
Color(red: 1, green: 0.8, blue: 0)
```
Color.red를 사용하여 전체를 차지하도록 했지만, status bar(top)와 home indicator(bottom)가 흰 공간으로 남아있는 것을 볼 수 있다. Apple은 중요한 컨텐츠가 디바이스의 둥근 모서리에 가려지는 것을 원하지 않기 때문에 의도적으로 비워뒀다. 비워둔 공간을 제외한 공간을 safe area라 하며 여기서는 자유롭게 그릴 수 있다. 만약 너의 컨텐츠를 safe area 밖으로 내고싶다면 edgesIgnoringSafeArea() modifier를 사용하여 특정 영역으로 지정할 수 있다.
```swift
ZStack {
  Color.red.edgesIgnoringSafeArea(.all)
  Text("Your content")
}
```


### Gradient
SwiftUI에 3종류의 gradient가 있고, color처럼 UI에 그려질 수 있는 view다. gradient는 몇가지 컴포넌트로 구성된다.
- 표시할 color들의 배열
- 사이즈와 방향정보
- 사용할 gradient의 타입
```swift
LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)

```
LinearGradient는 하나의 방향을 가지고 시작 지점과 끝 지점을 지정한다.
```swift
RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 20, endRadius: 200)

```
RadialGradient는 원 모양에서 밖으로의 방향을 가지고 시작과 끝의 반경을 지정한다.
```swift
AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
```
AngularGradient는 밖으로의 방향으로 나가지 않고 원 주변으로 순환하여 효과를 만든다.

모든 gradient는 view로서 독립적으로 사용할 수 있고 modifier를 사용하여 text view의 백그라운드로도 사용 가능하다.


### 버튼과 이미지
SwiftUI에서 버튼은 어떻게 보이는가에 따라 두 가지 방법으로 만들 수 있다.
```swift
Button("Tap me!") {
  print("Button was tapped")
}

Button(action: {
  print("Button was tapped")
}) {
  Text("Tap me!")
}
```
첫번째는 버튼에 타이틀로서 텍스트만 포함하고, 클로저로 버튼이 탭 됐을 때 실행할 내용을 전달한다. 두번째는 버튼을 이미지나 view들의 조합으로 만들고 싶을 때 사용한다.

SwiftUI는 앱에서 이미지를 다루기 위한 타입으로 Image을 제공하고 생성할 수 있는 세 가지 방법이 있다.
- Image("pencil") 당신이 프로젝트에 추가한 "pencil" 이미지를 불러 올 것이다.
- Image(decorative: "pencil") 동일한 이미지를 불러오지만 screen reader를 설정한 사용자에게는 읽어지지 않을 것이다. 추가로 중요한 정보를 전달하지 않는 이미지에 유용하다?
- Image(systemName: "pencil") iOS에 빌트인된 pencil아이콘을 불러온다.
```swift
Button(action: {
  print("Edit button was tapped")
}) {
  HStack(spacing: 10) {
    Image(systemName: "pencil")
    Text("Edit")
  }
}
```
stack을 사용하여 이미지와 함꼐 조합할 수 있다.

Tip: 당신의 이미지가 실제 이미지가 아니라 color solid blue로 채워진다면, 이는 아마 SwiftUI에서 탭이 가능함을 보이려 추가한 것이다. 이를 수정하기 위해서는 renderingMode(.original) modifier를 추가하여 강제로 SwiftUI가 원본 이미지를 사용하도록 하자.























