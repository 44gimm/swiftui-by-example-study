# swiftui-by-example-study

[Hacking with iOS: SwiftUI Edition](https://www.hackingwithswift.com/books/ios-swiftui) 을 보며 내용 정리


## References
https://www.hackingwithswift.com/books/ios-swiftui  
https://github.com/twostraws/HackingWithSwift

# BetterRest
Use machine learning to improve sleep


## Overview


### intro
이번 SwiftUI 프로젝트는 다른 양식기반(form-based) 앱이다. 정말 간단한 앱이지만 ios 개발의 강력한 기능 중 하나인 머신러닝을 소개한다. 

우린 몇몇 raw data로 시작할 것이며, Mac에 training data로 제공하고, 그 결과로 new data에 대하여 정확히 추정할 수 있는 앱을 빌드할 것이다.

우린 BetterRest라는 이름의 앱을 빌드한다. 이것은 커피를 마시는 사람들이 아래 세 가지 질문과 함께 밤에 잘 자는 데 도움이 되기 위해 설계되었다.
1. 언제 일어나길 원하는지?
2. 대략 잠을 얼마나 자기를 원하는지?
3. 하루에 커피를 몇 잔 마시는지?

세가지 질문에 답을하면 우린 Core ML로 입력하여 언제 잠에 들어야하는지 결과를 받을 것이다.


### Stepper로 숫자 입력하기
SwiftUI는 사용자가 숫자를 입력하는데 두가지 방법이 있다. 여기서는 그 중 하나인 간단한 -, + 버튼을 사용하여 정확한 숫자를 선택할 수 있는 Stepper를 사용할 것이다. 다른 하나는 Slider로 다음에 사용한다.

Stepper는 어떤 타입의 숫자를 입력하는데 충분하며 Int, Double 등과 함께 bind 할 수 있다.
```swift
@State private var sleepAmount = 0.0
```
그러면 현재 값을 보여줄 수 있는 stepper를 bind 할 수 있다.
```swift
Stepper(value: $sleepAmount) {
  Text("\(sleepAmount) hours")
}
````
Stepper는 기본적으로 사용하는 타입만큼 범위의 한계가 있다. 다행이 Stepper는 **in** 파라미터로 범위를 지정하는 만큼 제한할 수 있다. 세번째 **step** 파라미터로 -, +를 눌렀을 때 얼마나 움직일지 지정하는 것도 유용하다.
```swift
Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
  Text("\(sleepAmount) hours")
}
````
소숫점을 수정하기 위해 Text에 specifier를 사용한다.
```swift
Text("\(sleepAmount, specifier: "%g") hours")
```
"%g" specifier를 사용하면 자동으로 소수점 끝자리 0을 지워준다. 그러므로 8, 8.25, 8,5, 8.75, 9,... 로 출력이 되고 더 자연스럽다.


### DatePicker로 날짜와 시간 선택하기
SwiftUI는 Date property와 bind 될 수 있는 DatePicker를 제공한다.
```swift
@state private var wakeUp = Date()
```
그러면 DatePicker와 bind 할 수 있다.
```swift
var body: some View {
  DatePicker("Please enter a date", selection: $wakeUp)
}
```
빈 문자열을 파라미터로 제공해도 DatePicker에 label의 영역을 차지한다. 이를 해결하기 위해 labelsHidden() modifier를 사용하자.
```swift
var body: some View {
  DatePicker("Please enter a date", selection: $wakeUp)
    .labelsHidden()
}
```
여전히 기존의 label을 포함하고 있어 screen render는 VoiceOver에 사용할 수 있지만 화면에서는 더이상 보이지 않고, DatePicker는 화면의 가운데 위치한다.

DatePicker는 동작하는 두가지 옵션을 제공한다. **displayedComponents**를 사용하여 사용자가 볼 수 있는 옵션을 결정한다.
- 파라미터를 제공하지 않으면 사용자는 day, hour, minute을 볼 수 있다.
- .date를 파라미터로 제공하면 사용자는 month, day, year를 볼 수 있다.
- .hourAndMinute을 파라미터로 제공하면 사용자는 hour, minute을 볼 수 있다.

우린 아래와 같이 설정한다.
```swift
DatePicker(
  "Please enter a time", 
  selection: $wakeUp, 
  displayedComponents: .hourAndMinute)
```
마지막으로 **in** 파라미터를 Stepper처럼 사용하면 Date의 범위를 지정할 수 있다. Swift에서는 Date도 범위를 지정할 수 있다.
```swift
DatePicker(
  "Please enter a time", 
  selection: $wakeUp, 
  in: Date()...)
```
이렇게 작성하면 과거는 선택할 수 없고 현재와 미래만 선택하도록 제한할 수 있다.


### date로 작업하기
사용자가 날짜를 입력하는 것은 쉽지만 나중에는 모호해진다. date작업은 어렵다. 에제를 보자.
```swift
let now = Date()
let tomorrow = Date().addingTimeInterval(86400)
let range = now ... tomorrow
```
range는 지금 현재부터 똑같은 시간의 다음날까지이다. 간단해 보이지만 항상 모든 날이 86400초가 아니다. 예를 들어 윤초가 있다. 

날짜의 계산과 포멧팅을 위해 Apple의 프레임워크에 의존해야 한다. 이번 프로젝트에서 우리는 세가지 방법으로 Date를 사용할 것이다.
1. 합리적인 기본 잠에서 깨는 시간 선택
2. 사용자가 원하는 잠에서 깨는 시, 분 보기
3. 제안하는 잠드는 시간 양식에 맞게 보여주기

윤초와 같은 어려운 작업은 직접 손으로 작성할 수도 있지만 iOS에 맡겨 더 적게 일하고 더 정확한 결과를 얻도록 하자.

첫번째는 Swift가 제공하는 Date는 년, 월, 일, 시, 분, 초, 타임존 등 많은 것을 제공하지만 우리가 원하는 것은 "요일과 상관없이 오전 8시 일어나는 시간"이다. Swift는 DateComponents라는 것을 제공하고, 이는 특정 타입에 맞게 쓰거나 읽기 가능하게 한다. 만약 오전 8시를 표현하길 원한다면 아래와 같이 작성할 수 있다.
```swift
var components = DateComponents()
components.hour = 8
components.minute = 0
let date = Calendar.current.date(from: components) ?? Date()
```

두번째는 그들이 원하는 시간을 어떻게 읽을 수 있는가이다. DatePicker는 Date와 bind 되어 있고, 우린 시와 분 요소들을 가져오면 된다.
```swift
let components = Calendar.current.dateComponents([.hour, .minute], from: someDate)
let hour = components.hour ?? 0
let minute = components.minute ?? 0
```

세번째는 어떻게 날짜와 시간을 양식에 맞추는가이다. DateFormatter를 이용하여 작성한다.
```swift
let formatter = DateFormatter()
formatter.timeStyle = .short
let dateString = formatter.string(from: Date())
```
.dateStyle을 사용하여 날짜 값을 얻을 수도 있다. 그리고 완전히 커스텀하게 dateFormat을 사용할 수도 있다.


### Create ML로 모델 훈련하기
Apple의 프레임워크 Core ML 덕분에 iOS11에서 디바이스 머신 러닝이 "완전히 가능하고, 놀랍도록 강력"하게 되었고, 1년 뒤 더 쉽게 사용할 수 있는 Create ML을 만들고, 2년 뒤에는 Create ML의 모든 프로세스를 드래그 앤 드롭으로 가능하게 만들었다. 그 결과 누구나 머신 러닝을 추가할 수 있게 되었다.

Core ML은 이미지, 소리, 모션 인식들과 같은 훈련된 작업을 다루는게 가능하지만, 이번에는 tabular regression을 다루어 볼 것이다. 이것은 스프레드시트와 같은 데이터를 Create ML로 제공하고 다양한 값들 사이의 관계를 알아내는 것이다.

머신 러닝은 두 단계로 완료된다. 모델을 훈련하고, 예측을 만들도록 요청한다. 훈련은 컴퓨터가 우리의 데이터를 바라보며 데이터 사이의 관계를 알아내는 과정이다. 예측은 디바이스에서 완성되는데 훈련된 모델을 제공하면 이전 데이터를 사용하여 새로운 데이터에 대해 추산하는 것이다.

훈련의 과정을 시작하기 위해서 Mac의 Create ML app을 사용하자.

Create ML을 열면 프로젝트를 생성할지 이전의 것을 가져올지 묻는다. 새로 생성하자(New Document). 다양한 템플릿을 볼 수 있는데 Tabular Regression을 선택하고 프로젝트 이름을 BetterRest로 작성.

첫번째 단게는 Creat ML에 훈련 데이터를 제공하는 것이다. [Github]( https://github.com/twostraws/HackingWithSwift) 이는 잠을 언제 일어나길 원하고, 얼마동안 자길 원하며, 하루에 커피를 몇 잔 마시는지, 실제 자는 시간을 raw한 통계이다. 프로젝트 파일에 있는 BetterRest.csv이며, Create ML이 작업할 수 있도록 콤마로 분리된 값 데이터이고 이를 가져와야한다.

Create ML에서 Data 입력 Training Data라는 제목의 아래에서 Choose를 선택한다. 그 다음 파일선택을 눌러 BetterRest.csv를 선택한다.

**중요**: 이 csv 파일은 프로젝트를 위한 샘플데이터이므로 실제 작업에는 사용하지 마세요.

다음은 컴퓨터가 예측하기위해 학습하기를 원하는 값의 대상과 검사할 값들의 대상을 정하는 것이다.

여기서는 컴퓨터가 실제로 필요한 잠의 양을 예측하기 위해 학습할 대상을 정하기위해 Target으로 "actualSleep"을 선택한다. 그리고 Select Features 버튼을 누르고(현재는 Choose Features로 버튼 타이틀이 변경된 듯 하다) 세가지 옵션 모두를 선택한다. 

Select Features 버튼 아래에 Alogirithm 드롭다운 메뉴에서 5가지(Automatic, Random Forest, Boosted Tree, Decision Tree, Linear Regression)이 있는데, 각자 다른 방법으로 데이터를 분석한다. 

유용하게 자동으로 최적의 알고리즘을 선택하는 Automatic 옵션이 있다. 이는 항상 정확하지는 않지만 이번 프로젝트에서는 충분하다.

