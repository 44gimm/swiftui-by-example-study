# swiftui-by-example-study

[Hacking with iOS: SwiftUI Edition](https://www.hackingwithswift.com/books/ios-swiftui) 을 보며 내용 정리


## References
https://www.hackingwithswift.com/books/ios-swiftui  
https://github.com/twostraws/HackingWithSwift


# GuessTheFlag


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
LinearGradient(
  gradient: Gradient(colors: [.white, .black]), 
  startPoint: .top, 
  endPoint: .bottom)
```
LinearGradient는 하나의 방향을 가지고 시작 지점과 끝 지점을 지정한다.
```swift
RadialGradient(
  gradient: Gradient(colors: [.blue, .black]), 
  center: .center, 
  startRadius: 20, 
  endRadius: 200)
```
RadialGradient는 원 모양에서 밖으로의 방향을 가지고 시작과 끝의 반경을 지정한다.
```swift
AngularGradient(
  gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), 
  center: .center)
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
stack을 사용하여 이미지와 함께 조합할 수 있다.

Tip: 당신의 이미지가 실제 이미지가 아니라 color solid blue로 채워진다면, 이는 아마 SwiftUI에서 탭이 가능함을 보이려 추가한 것이다. 이를 수정하기 위해서는 renderingMode(.original) modifier를 추가하여 강제로 SwiftUI가 원본 이미지를 사용하도록 하자.


### alert 메시지 
View들은 우리 프로그램의 상태의 함수이고, alert도 예외는 아니다. 우리는 "alert를 보여줘"라고 말하기 보다는 alert를 생성하고 상태에 따라 보여지도록 한다.
```swift
Alert(
  title: Text("Hello SwiftUI"), 
  message: Text("This is some detail message"), 
  dismissButton: .default(Text("OK")))
```
SwiftUI의 기본 alert는 제목, 메시지, 닫기버튼이 있다. 원하는 경우 버튼을 더 상세히 구성할 수 있다. alert를 나태내기 위해 myAlert.show() 와 같은 예전의 사고방식 형태로 작성하지 않을 것 이다. 대신에 alert를 보이는 상태를 추가한다.
```swift
@State private var showingAlert = false
```
이렇게 하면 우리의 UI 어디서든 alert를 나타낼 수 있고, 상태에 따라서 alert를 보여줄지 숨길지 알릴 수 있다. SwiftUI는 showingAlert를 보고 있으며, true가 될 경우 alert를 보여 줄 것이다.
```swift
struct ContentView: View {
  @State private var showingAlert = false

  var body: some View {
    Button("Show Alert") {
      self.showingAlert = true
    }
    .alert(isPresented: $showingAlert) {
      Alert(
        title: Text("Hello SwiftUI"),
        message: Text("This is some detail message"),
        dismissButton: .default(Text("OK")))
    }
  }
}
```
.alert(isPresented: $showingAlert) 는 양방향 바인딩이 되어 있는데, 이유는 alert가 닫힐 경우 SwiftUI가 자동으로 showingAlert를 false로 되돌리기 때문이다.


***
## implementation


### 버튼 쌓기
우리는 UI의 기본 구조를 사용자에게 설명하는 2개의 라벨과 3개의 국기 이미지로 된 버튼으로 구성할 것이다. 파일명이 국가의 이름으로 되어있는 국기 이미지 asset들을 추가한다. 다음으로 게임 데이터를 저장하기 위해, 게임에 보여줄 국가의 이미지명 배열과 국가 이미지 정답 정수를 property로 필요하다.
```swift
var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
var correctAnswer = Int.random(in: 0...2)
```
Int.random(in:)은 랜덤 숫자 하나를 선택하고 이는 정답으로서 tap 되어야 할 국기를 결정한다.
```swift
var body: some View {
  ZStack {
    VStack(spacing: 30) {
      VStack {
        Text("Tap the flag of")
        Text(countries[corretAnswer])
      }

      ForEach(0 ..< 3) { number in 
        Button(action: {
          // flag was tapped
        }) {
          Image(self.counttries[number])
            .renderingMode(.original)
        }
      }
    }
  }
}
```
같은 VStack 안으로 Text와 Button들을 생성해도 되지만, Text들 사이로는 간격이 없고 아래로 생성될 버튼들은 30포인트씩 간격이 있는게 좋아 보이므로 두번째 VStack을 생성하여 간격을 조절하자. UI의 기본적인 아이디어는 주어졌지만 화면은 좋아보이지 않는다. 흰배경이 흰국기와 배경이 섞이며, 모든 국기들은 화면의 가운데 새로로 배치되어있다. 배경도 넣고 간격을 조절하기 위해 ZStack으로 VStack들을 감싸자. 
```swift
ZStack {
  Color.blue.edgesIgoringSafeArea(.all)

  VStack(spacing: 30) {
    VStack {
      Text("Tap the flag of")
        .foregroundColor(.white)
      Text(countries[corretAnswer])
        .foregroundColor(.white)
    }

    ForEach
    ...
  }

  Spacer()
}
```
배경을 파란색으로하고 .edgesIgoringSafeArea() modifier로 스크린의 edge까지 채우자. 좀 더 어두운 배경색이 되었으므로 Text들의 색상도 변경하는 게 나아 보인다. 마지막으로 UI들을 위쪽으로 옮기기 위하여 Spacer()를 추가하자.


### alert으로 플레이어의 점수 나타내기
이 게임을 즐기기 위해서, 우린 국기들을 랜덤으로 보여주고 국기를 선택 시 정답인지 아닌지 alert로 알려준 후 다시 섞는 과정이 필요하다. 이미 랜덤한 correctAnswer를 설정했지만. 국기들은 항상 똑같은 순서이다. 이를 고치기위해 수정하자.
```swift
var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
  .shuffled()
```
shuffled 메소드는 자동으로 배열의 순서를 랜덤으로 만든다.

다음은 화면의 국기가 선택이 되었을 때 우린 정답인지 아닌지 결정할 코드가 필요하다. 새로운 메소드를 생성하여 선택된 버튼의 번호와 correctAnswer가 일치한지 판단하자. 정답이 정확한지 유무와 상관없이 사용자에게 alert로 어떤 일이 일어났는지 알려주길 원하니 alert의 표시 유무를 추가하자. 그리고 alert안에 들어갈 제목을 저장할 property도 추가하자.
```swift
@State private var showingScore = false
@State private var scoreTitle = ""
```
그리고 body property 바로 다음에 메소드를 추가하자
```swift
func flagTapped(_ number: Int) {
  if number == correctAnswer {
    askQuestion()
    
  } else {
    scoreTitle = "Wrong"
  }

  showingScore = true
}
```
이제 버튼 액션의 주석 // flag was tapped 부분을 메소드 호출로 대체할 수 있다.
```swift
self.flagTapped(number)
```
alert를 보여주기 전에 우린 alert가 닫힐 때 무슨 일이 일어날지 생각해봐야한다. 국가배열을 다시 섞고 correctAnswer를 다시 할당하는 method가 필요하다.
```swift
func askQuestion() {
  countries.shuffle()
  correctAnswer = Int.random(in: 0...2)
}
```
메소드 추가와 함께 countries와 correctAsnwer property에 @State property wrapper를 추가하자.

이제 alert를 나타낼 준비가 됐다.
1. alert() modifier를 사용하여 showingScore가 true인 경우 나타난다.
2. scoreTitle을 보여준다.
3. askQuestion() 를 호출할 취소버튼이 있다.
그럼 body property안에 ZStack의 끝에 다음을 작성하자
```swift
.alert(isPresented: $showingScore) {
  Alert(
    title: Text(scoreTitle), 
    message: Text("Your score is ???"), 
    dismissButton: .default(Text("Continue")) {
      self.askQuestion()
    })
}
```
??? 에는 나중에 점수가 나타날 것이다.


### 국기 스타일링
우리의 게임은 동작하지만 보기에는 좋지않다. 몇가지 작은 수정을 통해 훨씬 보기 좋게 만들 수 있다.

첫번쨰로 화면의 파란색 배경을 blue to black LinearGradient로 수정하자. Color.blue.edgesIgnoringSafeArea(.all)을 아래와 같이 수정하자.
```swift
LinearGradient(
  gradient: Gradient(colors: [.blue, .black]), 
  startPoint: .top, 
  endPoint: .bottom)
  .edgesIgnoringSafeArea(.all)
```

다음으로 국가 이름을 생성하자. 우린 font()와 fontWeight() modifier들을 이용하여 눈에 잘 띄게 만들 수 있다. Text(countries[correctAnswer])에 modifer를 작성하자.
```swift
.font(.largeTitle)
.fontWeight(.black)
```
"Large title"은 ios에서 제공하는 가능 큰 사이즈의 폰트이다. 이는 자동으로 사용자가 설정한 폰트에 따라 자동으로 확장 또는 축소된다.

마지막으로 국기 이미지를 수정하자. SwiftUI는 View가 보여질 수 있는 다양한 modifier를 제공한다. 여기서는 국기의 모양을 변경하고, border를 추가, 그림자는 주는 방법을 사용하자.

Swift에 빌트인된 형태는 직사각형, 라운드직사각형, 원형, 캡슐형이 있다. 여기서는 캡슐형으로 나타나도록 modifier를 추가하자.
```swift
.clipShape(Capsule())
```

이미지 주변으로 border를 그리기위해 overlay() modifier를 사용하자. 이는 국기 위로 새로운 view를 그릴 수 있도록 해준다.
```swift
.overlay(Capsule().stroke(Color.black, lineWidth: 1))
```

마지막으로 국기에 그림자를 적용하자. .shadow() modifier를 사용하자.
```swift
.shadow(color: .black, radius: 2)
```

결과적으로 이미지 코드는 다음과 같다.
```swift
Image(self.countries[number])
  .renderingMode(.original)
  .clipShape(Capsule())
  .overlay(Capsule().stroke(Color.black, lineWidth: 1))
  .shadow(color: .black, radius: 2)
```

SwiftUI에서 font와 image에 적용할 수 있는 많은 modifier를 제공한다. 이들은 모두 한가지만 수행하므로, 위에서 볼 수 있듯이 쌓아 두는 것이 일반적이다.



## challenges


### wrap up
VStack, HStack, ZStack은 앞으로 대부분의 프로젝트에서 사용하게 될 것이다. 많은 사람들이 처음에는 SwiftUI의 alert를 생성하기 위해 상태를 추가하는 방법이 조금 이상하다 생각하겠지만, 우리의 view들이 항상 프로그램의 상태에 따라 나타나야 한다는 점에 있어 중요하고, 우리가 원할 때만 alert가 표시되는 것(옛날 방식)에서 벗어나야 한다.

여기에 진행상황을 완전히 이해해야 우리의 앱을 확장할 수 있는 세가지 방법이 있다.
1. 사용자가 정답 혹은 오답을 선택할 시 수정되는 점수를 저장할 @State property를 추가하자. 이는 alert로 보일 것이다.
2. 국기들 아래에 사용자의 현재 점수를 label로 보여라.
3. 사용자가 오답을 선택할 경우 “Wrong! That’s the flag of France,"과 같은 alert 메시지를 보여라.

