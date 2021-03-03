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
