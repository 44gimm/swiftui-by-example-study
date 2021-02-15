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

우린 BetterRest라는 이름의 앱을 빌드한다. 이것은 커피를 마시는 사람들이 아래 세 가지 질문과 함께 밤에 잘 자는 데 도움이되기 위해 설계되었다.
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
"%g" specifier를 사용하면 자동으로 소수점 끝자리 0을 지워준다. 그러므로 8, 8.25, 8,5, 8.75, 9,... 로 출력이 되고 좀 더 자연스럽다.


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
