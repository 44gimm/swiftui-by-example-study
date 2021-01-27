# swiftui-by-example-study

[Hacking with iOS: SwiftUI Edition](https://www.hackingwithswift.com/books/ios-swiftui) 을 보며 내용 정리


## References
https://www.hackingwithswift.com/books/ios-swiftui  
https://github.com/twostraws/HackingWithSwift

# WeSplit
음식과 가격을 입력 후 팁과 사람 수를 선택하면 각각 지불해야 할 금액을 알려주는 앱


### intro
이 프로젝트는 SwiftUI의 기본을 가르치기 위함. UI design의 기본, 사용자 입력 값과 선택, 이들의 상태를 어떻게 추적하는지 배우게 될 것.
프로젝트 생성
- 프로젝트명: WeSplit
- user interface: SwiftUI


### SwiftUI 앱의 기본 구조 이해
프로젝트 네비게이터를 보면
- AppDelegate.swift: 앱의 관리를 위한 코드를 포함.
- SceneDelegate.swift: 앱의 윈도우를 실행하기 위한 코드 포함. 동시에 여러 인스턴스를 실행할 수 있는 iPad 에서 더 많은 역할을 함.
- ContentView.swift: 프로그램의 초기 UI가 포함.
- Assets.xcassets: asset catalog.
- LaunchScreen.storyboard: 앱이 실행될 때 보여줄 UI 구성.
- info.plist: 앱이 어떻게 동작할 지 작성된 특별한 값 모음.
- Preview Content group: preview asset catalog.

ContentView.swift를 open
```
struct ContentView: View
```
View 프로토콜을 따르는 struct를 생성. View 프로토콜은 SwiftUI의 기본 프로토콜이며 화면에 그리려는 모든 항목(text, buttons, images, ...)에서 채택되어야함.

```
var body: some View
```
some View는 View 프로토콜을 따르는 것을 리턴하고, some 키워드는 반드시 동일한 타입의 View를 리턴하도록 제한함. View 프로토콜은 some View를 리턴하는 body라는 이름의 프로퍼티로 구성되어야 하는 한가지 요구사항만이 존재함.

```
Text("Hello World")
```
"Hello World" 문자열을 사용하는 text view 생성. text view들은 간단한 정적 텍스트이며, 자동으로 멀티라인.

```
struct ContentView_Previews: PreviewProvider
```
실제로 App Store에 등록되는 final app에 포함되지 않지만, Xcode에서 UI 디자인을 미리볼 수 있게함.

이 preview들은 Xcode에서 canvas라 불리는 기능. 코드를 visible하게 나타냄. 원하는 경우 커스텀이 가능하며, canvas에서만 영향이 있지 실제 실행되는 app에서는 영향없음.

Tip: canvas는 갱신이 종종 에러가 발생하는데, 재실행 Option+Cmd+P shortcut을 추천.


### form 생성
