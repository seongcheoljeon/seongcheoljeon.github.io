# virtual, override, final 키워드

c++ 상속을 공부하며 많이 보았던 키워드는 virtual 키워드일 것이다. virtual에 비하여 많이 보지 못했던 키워드는 override와 final 키워드일 것이다.   

override와 final 키워드는 c++11 이후에 등장하는 키워드라서 그렇다. 고로 오래된 c++ 책으로 공부를 했다면 virtual 키워드만 보았을 가능성이 높다. virtual, override, final은 모두 상속 관련하여 오버라이딩할 때 사용하는 키워드들이다. 조금씩 용도는 다르다.   

override와 final 키워드가 새롭게 추가된 이유를 한번 알아보고 각 키워드가 무엇을 뜻하는지 살펴보자.   

## <i class="fa fa-arrow-circle-right" aria-hidden="true"></i> virtual 키워드

virtual 키워드는 가상 함수를 뜻한다. 가상함수에는 함수의 몸체를 정의하지 않는 순수 가상함수(추상화)와 정의를 하는 일반 가상함수로 나눌 수 있다.   

보통 virtual 키워드를 붙이면, 해당 클래스를 상속받는 하위 클래스에서 virtual 키워드의 함수를 재정의(오버라이딩) 한다는 뜻이다. 그리고 virtual 키워드는 가상 함수의 처음 부분에 붙인다. 즉, 부모 클래스에 붙인다고 생각하면 된다.   

가상 함수는 주로 실행 시간(runtime)에 함수의 다형성(polymorphism)을 구현하는데 사용한다.   

```c++
#include <iostream>

using namespace std;

class BaseClass{
public:
    virtual void ShowMe(){
        cout<<"base class"<<endl;
    }
};

class SubClass : public BaseClass{
public:
    void ShowMe(){
        cout<<"sub class"<<endl;
    }
};

int main(int argc, const char * argv[]) {
    BaseClass* bc;
    SubClass sc;
    bc = &sc;
    
    bc->ShowMe();
   
    return 0;
}
```

가상 함수 선언에는 몇가지 규칙이 존재한다.

* 클래스의 공개(public) 섹션에 선언한다.
* 가상 함수는 정적(static)일 수 없으며, 다른 클래스의 친구(friend) 함수가 될 수 없다.
* 가상 함수는 실행시간 다형성을 얻기 위해 기본 클래스의 포인터 또는 참조를 통해 접근(access) 해야 한다.
* 가상 함수의 프로토타입(반환형과 매개변수)은 기본 클래스와 파생 클래스에서 동일해야 한다.
* 클래스는 가상 소멸자를 가질 수 있지만 가상 생성자를 가질 수는 없다.

## <i class="fa fa-arrow-circle-right" aria-hidden="true"></i> override 키워드

override 키워드는 c++11 이후로 나온 키워드이다. 이 키워드도 가상함수를 가르키기 위한 키워드라고 할 수 있다.다만, override와 virtual이 다른 점은 키워드를 붙이는 위치라고 할 수 있다.   
virtual은 부모 클래스 가상함수의 시작 부분에 붙였다면, override는 하위 클래스 가상함수에 붙인다.

!!! Note
    override 키워드가 붙은 함수라면, 이 가상함수는 부모로부터 상속받아 오버라이딩한 함수다 라는 것을 뜻한다.

```c++
#include <iostream>

using namespace std;

class BaseClass{
public:
    virtual void ShowMe(){
        cout<<"base class"<<endl;
    }
};

class SubClass : public BaseClass{
public:
    void ShowMe() override {
        cout<<"sub class"<<endl;
    }
};

int main(int argc, const char * argv[]) {
    BaseClass* bc;
    SubClass sc;
    bc = &sc;
    
    bc->ShowMe();
   
    return 0;
}
```

!!! Failure
    만약, 아래처럼 override 키워드가 붙어있는데 부모와 형식(반환형, 매개변수)이 다르다면 오류를 발생시킨다.

```c++
class SubClass : public BaseClass{
public:
    void ShowMe(int a) override {
        cout<<"sub class"<<endl;
    }
};
```

## <i class="fa fa-arrow-circle-right" aria-hidden="true"></i> final 키워드

final 키워드도 c++11 이후로 나온 키워드이다. 이 키워드도 마찬가지로 가상함수를 가르킨다.
final은 가상함수의 마지막을 가르키는 키워드라고 생각하면 된다. 즉, 계속해서 오버라이딩을 진행하다가 마지막 하위 클래스에서의 가상함수에는 virtual, override가 아닌 final을 붙인다는 것이다.

!!! Note
    final 키워드가 붙었다면, 이 가상함수를 더 이상 오버라이딩하지 않겠다 라는 뜻이 된다.

```c++
#include <iostream>

using namespace std;

class BaseClass{
public:
    virtual void ShowMe(){
        cout<<"base class"<<endl;
    }
};

class SubClass : public BaseClass{
public:
    void ShowMe() override {
        cout<<"sub class"<<endl;
    }
};

class ChildClass : public SubClass{
public:
    void ShowMe() final {
        cout<<"child class"<<endl;
    }
};

class SubChildClass : public ChildClass{
public:
    // 상속받는 클래스의 가상함수에 final이 붙어있으므로 에러가 발생한다.
    void ShowMe() override {
        cout<<"sub child class"<<endl;
    }
}

int main(int argc, const char * argv[]) {
    BaseClass* bc;
    SubChildClass scc;
    bc = &scc;
    
    bc->ShowMe();
   
    return 0;
}
```

## <i class="fa fa-arrow-circle-right" aria-hidden="true"></i> 정리

간단한 세 가지 키워드로 예제를 살펴보자.

```c++
class BaseClass{
    // 가상함수의 첫 시작은 virtual 키워드이다. 순수 가상함수로 만듦.
    virtual void ShowMe() = 0;
};

class SubClass : public BaseClass{
    // 상속받은 가상함수에는 override 키워드를 붙인다.
    void ShowMe() override {};
};

class ChildClass : public SubClass{
    // 가상함수의 마지막에는 final 키워드를 붙인다.
    void ShowMe() final {};
};
```

먼저, BaseClass에서 ShowMe()라는 순수가상함수를 만들었다. 이 때, 가상함수를 하위에서 오버라이딩할 것이므로 virtual 키워드를 붙였다.

이후, SubClass에서 BaseClass를 상속받는다. ShowMe() 가상함수는 오버라이딩 할 것이므로, override 키워드를 붙였다. 참고로 virtual 키워드를 붙여도 차이점은 없다.

```c++
class SubClass : public BaseClass{
    // 상속받은 가상함수에는 override 키워드를 붙인다.
    // virtual 키워드를 붙여도 상관없다.
    virtual void ShowMe() override {};
};
```

다만, override를 붙여주면 이 가상함수가 처음 선언될 경우에 에러를 발생시킨다. 이로인해 개발시 도움이 된다.

만약 virtual 키워드만 사용한다면 아래와 같은 상황에 직면할 수도 있다.

```c++
class BaseClass{
    virtual void ShowMe() {};
};

class SubClass : public BaseClass{
    virtual void ShowMe(int val) {};
};
```

위의 ShowMe() 가상함수들은 서로 다른 가상함수이다. 왜냐면 형식이 다르기 때문이다. 그래서 이러한 경우를 예방하기 위하여 override 키워드를 사용한다. 그러면 빌드할 때, 에러가 발생하여 잘못되었음을 인지할 수 있다.

마지막으로 ChildClass에서는 SubClass를 상속받는다. ChildClass에서 ShowMe() 가상함수에 final을 붙였으므로 해당 가상함수는 더 이상 오버라딩을 하지 않겠다라는 의미를 부여한다. 이때에도 마찬가지로 virtual 또는 override 키워드를 붙여도 상관 없다.

```c++
class ChildClass : public SubClass{
    // virtual 또는 override 또는 virtual, override 모두 붙여도 상관 없다.
    virtual void ShowMe() override final {};
};
```

간단히 말해서 Subclass를 상속받는 하위 클래스에서 ShowMe() 가상함수를 더 이상 오버라이딩할 수 없게 만들겠다는 뜻이다.

만약, final 키워드가 붙은 가상함수를 오버라이딩하려고 한다면 빌드 에러가 발생하여 사전에 잘못된 부분을 고칠 수 있는 이점이 있다.