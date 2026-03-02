---
title: "[Programming/C++] 클래스 템플릿 (Class Template)"
description: >-
  자료형에 독립적인 클래스를 정의해, 다양한 타입으로 재사용할 수 있게 해주는 C++ 템플릿 기능.
author: seongcheol
date: 2026-03-02 18:49:00 +0900
categories: [Programming, C++]
tags: [C++, Class Template]
pin: true
image:
  path: /assets/img/common/title/cpp_title.jpg
---

## 템플릿으로 범용 클래스 만들기

`클래스 템플릿`은 템플릿을 클래스에 적용한 것으로, 템플릿 매개변수를 활용해 다양한 형식에 대응할 수 있는 범용 클래스를 만드는 방법이다. 클래스 템플릿은 함수 템플릿보다 조금 복잡하지만, 기본적인 문법은 그리 어렵지 않다.
보통은 클래스 템플릿을 직접 선언하기보다는 라이브러리에서 이미 선언된 클래스 템플릿을 이요할 때가 더 많다.

템플릿 선언은 함수 템플릿 선언할 때와 동일하다. `template`과 `typename` 키워드로 템플릿 매개변수들을 선언한다.

```cpp
template <typename Type1, typename Type2>
class data_package {
public:
  data_package(Type1 first, Type2 second) : first(first), second(second) {}
private:
  Type1 first;
  Type2 second;
}
```

`클래스 템플릿`은 범용 데이터 형식을 지정할 자리에 템플릿 매개변수를 사용하는 것 외에는 일반 클래스와 같다. 
`템플릿 매개변수`는 멤버 함수나 변수에 모두 사용할 수 있다. 함수 템플릿을 만들었던 것처럼 멤버 함수를 만들면 된다. 함수 템플릿과 다른 점은 **`명시적 특수화`뿐만 아니라 `부분 특수화`도 사용할 수 있다는 점**이다.

클래스 템플릿으로 객체를 생성할 때는 템플릿 매개변수에 사용할 데이터 형식을 지정한다. 그리고 생성자나 멤버 함수에서 템플릿 매개변수에 맞춰 지정한 데이터 형식을 일관되게 유지하면서 사용하면 된다. 그러면 컴파일러가 지정된 데이터 형식을 사용하는 클래스를 인스턴스화한다.

```cpp
int main() {
  data_package<int, double> template_inst1(5, 33.3);
  data_package<string, int> tewmplate_inst2("Hello", 123);
  ...
}
```

다음은 템플릿으로 클래스를 만들고 사용하는 코드의 예이다.

```cpp
#include <iostream>
#include <string>

using namespace std;

template <typename Type1, typename Type2>
class data_package {
public:
    data_package(Type1 first, Type2 second) : first(first), second(second) {}
    void print_out_element() {
        cout << "첫 번째 요소: " << first << ", 두 번째 요소: " << second << endl;
    }
private:
    Type1 first;
    Type2 second;
};


int main()
{
    data_package<int, double> template_inst1(5, 33.3);
    data_package<string, int> template_inst2("Hello", 10);

    template_inst1.print_out_element();
    template_inst2.print_out_element();

    return 0;
}
```

```output
첫 번째 요소: 5, 두 번째 요소: 33.3
첫 번째 요소: Hello, 두 번째 요소: 10
```
{: .nolineno }

`C++17` 부터 클래스 템플릿에서도 형식을 추론할 수 있게 되었지만, 컴파일러는 템플릿 매개변수의 형식을 완벽하게 추론해 낼 수 없다. 데이터 형식이 명확할 때는 상관이 없지만, 모호할 때는 직접 명시해 주어야 한다.

---

## 부분 특수화

템플릿을 사용하다 보면 특정 데이터 형식의 값을 별도로 처리해야 할 때가 있다. 함수 템플릿에서 사용했던 명시적 특수화가 하나의 예이다. 
클래스 템플릿의 `특수화`는 템플릿 매개변수 전체를 지정할 수 있는 `명시적 특수화`뿐만 아니라, 일부만 지정할 수 있는 `부분 특수화`를 이용할 수도 있다.

> `부분 특수화`는 클래스 템플릿을 인스턴스화할 때 매개변수를 특정 형식의 값으로 처리하는 것이다. 

다음은 첫 번째 템플릿 매개변수를 문자열로 지정하는 부분 특수화의 예이다.

```cpp
#include <iostream>
#include <string>

using namespace std;

template <typename Type1, typename Type2>
class data_package {
public:
    data_package(Type1 first, Type2 second) : first(first), second(second) {}
    void print_out_element() {
        cout << "첫 번째 요소: " << first << ", 두 번째 요소: " << second << endl;
    }
private:
    Type1 first;
    Type2 second;
};


template <typename T>
class data_package<string, T> {
public:
    data_package(string first, T second) : first(first), second(second) {}
    void print_out_element() {
        cout << "[부분 특수화] " << "첫 번째 요소: " << first << ", 두 번째 요소: " << second << endl;
    }

private:
    string first;
    T second;
};


int main()
{
    data_package<int, double> template_inst1(5, 33.3);
    data_package<string, int> template_inst2("Hello", 10);

    template_inst1.print_out_element();
    template_inst2.print_out_element();

    return 0;
}
```

실행 결과

```output
첫 번째 요소: 5, 두 번째 요소: 33.3
[부분 특수화] 첫 번째 요소: Hello, 두 번째 요소: 10
```
{: .nolineno }

실행 결과를 보면 기존과 다르게 동작하는 것을 알 수 있다. 클래스 템플릿의 객체를 생성할 때 첫 번째 인자의 타입을 `string`으로 입력하면, `부분 특수화`가 적용된 `class data_package<string, T>`가 인스턴스화된다. 이처럼 **클래스 템플릿의 부분 특수화를 이용하면 몇몇 형식을 특정하여 별도로 처리할 수 있다.**

> **클래스 템플릿은 선언과 정의가 같이 있어야 한다.**
>
> 클래스 템플릿은 일반 클래스와 거의 모든 동작이 같다. 클래스를 상속받을 수 있고 함수를 오버라이딩할 수 있다. 다만, 클래스 템플릿의 선언과 정의를 별도의 파일로 분리하면 안 된다.
> 일반 클래스는 선언과 정의를 별도의 파일로 분리할 수 있으며, 정의가 복잡하고 길 때는 다시 여러 파일로 나눌 수도 있다. ***하지만 클래스 템플릿은 선언과 정의가 한 파일에 있어야 한다.***
{: .prompt-danger }

---

## 중첩 클래스 템플릿

클래스 내에 중첩된 클래스를 만들 수 있는 것처럼 클래스 템플릿도 중첩할 수 있다. 중첩된 클래스 템플릿(inner class)에서는 기존 클래스 템플릿(outer class)의 매개변수를 사용할 수도 있고 새로 정의해도 된다. 바깥쪽 클래스의 템플릿 매개변수를 사용하면 안쪽 클래스에서도 같은 데이터 형식으로 사용된다.

중첩된 클래스 템플릿을 사용하는 방법은 두 가지이다. 

- **안쪽 클래스를 멤버 변수처럼 사용하는 방법**
  - 멤버 변수이므로 바깥쪽 클래스에서 안쪽 클래스의 멤버 변수를 선언하고 필요하면 초기화도 진행한다.
- **안쪽 클래스를 독립된 객체로 선언해서 사용하는 방법**
  - 이때 주의할 점은 템플릿이 중첩된 형태이므로 바깥쪽 클래스의 템플릿 매개변수도 모두 입력해야 한다는 점이다.

```cpp
#include <iostream>
#include <string>

using namespace std;

template <typename Type1, typename Type2>
class data_package {
public:
    template <typename Type3>
    // 안쪽 클래스
    class nested_class_data_package {
    public:
        Type3 nested_class_data;
        nested_class_data_package(Type3 data) : nested_class_data(data) {}
        Type3 get_element() {
            return nested_class_data;
        }
    };

    // 새로운 템플릿 매개변수 사용
    template <typename Type4>
    // 안쪽 클래스
    class nested_class {
    public:
        nested_class(Type4 data) : nested_class_data(data) {}
        void print_out_element() {
            cout << "중첩 클래스 데이터: " << nested_class_data << endl;
        }
    private:
        Type4 nested_class_data;
    };

    data_package(Type1 first, Type2 second) : first(first), second(second), internal_data(second) {}

    void print_out_element() {
        cout << "첫 번째 요소: " << first << ", 두 번째 요소: " << second << endl;
        cout << "중첩 클래스 요소: " << internal_data.get_element() << endl;
    }
private:
    Type1 first;
    Type2 second;
    nested_class_data_package<Type2> internal_data;
};


int main()
{
    data_package<string, int> template_inst1("Hello", 10);
    data_package<string, int>::nested_class<int> template_inst2(55);

    cout << "중첩 클래스 첫 번째 범례" << endl;
    template_inst1.print_out_element();

    cout << endl << "중첩 클래스 두 번째 범례" << endl;
    template_inst2.print_out_element();

    return 0;
}
```

실행 결과

```output
중첩 클래스 첫 번째 범례
첫 번째 요소: Hello, 두 번째 요소: 10
중첩 클래스 요소: 10

중첩 클래스 두 번째 범례
중첩 클래스 데이터: 55
```
{: .nolineno }

첫 번째 범례는 멤버 변수로 만드는 경우이다. 이때는 일반적인 클래스 템플릿과 같으며 이를 클래스 안에서 사용하는 것이다. 템플릿 매개변수에 맞춰서 코드를 작성하면 클래스 템플릿을 사용하는 멤버 변수를 사용할 수 있다. 

안쪽 클래스에서는 nested_class_data_package처럼 바깥쪽 클래스의 템플릿 매개변수의 데이터형식(Type2)을 템플릿 매개변수(Type3)로 사용하거나 nested_class처럼 새로 정의(Type4)해서 사용할 수도 있다. 위의 예에서는 바깥쪽 클래스 템플릿과 안쪽 클래스 템플릿 같에 상속 관계가 없다. 따라서 중첩되었어도 접근 지정자는 상속 관계를 고려하지 않고 독립적으로 적용된다.

두 번째 범례는 논리적으로 중첩된 클래스이다. 안쪽 클래스를 객체로 생성하는 것이 아니라 정의만 중첩되고 실제 객체는 필요할 때 생성된다. 이는 일반적인 클래스 템플릿의 활용과 같다. 다만, 범위 연산자로 안쪽 클래스 템플릿의 이름을 붙여 객체를 선언한다.

---

## 템플릿 매개변수 기본값

`C++`언어의 함수는 기본값으로 동작하도록 만들 수 있다. 즉, 매개변수의 기본값을 정의해 놓으면 함수를 호출할 때 값을 전달하지 않아도 된다. 

템플릿 매개변수도 기본값을 설정해서 사용할 수 있다. 다만, 템플릿 매개변수는 데이터 형식을 나타내므로 여기서 `기본값`이란 기본 데이터 형식을 나타낸다. 즉, 클래스 템플릿의 객체를 생성할 때 템플릿 매개변수의 형식을 입력하지 않아도 기본으로 설정한 데이터 형식이 지정된다.

다음 코드에서 템플릿을 선언할 때 매개변수 `T`의 기본 형식을 `int`로 설정했으므로 클래스 템플릿의 객체를 생성할 때 형식을 지정하지 않거나 전체(`<>`)로 지정하면 `int`형이 된다. `int`형이 아닐 때는 해당 형식(예에서는 `string`)을 명시해 주면 된다.

```cpp
#include <iostream>
#include <string>


using namespace std;


// 기본 형식 설정
template <typename T = int>
class data_package {
public:
    data_package(T first) : first(first) {}
    void print_out_element() {
        cout << "템플릿 매개변수 값: " << first << endl;
    }

private:
    T first;
};


int main()
{
    // 기본 형식(여기서는 int)으로 지정
    data_package<> template_inst1(15);
    data_package<string> template_inst2("클래스 템플릿 기본값이 아닌 string형");

    template_inst1.print_out_element();
    template_inst2.print_out_element();

    return 0;
}
```

실행 결과

```output
템플릿 매개변수 값: 15
템플릿 매개변수 값: 클래스 템플릿 기본값이 아닌 string형
```
{: .nolineno }

---

## 클래스 템플릿 프렌드

클래스 템플릿의 `프렌드`는 인스턴스화 순서와 프렌드 규칙을 준수해야 하므로 주의해야 할 것들이 있다. 그 외에는 모두 일반 프렌드와 같다.

우선 클래스 템플릿을 프렌드로 선언하는 코드를 살펴보자.

```cpp
#include <iostream>
#include <string>


using namespace std;


template <typename U>
class caller {
public:
    caller() : object(nullptr) {}
    void set_object(U* obj_ptr) { object = obj_ptr; }
    void printout_friend_object() {
        cout << "(friend 클래스 템플릿 호출) 템플릿 매개변수 값: " << object->first << endl;
    }

private:
    U* object;
};


template <typename T = int>
class data_package {
public:
    data_package(T first) : first(first) {}
    friend caller<data_package>;
private:
    T first;
};


int main()
{
    caller<data_package<>> caller_int_obj;
    caller<data_package<string>> caller_string_obj;

    data_package<> template_inst1(5);
    data_package<string> template_inst2("클래스 템플릿 기본값이 아닌 string형");

    caller_int_obj.set_object(&template_inst1);
    caller_string_obj.set_object(&template_inst2);

    caller_int_obj.printout_friend_object();
    caller_string_obj.printout_friend_object();

    return 0;
}
```

실행 결과

```output
(friend 클래스 템플릿 호출) 템플릿 매개변수 값: 5
(friend 클래스 템플릿 호출) 템플릿 매개변수 값: 클래스 템플릿 기본값이 아닌 string형
```
{: .nolineno }

프렌드 클래스는 반드시 `friend`로 지정되기 전에 선언과 정의가 있어야 한다. 위의 예에서는 data_package 클래스 이전에 caller 클래스 템플릿이 있다. 만약 두 클래스 템플릿의 위치가 뒤바뀌면 오류가 발생한다.

다음은 클래스 템플릿에서 프렌드 함수를 정의하는 코드의 예이다.

```cpp
#include <iostream>
#include <string>


using namespace std;


template <typename T = int>
class data_package {
public:
    data_package(T first) : first(first) {}

    friend void printout_friend_element(data_package<T>& data_obj) {
        cout << "(friend 클래스 템플릿 호출) 템플릿 매개변수 값: " << data_obj.first << endl;
    }
    
private:
    T first;
};


int main()
{
    data_package<> template_inst1(5);
    data_package<string> template_inst2("클래스 템플릿 기본값이 아닌 string형");

    printout_friend_element(template_inst1);
    printout_friend_element(template_inst2);

    return 0;
}
```

실행 결과

```output
(friend 클래스 템플릿 호출) 템플릿 매개변수 값: 5
(friend 클래스 템플릿 호출) 템플릿 매개변수 값: 클래스 템플릿 기본값이 아닌 string형
```
{: .nolineno }

위의 코드에서는 클래스 템플릿에 `프렌드 함수`를 선언하면서 정의까지 했다. 템플릿 매개변수를 그대로 사용할 수 있는 가장 간단한 방법이다. 이렇게 하면 printout_friend_element 함수는 `전역`에서 접근할 수 있으며, 친구가 된 data_package 클래스의 비공개 멤버에 접근할 수 있다.

그런데 이 방법은 간단하지만 가독성이 떨어진다. `전역 함수`임을 확실히 알게 하려면, 다음 처럼 ***클래스 템플릿에서 프렌드 선언만 하고 정의는 바깥쪽에서 하는 편이 더 좋다.***

```cpp
#include <iostream>
#include <string>


using namespace std;


template <typename T = int>
class data_package {
public:
    data_package(T first) : first(first) {}

    // 프렌드 함수 선언
    template <typename C>
    friend void printout_friend_element(C& data_obj);
    
private:
    T first;
};


// 프렌드 함수 정의
template <typename C>
void printout_friend_element(C &data_obj) {
    cout << "(friend 클래스 템플릿 호출) 템플릿 매개변수 값: " << data_obj.first << endl;
}


int main()
{
    data_package<> template_inst1(5);
    data_package<string> template_inst2("클래스 템플릿 기본값이 아닌 string형");

    printout_friend_element(template_inst1);
    printout_friend_element(template_inst2);

    return 0;
}
```

실행 결과

```output
(friend 클래스 템플릿 호출) 템플릿 매개변수 값: 5
(friend 클래스 템플릿 호출) 템플릿 매개변수 값: 클래스 템플릿 기본값이 아닌 string형
```
{: .nolineno }

프렌드 함수를 클래스 내부에 정의했을 때와 다른 점은 템플릿 매개변수를 한 번 더 선언한 것이다. 전역 범위에서 함수를 정의할 때는 data_package 클래스에서 선언한 템플릿 매개변수를 사용할 수 없으므로 printout_friend_element 함수에서 사용할 템플릿 매개변수를 별도로 선언해야 한다.

main 함수에서는 template_inst1 객체를 생성할 때 다양한 자료형을 처리할 수 있도록 data_package<> 처럼 전체 형식으로 지정했다. 만약 printout_friend_element 함수가 data_package형 객체만 처리하도록 만들려면 다음처럼 작성한다. 한 가지 주의할 점은 data_package 클래스를 선언할 때 사용한 템플릿 매개변수 T가 아닌, 새로 선언한 템플릿 매개변수 C를 사용해야 한다.

```cpp
template <typename C>
void printout_friend_element(data_package<C> &data_obj)
```
