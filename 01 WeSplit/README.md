# swiftui-by-example-study

[Hacking with iOS: SwiftUI Edition](https://www.hackingwithswift.com/books/ios-swiftui) 을 보며 내용 정리


## References
https://www.hackingwithswift.com/books/ios-swiftui  
https://github.com/twostraws/HackingWithSwift

# WeSplit
음식과 가격을 입력 후 팁과 사람 수를 선택하면 각각 지불해야 할 금액을 알려주는 앱


***
### intro
이 프로젝트는 SwiftUI의 기본을 가르치기 위함. UI design의 기본, 사용자 입력 값과 선택, 이들의 상태를 어떻게 추적하는지 배우게 될 것.
프로젝트 생성
- 프로젝트명: WeSplit
- user interface: SwiftUI


***
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


***
### form 생성
Form은 텍스트와 이미지와 같은 정적 제어로 스크롤이 가능한 리스트이지만, text fields, toggle switches, buttons등 과 같이 유저 인터렉티브한 제어로도 가능하다.
```
Form {
	Text("Hello, world!")
	Text("Hello, world!")
	Text("Hello, world!")
	...
	Text("Hello, world!")
}
```
Form 안으로 많이 작성할 수 있지만 10개를 넘어가는 순간 SwiftUI에서 제한한다. 이러한 부모안의 자식의 갯수 제한은 SwiftUI의 모든 곳에 적용된다.

이 문제를 해결하기 위해서 Form에서는 Group 혹은 Section을 사용한다.
```
Form {
	Group {
		Text("Hello, world!")
		Text("Hello, world!")	
		Text("Hello, world!")
		...
		Text("Hello, world!")
	}

	Group {
		Text("Hello, world!")
		Text("Hello, world!")	
		Text("Hello, world!")
		...
		Text("Hello, world!")
	}
}
```
Group은 화면으로 변화는 없지만, 부모안의 자식의 갯수 제한을 피할 수 있도록 한다.
```
Form {
	Section {
		Text("Hello, world!")
	}

	Section {
		Text("Hello, world!")
		Text("Hello, world!")
	}
}
```
Section은 화면에서 아이템들을 시각적으로 분리하는 그룹 역할을 한다.

***
### navigation bar 생성
```
var body: some View {
	NavigationView {
		Form {
			Section {
				Text("Hello World")
			}
		}
		.navigationBarTitle(Text("SwiftUI"))
	}
}
```
처음 NavigationView를 생성하면 상단에 영역만 차지하는 View가 생성되어 title이 비어있다가, .navigationBarTitle() 이라는 modifier를 form에 붙이면 title이 나타난다. modifier란 일반적인 메소드인데 한가지 차이점은 사용할 때 항상 새로운 인스턴스를 리턴한다. 기본 값이 large title이고 displayMode 파라미터를 추가로 전달하여 inline title로도 사용가능하다.


***
### modifying program state
View는 상태의 함수다. 상태에 따라 사람들이 볼 수 있고, 인터렉트할 수 있는 것을 의미한다.
```
struct ContentView: View {
	var tapCount = 0

	var body: some View {
		Button("Tap Count: \(tapCount)") {
			self.tapCount += 1
		}
	}
}
```
위 코드는 충분히 합리적으로 보이지만 빌드가 되지 않는다. ContentView는 sturct라서 tapCount를 변경할 수 없다(immutable). 이를 mutating 키워드로 해결했지만, SwiftUI에서는 허락하지 않는다.
```
@State var tapCount = 0
```
위와 같이 수정하면 원하는대로 동작한다. @State는 property wrapper로 struct의 한계를 극복해 SwiftUI에서 값을 수정해 저장할 수 있도록 한다.

이는 약간 속임수 같고, 자유롭게 값을 변경할 수 있는 class를 사용하면되지 않나? 하지만 계속 학습하면 알겠지만 SwiftUI는 빈번하게 struct를 삭제하고 재생성하므로 작고 단순한 struct를 유지하는 것이 성능에 유리하다.

Tip: SwiftUI에서 상태를 저장하는 방법은 여러가지 있지만 @State는 특별히 하나의 뷰에 단순한 프로퍼티로 저장되도록 디자인 되었다. Apple은 여기에 private 접근제한자를 추가하라 권장한다.
```
@State private var tapCount = 0
```


***
### UI에 상태 바인딩
@State로 View의 프로퍼티를 업데이트할 수 있지만 UI control에서는 좀 더 복잡하다.
```
struct ContentView: View {
  @State private var name = ""
  
  var body: some View {
    Form {
      TextField("Enter yout name", text: name)
      Text("Hello World")
    }
  }
}
```
TextField와 Text를 포함하는 Form이 있다. TextField가 표현할 상태를 저장하는 name 프로퍼티를 선언하고 이를 수정해야하니 @State로 선언했다. 하지만 빌드가 되지 않는다. Swift는 name이 TextField에 보여지는 것과 TextField가 변경되었을 경우 다시 name을 수정하는 것을 구별하기 때문이다. 

이를 위해 양방향 바인딩이 필요한데, 아래와 같이 달러 사인이라는 특별한 심볼을 사용한다.
```
TextField("Enter yout name", text: $name)
```
이러면 TextField는 name을 읽을 수 있고, 변경 시 다시 쓸 수 있다. Text("Hello World")를 아래와 같이 변경하자.
```
Text("Your name is \(name)")
```
왜 $name이 아니지? 양방향 바인딩이 필요없기 때문이다. $ 달러 사인을 보면 양방향 바인딩임을 기억하자.


***
### 반복문으로 view 생성
arrays와 ranges를 순회할 수 있는 ForEach를 사용한다. ForEach는 블록 안에 10개 제한 룰도 피할 수 있다.
```
struct ContentView: View {
  let students = ["Harry", "Hermione", "Ron"]
  @State private var selectedStudent = 0
  
  var body: some View {
    VStack {
      Picker("Select your student", selection: $selectedStudent) {
        ForEach(0 ..< students.count) {
          Text(self.students[$0])
        }
      }
      
      Text("Your chose: Student # \(students[selectedStudent])")
    }
  }
}
```
Picker 뷰에 항목을 만드는데 ForEach가 유용하다. students를 순회하여 Picker 뷰의 선택 항목들을 생성하고 선택된 항목과 selectedStudent가 양방향 바인딩 되어있다.




























