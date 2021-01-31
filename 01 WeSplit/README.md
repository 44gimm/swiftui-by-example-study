# swiftui-by-example-study

[Hacking with iOS: SwiftUI Edition](https://www.hackingwithswift.com/books/ios-swiftui) 을 보며 내용 정리


## References
https://www.hackingwithswift.com/books/ios-swiftui  
https://github.com/twostraws/HackingWithSwift

# WeSplit
음식과 가격을 입력 후 팁과 사람 수를 선택하면 각각 지불해야 할 금액을 알려주는 앱


## overview


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



## implementation


***
### TextField로 사용자의 텍스트 읽기
가격입력, 가격을 분담할 사람 수, 원하는 팁을 설정하기 위해 ContentView의 프로퍼티로 선언한다.
```
@State private var checkAmount = ""
@State private var numberOfPeople = 2
@State private var tipPercentage = 2
```
checkAmount는 Int혹은 Double이 나아보이지만, SwiftUI에서 textField의 값으로 사용하려면  String이다.
```
let tipPercentages = [10, 15, 20, 25, 0]
```
사용 가능한 팁배열을 선언하고 tipPercentage가 Picker를 이용하여 선택한 팁의 index이다.

body를 수정한다.
```
  var body: some View {
    Form {
      Section {
        TextField("Amount", text: $checkAmount)
      }
      
      Section {
        Text("$\(checkAmount)")
      }
    }
  }
```
전체가 스크롤되는 2개의 Section이 포함된 Form을 생성한다. TextField의 placeholder가 "Amount"이고 checkAmount와 양방향 바인딩 되어있다.

@State property wrapper의 가장 훌륭한 점중 하나는 자동으로 변화를 관찰하는 것인데, 어떤 일이 발생하면 자동으로 body property를 다시 호출하는 것이다. 이는 변경된 상태에 따라 UI를 다시 로드하는 훌륭한 방법이고 SwiftUI가 동작하는 근본적인 기능이다.

이를 확인하기 위해 시뮬레이터로 코드를 실행하면 
1. TextField는 checkAmount property와 양방향 바인딩 되어있고
2. checkAmount는 @State로 선언되어, 자동으로 값의 변화를 관찰하고
3. @State property가 변화가 생기면 SwiftUI는 body property를 다시 호출하고
4. 업데이트된 checkAmount가 Text로 나타날 것이다.

사용자가 편하게 사용하도록 TextField에 keyboardType()을 추가하자.
```
TextField("Amount", text: $checkAmount)
  .keyboardType(.decimalPad)
```
Tip: .numberPad와 .decimalPad는 숫자로된 키보드가 등장하지만 사용자가 숫자 외의 값을 입력하는 것은 막을 수는 없다.


***
### Form에 Picker생성
Picker는 다양한 목적으로 제공되며, 정확히 어떻게 보이는지는 디바이스와 Picker 컨텍스트에 따라 달라진다.
```
  Section {
    TextField("Amount", text: $checkAmount)
      .keyboardType(.decimalPad)
    
    Picker("Number of people", selection: $numberOfPeople) {
      ForEach(2 ..< 100) {
        Text("\($0) people")
      }
    }
  }
```
Picker가 Form 밖에 있으면 spinning wheel 옵션이 등장하자만, Form 안에 있으면 양식을 입력받는 형태로 적절하게 SwiftUI에서 자동으로 변경한다. 그리고 Section 안의 Picker 열에 회색 indicator가 있지만 이를 선택하면 아무 동작을 하지 않는다. 새로운 뷰로 Picker의 옵션들을 나타내기 위해 navigationView를 추가해야한다.
```
var body: some View {
  NavigationView {
  	Form {
  	  // form 안의 코드들
  	}
  	.navigationBarTitle("WeSplit")
  }
}
```
수정 후 다시 실행하고 Number of people 열을 선택하면 옵션을 선택할 수 있는 새로운 스크린이 슬라이드된다. 4 people이 체크마크 되어있고 다른 것을 탭할 수 있으며 스크린은 자동으로 이전 화면으로 갈것이다.

여기서 보이는 것은 선언적 UI 디자인의 중요성이다. 이것은 우리가 어떻게 해야할지 말하기 보다 무엇을 원하는지 말하는 것을 의미한다. 우리는 몇개의 값이 있는 Picker를 원한다 말했지만, spinning wheel picker인지 또는 새로운 뷰로 옵션을 나타내는 picker인지는 SwiftUI가 결정한다.

Tip: .navigationBarTitle("WeSplit")을 NavigationView 끝에 붙이려고 생각할 수 있지만 Form 끝에 붙여야한다. 이유는 프로그램이 동작하면서 NavigationView는 많은 View를 표시할 수 있기 때문에, NavigationView 내부에 title을 붙여 iOS에서 title 변경을 자유롭게 할 수 있다. (사실 이유가 무슨 이야기인지 이해를 못하겠다.)


***
### 팁 퍼센트를 위한 segmented control 추가
우린 두번째 Picker를 추가해야 하는데, 이번에는 좀 다르게 segmented control을 원한다. 이는 Picker의 중류 중 하나로 수평 리스트 옵션과 적은 선택지를 표시하기에 유용하다.

두 개의 Section이 있는데 중간에 Section을 하나 추가하자.
```
Section {
  Picker("Tip percentage", selection: $tipPercentage) {
    ForEach(0 ..< tipPercentages.count) {
      Text("\(self.tipPercentages[$0])%")
    }
  }
}
```
이전의 Picker와 같은 방법으로 Picker를 생성했고, SwiftUI는 리스트에서 하나의 row와 옵션을 선택할 수 있는 새로운 스크린을 만들 것이다. 그러나 segmented control이 더 나아 보이므로 이를 위해 modifier를 Picker에 추가하자
```
.pickerStyle(SegmentedPickerStyle())
```
우리는 문제를 해결하기 위해 디자인했기 때문에 자동으로 무엇을 의도했는지 전부를 알 수 있지만 실제로는 그렇지 않다. 두번째 섹션이 팁을 고르기 위한 것임을 우린 알지만 Picker가 무엇을 의미하는지 명확하지 않다. 명확하게 수정하자.
```
Section(header: Text("How much tip do you want to leave?")) {
```
두번째 Section을 위와 같이 수정하자. SwiftUI는 Section에 header와 footer를 추가할 수 있도록 해준다. 코드의 작은 변화로 훨씬 나은 결과를 만들었다.



***
### 계산
지금까지는 checkAmount를 그대로 Text에 나타냈지만, 각각의 사람이 지불해야 하는 금액이 나오도록 수정한다. 쉽게 보이지만 약간의 small wrinkles가 있다.
- numberOfPage는 사람수와 2만큼 떨어져있다. 3은 5명을 뜻한다.
- tipPercentage는 tipPercentages 배열의 index를 저장한다.
- checkAmount는 사용자가 입력한 String이고, 숫자는 유효하나 문자열이 들어가 있을 수 있고 비어 있을 수 있다.
계산된 property를 생성하자.
```
var totalPerPerson: Double {
  let peopleCount = Double(numberOfPeople + 2)
  let tipSelection = Double(tipPercentages[tipPercentage])
  let orderAmount = Double(checkAmount) ?? 0

  let tipAmount = orderAmount / 100 * tipSelection
  let grandTotal = orderAmount + tipAmount
  let amountPerPerson = grandTotal / peopleCount
    
  return amountPerPerson
}
```
그리고 마지막 Section을 수정하자
```
Section {
  Text("$\(totalPerPerson, specifier: "%.2f")")
}
```
이제 SwiftUI의 view들이 상태의 함수라는 말의 의미를 직접 보기를 희망한다. 상태가 변경되면 자동으로 view들이 자동으로 일치하도록 업데이트된다.



## Challenges


***
### WeSplit: 마무리
이번 프로젝트에서 SwiftUI 기본 구조, Form, NavigationView, @State, TextField, Picker, ForEach를 배웠다.

챌린지
- 세번째 Section에 “Amount per person” header 추가
- 사람 수로 나주지 않고 팁을 포함한 전체 가격을 나타내는 Section 추가
- "Number of people" Picker를 TextField로 수정하고 알맞는 키보드타입 지정하기
