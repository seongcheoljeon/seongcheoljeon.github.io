# 다중 재귀 호출 (aka. Divide and Conquer)

재귀 호출은 하나의 작업을 서로 비슷한 두 개의 작은 작업으로 반복적으로 분할해가면서 처리해야 하는 상황에서 특별히 유용하다. 예를 들면, 눈금자를 그리는 데 이것을 적용할 수 있다. 두 개의 끝을 먼저 표시한 후 그들의 중간 지점을 찾아 눈금을 표시한다. 동일한 절차를 눈금자의 왼쪽 절반에 대해 수행한다. 그리고 나서 눈금자의 오른쪽 절반에 대해서도 같은 절차를 수행한다. 눈금 간격을 더욱 세분하려면 현재의 눈금 구획에 대해 동일한 절채를 다시 수행한다. 이러한 재귀적인 접근을 __"분할 정복(divide-and-conquer)"__ 전략이라고 한다.


```c++ linenums="1"
#include <iostream>

using namespace std;

const int LEN = 66;
const int DIVS = 6;

void subdivide(char ar[], int low, int high, int level);


int main() {
    char ruler[LEN];

    for (int i = 1; i < LEN - 2; i++) {
        ruler[i] = ' ';
    }
    ruler[LEN - 1] = '\0';

    int max = LEN - 2;
    int min = 0;

    ruler[min] = ruler[max] = '|';

    cout << ruler << endl;

    for (int i = 1; i <= DIVS; i++) {
        subdivide(ruler, min, max, i);
        cout << ruler << endl;
        for (int j = 1; j < LEN - 2; j++) {
            ruler[j] = ' ';
        }
    }

    return 0;
}


void subdivide(char ar[], int low, int high, int level) {
    if (level == 0)
        return;

    int mid = (high + low) / 2;
    ar[mid] = '|';
    subdivide(ar, low, mid, level - 1);
    subdivide(ar, mid, high, level - 1);
}

/*
결과
|                                                               |
|                               |                               |
|               |               |               |               |
|       |       |       |       |       |       |       |       |
|   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
```

subdivide() 함수는 재귀 호출의 단계를 제어하기 위해 level이라는 변수를 사용한다. 함수가 자기 자신을 호출할 때마다 level은 1씩 감소한다. level이 0인 함수는 종료된다. subdivide() 함수는 자신을 두 번 호출한다. 한 번은 왼쪽 구획을 나누기 위해서이고, 다른 한 번은 오른쪽 구획을 나누기 위해서이다. 최초의 중간 지점은 왼쪽 구획을 나누기 위한 호출에서 오른쪽 끝이 되고, 오른쪽 구획을 나누기 위한 호출에서는 왼쪽 끝이 된다. 재귀 호출의 수는 기하급수적으로 증가한다. 

즉, 한 번의 호출은 두 번의 호출을 발생시키고, 두 번의 호출은 네 번의 호출을, 네 번의 호출은 여덞 번의 호출을 발생시킨다. 이런 식으로 계속 진행하면 6단계의 호출은 눈금자를 64개의 칸으로 채우게 된다(2^6 = 64). 

함수 호출의 수가 계속해서 2배씩 증가하기 때문에, 재귀 호출의 단계가 많이 요구되는 경우에 이와 같은 형식의 재귀는 잘못된 선택이다. 그러나 필요한 재귀 호출의 단계가 적을 경우에 이것은 우아하고 간단한 선택이다.