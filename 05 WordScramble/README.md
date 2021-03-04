# swiftui-by-example-study

[Hacking with iOS: SwiftUI Edition](https://www.hackingwithswift.com/books/ios-swiftui) 을 보며 내용 정리


## References
https://www.hackingwithswift.com/books/ios-swiftui  
https://github.com/twostraws/HackingWithSwift

# Word Scramble
Build a letter rearranging game with List


## Overview


### intro
이번 프로젝트는 또다른 게임이다. 이 게임은 플레이어에게 무작위로 8개의 단어를 보여주고, 단어를 만들기를 요구한다. 따가가다 보면 유용한 기술 List, onAppear(), Bundle, fatalError()를 만날 것이다. 시작하기위해 프로젝트를 생성하고 "start.txt" 파일을 다운로드 받자.


### List 소개
SwiftUI의 모든 view 타입들 중에서 List를 가장 많이 사용할 것이다. 새로운 것은 아니며 UIKIt에서는 UITableView와 동등하다. List의 역할은 데이터의 스크롤링 테이블을 제공하는 것이다. Form도 이상적이지만 List는 사용자의 입력을 요청하는 것보다는 데이터를 표현하는데 주로 사용된다.

Form 처럼 정적 view로 List를 사용할 수도 있다.
```swift
List {
  Text("Hello World")
  Text("Hello World")
  Text("Hello World")
}
```

ForEach를 배열이나 범위로부터 사용해서 동적으로 row를 생성할 수도 있다.
```swift
List {
  ForEach(0..<5) {
    Text("Dynamic row \($0)")
  }
}
```

더 흥미로운 것은 정적 동적 row를 혼합할 수도 있다.
```swift
List {
  Text("Static row 1")

  ForEach(0..<5) {
    Text("Dynamic row \($0)")
  }

  Text("Static row 2")
}
```

더 읽기 쉽도록 Section과 결합할 수도 있다.
```swift
List {
  Section(header: Text("Section 1")) {
    Text("Static row 1")
    Text("Static row 2")
  }

  Section(heaer: Text("Section 2")) {
    ForEach(0..<5) {
      Text("Dynamic row \($0)")
    }
  }

  Section(header: Text("Section 3")) {
    Text("Static row 3")
    Text("Static row 4")
  }
}
```

이 List는 이전에 보았던 Form과는 다르게 보이는데, 다른것은 테이블의 뷰 스타일뿐이다. modifier를 listStyle() 사용하여 비슷한게 만들 수 있다.
```swift
.listStyle(GroupedListStyle())
```

List에서는 가능하고 Form이 할 수 없는 한 가지는 ForEach 없이 완전히 동적 row를 생성할 수 있는 것이다.
```swift
List(0..<5) {
  Text("Dynamic row \($0)")
}
```

배열과 함께 작동할 때 SwiftUI는 각각의 row들이 유일한 값인지 식별할 필요가 있다. 그래야 만약 하나가 삭제되었을 때 전체 List를 다시 그리지 않고 간단하게 해당 row만 삭제할 수 있다. 이것은 id 파마미터를 통해 들어오고, List와 ForEach에서 동일하게 동작하며 SwiftUI에게 배열의 각 항목을 유일한 값으로 만들도록 알려준다.

문자열이나 숫자의 배열로 작업할 때 항목들을 유일하게 만들 수 있는 것은 값 자기 자신이다. 만약 [2, 4, 6, 8, 10]과 같은 배열에서는 숫자 자체가 유일한 식별자이다. 그래서 우리는 List 데이터를 작업할 때 **id: \.self**를 사용할 수 있다.
```swift
struct ContentView: View {
  let people = ["Finn", "Leia", "Luke", "Rey"]

  var body: some View {
    List(people, id: \.self) {
      Text($0)
    }
  }
}
```

ForEach 에서도 동일하게 동작하므로 정적 동적 row들을 혼합하고 싶다면 아래와 같이 사용할 수 있다.
```swift
List {
  ForEach(people, id: \.self) {
    Text($0)
  }
}
```


### 앱 번들로부터 리소스 불러오기
Image view들을 사용할 때 SwiftUI는 자동으로 앱의 asset catalog를 봐야하는걸 알지만, 텍스트파일과 같은 다른 데이터는 우리가 더 작업해야한다.

Xcode가 iOS앱을 빌드할 때 "bundle"이라는 것을 생성한다. 이는 애플의 모든 플랫폼에서 발생하고, 이는 시스템이 모든 파일을 하나의 장소에 저장하게 한다. 미래에는 당신이 하나의 앱에 어떻게 다수의 번들을 포함할 수 있는지 알게 될 것이고, siri extention, iMessage apps, watchOS 등 많은 것들을 main bundle이라 부르는 하나의 iOS앱 번들에 쓸 수 있다는 것을 알게 될 것이다.

URL이라는 새로운 타입을 사용하는데, 이것은 단순히 웹 주소들을 저장하는 것을 넘어 파일의 위치를 저장할 수 있어서 유용하다. 이를 메인 앱 번들의 URL을 읽기 원한다면
```swift
if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
  // we found the file in our bundle!
}
```

URL을 가지고 있으면 stirng으로 불러올 수 있다.
```swift
if let fileContents = try? String(contentsOf: fileURL) {
  // we loaded the file into a string!
})
```


### 문자열 작업하기
iOS는 문자열을 다루기 위한 몇가지 강력한 API들을 제공한다. 이 앱에서 우리는 app bundle로 부터 만개가 넘는 여덟 자리 단어를 포함하는 파일을 불러와 사용할 것이다. 단어 하나당 한줄에 저장되어 있고, 단어들을 나누어 무작위로 하나를 가져올 수 있도록 배열로 만들고 싶다.

Swift는 이를 위해 components(separatedBy:) 메소드를 제공한다.
```swift
let input = """
            a
            b
            c
            """
let letters = input.components(separatedBy: "\n")
```

결과는 문자열 배열이고 하나의 요소를 무작위로 뽑기위해 ramdomElement()를 사용한다.
```swift
let letter = letters.randomElement()
```

또 다른 유용한 메소느는 trimmingCharacters(in:)이 있는데, 특정 characters를 문자열에서 삭제할 수 있게 한다.
```swift
let trimmed = letter?.trimmingChracters(in: .whitespacesAndNewlines)
```

이 기능은 UITextChecker 클래스를 통해 제공된다. UI가 붙는 이유는 두가지가 있다.
1. 이 클래스는 UIKit에 있다. 그러나 UIKit의 모든 인터페이스를 불러와야 하는 것은 아니고 SwiftUI가 자동으로 가져온다.
2. 이 클래스는 Objective-C 언어로 작성되었다. 

철자가 틀린 단어가 있는지 확인하기위해 총 네가지 단계가 있다. 첫번째로 검사할 단어와 UITextChecker 인스턴스를 생성한다.
```swift
let word = "swift"
let checker = UITextChecker()
```

두번째 chekcer에게 검사해야 할 단어의 양을 정해야한다. utf16을 사용하는 이유는 swift와 Objective-c가 문자열을 저장하는 방식을 같게 하기 위함이다.
```swift
let range = NSRange(location: 0, lenght: word.utf16.count)
```

세번째 단어에서 철자가 잘못된 부분이 있는지 결과를 받로록 checker에 요청한다. 그러면 잘못된 부분의 위치를 Objective-c 문자열 범위를 리턴하고, 없을 경우 Objective-c는 옵셔널 개념이 없으므로 다른 방법인 NSNotFound를 리턴한다.
```swift
let misspelledRange = checker.rangeOfMisspelledWord(
  in: word, 
  range: range, 
  startingAt: 0, 
  wrap: false, 
  language: "en")
```

그래서 우린 철자가 잘못된 부분이 있는지를 NSNotFound를 확인하면 된다.
```swift
let allGood = misspelledRange.location == NSNotFound
```