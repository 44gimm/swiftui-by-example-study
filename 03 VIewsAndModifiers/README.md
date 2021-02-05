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