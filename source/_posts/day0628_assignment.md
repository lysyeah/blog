##29.1 Hello,world 출력 함수 만들기


```python
def hello(): 
  """ 파이썬 코드는
위에서 아래로 순차적으로 실행되기 때문에
함수를 먼저 정의하고 난 뒤에
함수를 호출 해야한다.
"""
  print('hello,world')
hello()

## 독스트링 위치 잘 보자.
## 콜론 다음에 적으니까 결과값에 글이 적히지 않는다.
## 가장 밑에 적으니 결과값에 나와서 보기 불편하다.
## '''보다 """를 권장한다고 한다.
```

    hello,world
    

## 29.2 덧셈 함수 만들기


```python
def add(a,b):
  print( a + b )

add( 3, 4 )

```

    7
    

29.3 함수의 결과를 반환하기


```python
def add(a,b):"""

  return a+b

x = add(10,20)
x
```




    30




```python
def not_ten(a):
 """ not_ten 함수에 5를 넣으면  
5가 출력된다.
하지만 10을 넣으면 if가 만족되므로
return이 되는것이고
출력이 되지 않는다.
즉, 밑 함수로 내려가지않는다.
"""
  
  if a == 10:
    return
  print(a, '입니다', sep='')

not_ten(5)
not_ten(10)

##물결 밑줄 왜 생겼을까??
```

    5입니다
    

##29.4 함수에서 값을 여러 개 반환하기


```python
def add_sub(a,b):
  """아직 이해가 잘 되지 않는다. 
  계속 쓰다보면 익숙해지겠지
  """
  return a+b, a-b

x, y = add_sub(10,20)
print(x)

print(y)
```

    30
    -10
    

- 참고 : 값 여러 개를 직접 반환하


```python
def one_two():
  return[1,2]

x, y = one_two()
print(x,y)
 
```

    1 2
    

##29.5 함수의 호출 과정 알아보기


```python
def multi(a,b): 
  """a쌓고 b쌓고 c쌓는건 알겠는데
c를 꺼내고 b를 꺼내고 a를 꺼내는게 왜이런지
이해되지가 않는다.
"""
  c = a*b
  return

def add(a,b):
  c = a + b
  print(c)
  d = mul(a,b)
  print(d)

x = 10
y = 20
add(x,y)
```

#29.3 연습문제 : 몫과 나머지를 구하는 함수 만들


```python
def divide(a,b):
   """ 슬래시 한번하면 값 그대로 나오고
 슬래시 두번하면 몫만 나오면
% 나머지값이 나온다
"""
  return a/b, a//b, a%b

divide(10,3)
```


      File "<ipython-input-53-b3eb5ddc7290>", line 6
        return a/b, a//b, a%b
                             ^
    IndentationError: unindent does not match any outer indentation level
    


## 30.1 위치 인수와 리스트 언패킹 사용하기



```python
print(10,20,30)

```

    10 20 30
    

- 30.1.1 위치 인수를 사용하는 함수를 만들고 호출하기


```python
def print_numbers(a,b,c):
  
  print(a)
  print(b)
  print(c)

print_numbers(10,20,30)
```

    10
    20
    30
    

- 30.1.2 언패킹 사용하기


```python
x = [10,20,30]
print_numbers(*x)

## *x를 하면 리스트의 포장을 푼다는 함수가 된다 (=unpacking)
## print(numbers(*x)) = print_numbers(10,20,30)라는 말이다.
```

    10
    20
    30
    


```python
print_numbers(*[10,20,30]) 
# 이렇게도 된다.
# 단, 이때 함수의 매개변수 개수와 리스트의 요소 개수는 같아야 한다.
```

    10
    20
    30
    


```python
print_numbers(*[10,20]) 
# 단, 이때 함수의 매개변수 개수와 리스트의 요소 개수는 같아야한다.
```


    ---------------------------------------------------------------------------

    TypeError                                 Traceback (most recent call last)

    <ipython-input-67-c2b892dd2c14> in <module>()
    ----> 1 print_numbers(*[10,20])
    

    TypeError: print_numbers() missing 1 required positional argument: 'c'


- 30.1.3 가변 인수 함수 만들


```python
def print_numbers(*args): #ars = arguments = 매개변수
  for arg in args:
    print(arg)


print_numbers(1,2)

print_numbers(10,20,30,40)
```

    1
    2
    10
    20
    30
    40
    


```python
x = [10]
print_numbers(*x)

y = [10,20,30,40]
print_numbers(*y)
```

    10
    10
    20
    30
    40
    

- 참고 : 고정 인수와 가변 인수를 함께 사용하기


```python
def print_numbers(a,*args):
  print(a)
  print(args)

print_numbers(1)
print_numbers(1,10,20)
print_numbers(*[10,20,30])
```

    1
    ()
    1
    (10, 20)
    10
    (20, 30)
    

## 30.2 키워드 인수 사용하기


```python
def personal_info(name, age, address):
  print('이름: ', name)
  print('나이:', age)
  print('주소:', address)

personal_info('홍길동', 30, '서울시 용산구 이촌동')
#인수의 순서과 용도를 모두기억해야 해서 불편하다. 다음과 같이 해보자
```

    이름:  홍길동
    나이: 30
    주소: 서울시 용산구 이촌동
    


```python
personal_info(name="홍길동", age=30, address='서울시 용산구 이촌동')
```

    이름:  홍길동
    나이: 30
    주소: 서울시 용산구 이촌동
    


```python
personal_info(name="홍길동", address='서울시 용산구 이촌동', age=30)
# 순서가 달라도 그래도 출력되네. 굳.
```

    이름:  홍길동
    나이: 30
    주소: 서울시 용산구 이촌동
    

# 30.3 키워드 인수와 딕셔너리 언패킹 사용하기


```python
def personal_info(name,age,address):
  print('이름:', name)
  print('나이:', age)
  print('주소:', address)
  x = {'name': '홍길동', 'age':30, 'address':'서울시 용산구 이촌동'}
  personal_info(**x)
  # 왜 출력안됨 ???? 
```


```python
# personal_info(**{'name': '홍길동', 'age': 30, 'address': '서울시 용산구 이촌동'})
# 이거 하니까 행 겁나 많이 나옴....
```

- 30.3.1 **처럼 두번하는 이


```python
# 딕셔너리는 **처럼 *를 두 번 사용할까요? 
# 왜냐하면 딕셔너리는 키-값 쌍 형태로 값이 저장되어 있기 때문입니다.
x = {'name': '홍길동', 'age':30, 'address':'서울시 용산구 이촌동'}
personal_info(*x)
## 이것도 행 엄청 나다.
```


```python
#x = {'name': '홍길동', 'age': 30, 'address': '서울시 용산구 이촌동'}
#>>> personal_info(*x)
#이름:  name
#나이:  age
#주소:  address
```


```python
#>>> x = {'name': '홍길동', 'age': 30, 'address': '서울시 용산구 이촌동'}
#>>> personal_info(**x)
#이름:  홍길동
#나이:  30
#주소:  서울시 용산구 이촌동
```

- 30.3.2 키워드 인수를 사용하는 가변 인수 함수 만들기


```python
def personal_info(**kwargs): #keyword arguments
  for kw, arg in kwargs.item():
    print(kw,':',arg, sep='')


peronsal_info(name='홍길동')
personal_info(name='홍길동', age=30, address='서울시 용산구 이촌동')
```


    ---------------------------------------------------------------------------

    NameError                                 Traceback (most recent call last)

    <ipython-input-106-2abc425a519f> in <module>()
          4 
          5 
    ----> 6 peronsal_info(name='홍길동')
          7 personal_info(name='홍길동', age=30, address='서울시 용산구 이촌동')
    

    NameError: name 'peronsal_info' is not defined



```python
x = {'name': 홍길동}
personal_info(**x)
name: 홍길동
y = {'name': '홍길동', 'age'=30, 'address': '서울시 용산구 이촌동'}
personal_info(**y)
```


      File "<ipython-input-109-69cbf1af3b78>", line 4
        y = {'name': '홍길동', 'age'=30, 'address': '서울시 용산구 이촌동'}
                                 ^
    SyntaxError: invalid syntax
    



```python
def personal_info(**kwargs):
    if 'name' in kwargs:    # in 으로 딕셔너리 안에 특정 키가 있는지 확인
        print('이름: ', kwargs['name'])
    if 'age' in kwargs:
        print('나이: ', kwargs['age'])
    if 'address' in kwargs:
        print('주소: ', kwargs['address'])
```

- 참고 : 고정 인수와 가변 인수(키워드 인수)를 함께 사용하기
 + 고정 인수와 가변 인수를 사용할 때는 다음과 같이 고정 매개 변수를 먼저 지정하고, 그 다음 매개변수에 **를 붙여주면 됩니다.


```python
def personal_info(name, **kwargs):
  print(name)
  print(kwargs)

persnal_info('홍길동')
personal_info('홍길동', age=30, address='서울시 용산구 이촌동')
personal_info(**{'name': '홍길동', 'age': 30, 'address': '서울시 용산구 이촌동'})
```


    ---------------------------------------------------------------------------

    NameError                                 Traceback (most recent call last)

    <ipython-input-112-8aa719c056a6> in <module>()
          3   print(kwargs)
          4 
    ----> 5 persnal_info('홍길동')
          6 personal_info('홍길동', age=30, address='서울시 용산구 이촌동')
          7 personal_info(**{'name': '홍길동', 'age': 30, 'address': '서울시 용산구 이촌동'})
    

    NameError: name 'persnal_info' is not defined


- 참고 : 위치 인수와 키워드 인수를 함께 사용하기


```python
def custom_print(*args, **kwargs):
  print(*args, **kwargs)

custom_print(1,2,3,sep=':', end='')
```

    1:2:3

#30.4 매개변수에 초깃값 지정하기


```python
def personal_info(name, age, affreess='비공개'):
  print('이름:',name)
  print('나이:',age)
  print('주소:',address)

personal_info('홍길동', 30)
```

    이름: 홍길동
    나이: 30
    


    ---------------------------------------------------------------------------

    NameError                                 Traceback (most recent call last)

    <ipython-input-117-3309fa8c57ec> in <module>()
          4   print('주소:',address)
          5 
    ----> 6 personal_info('홍길동', 30)
    

    <ipython-input-117-3309fa8c57ec> in personal_info(name, age, affreess)
          2   print('이름:',name)
          3   print('나이:',age)
    ----> 4   print('주소:',address)
          5 
          6 personal_info('홍길동', 30)
    

    NameError: name 'address' is not defined

