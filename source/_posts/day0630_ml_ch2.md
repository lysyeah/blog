---
title: "0630_ml_ch2"
date: '2022-06-30 17:30:00'
---




## 파이썬 주요 라이브러리
  """
- Machine learning
  + 정형 데이터
  + 싸이킷런 (scijit-learn)
- Deep learning
  + 비정형 데이터
  + Tensorflow(구글), Pytorch(페이스북)
  + 혼공머: Tensorflow
  + 실제 상용 서비스 -
Tensorflow vs R&D - Pytorch
   """

## 생선 분류
- 도미, 곤들매기, 농어, 등등
- 이 생선들을 프로그램으로 분류하려고한다.
- 30cm 이상은 도미라고 알려줘



```python
fish_length = 909090
if fish_length >= 30:
  print("도미")
else :
  print("몰라종")
```

    도미
    

## 데이터 수집


```python
# 도미의 길이
bream_length = [25.4, 26.3, 26.5, 29.0, 29.0, 29.7, 29.7, 30.0, 30.0, 30.7, 31.0, 31.0, 31.5, 32.0, 32.0, 32.0, 33.0, 33.0, 33.5, 33.5, 34.0, 34.0, 34.5, 35.0, 35.0, 35.0, 35.0, 36.0, 36.0, 37.0, 38.5, 38.5, 39.5, 41.0, 41.0]

# 도미의 무게
bream_weight = [242.0, 290.0, 340.0, 363.0, 430.0, 450.0, 500.0, 390.0, 450.0, 500.0, 475.0, 500.0, 500.0, 340.0, 600.0, 600.0, 700.0, 700.0, 610.0, 650.0, 575.0, 685.0, 620.0, 680.0, 700.0, 725.0, 720.0, 714.0, 850.0, 1000.0, 920.0, 955.0, 925.0, 975.0, 950.0]
```

## 데이터 가공
- 여기서는 생략

## 데이터 시각화
- 여러 인사이트 확인을 위해 시각화, 통계 수치 계산
- 탐색적 자료 분석(EDA : Exploratory Data Analysis)
- 이거는 참고만하기.


```python
import matplotlib.pyplot as plt

plt.scatter(bream_length, bream_weight)
plt.xlabel('length')
plt.ylabel('weight')
plt.show()  ## 이 방법 쓰지말기. 안좋대.
```


```python
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
ax.scatter(bream_length, bream_weight)
ax.set_xlabel('length')
ax.set_ylabel('weight')
plt.show() # 이처럼 많이쓰니까 이렇게 쓰기. 외우기.암기.
```

- 빙어 데이터 준비하기


```python
smelt_length = [9.8, 10.5, 10.6, 11.0, 11.2, 11.3, 11.8, 11.8, 12.0, 12.2, 12.4, 13.0, 14.3, 15.0]
smelt_weight = [6.7, 7.5, 7.0, 9.7, 9.8, 8.7, 10.0, 9.9, 9.8, 12.2, 13.4, 12.2, 19.7, 19.9]

plt.scatter(bream_length, bream_weight)
plt.scatter(smelt_length, smelt_weight)
plt.xlabel('length')
plt.ylabel('weight')
plt.show()
```

- 두개의 리스트 합치기


```python
length  = bream_length + smelt_length
weight = bream_weight + smelt_weight
```

- 2차원 리스트로 만든다.


```python
fish_data = [[l,w]for l, w in zip(length,weight)]

print(fish_data)

## [l,m]에서  m을 w로 해놔서 계속 오류가 났었네..
```

- 라벨링 해준다 = 지도해준다
= 지도 학습 


```python
fish_target = [1] * 35 + [0] *14
print(fish_target)
```

## 모델


```python
from sklearn.neighbors import KNeighborsClassifier

# 클래스 인스턴스화
kn = KNeighborsClassifier()

# 모형 학습
      # =독립변수,  =종속변수
kn.fit(fish_data, fish_target)
```


```python
# 예측 정확도 (재검사)
kn.score(fish_data, fish_target)
```

- 실제 예측을 해보자
- 새로운 물고기 도착했습니다.
  + 길이 : 30, 몸무게 : 60 


```python
ac_length = int(input("물고기 길이를 입력하세요..."))
ac_weight = int(input("물고기 무게를 입력하세요..."))

preds = int(kn.predict([[ac_length, ac_weight]]))
print(preds)

if preds == 1:
  print("도미")

else:
  print("빙어")
```

    물고기 무게를 입력하세요...10
    0
    빙어
    


```python
'''
 blog 파일에 넣는 행동 = 백업해두기 위해서(파일 그대로)
 왜냐하면 lysyeah.github.io 에
 저장할 때 html 확장자로 저장되기 때문에 
 수정할 때 불편하다.

 구글 코랩에서 .ipynb 다운로드 후---> anaconda 
--> open the file(= .ipynb)
--> convert to MD (Mark Down) = saving.md
--> sourcetree로 add, commit, push 하기.
--> blog 파일을 우클릭 해서 파이참으로 켠다
--> hexo 해서 실제 블로그에 올려야하는데 잘 모르겠다.
''' 
```




    '\n blog 파일에 넣는 행동 = 백업해두기 위해서(파일 그대로)\n 왜냐하면 lysyeah.github.io 에\n 저장할 때 html 확장자로 저장되기 때문에 \n 수정할 때 불편하다.\n\n 구글 코랩에서 .ipynb 다운로드 후---> anaconda \n--> open the file(= .ipynb)\n--> convert to MD (Mark Down) = saving.md\n--> sourcetree로 add, commit, push 하기.\n--> blog 파일을 우클릭 해서 파이참으로 켠다\n--> hexo 해서 실제 블로그에 올려야하는데 잘 모르겠다.\n'



- 분석의흐름
- 데이터수집
- 데이터 가공
- 데이터 시각화
- 데이터 (예측_ 모델링)
- 예측 평가지표
** 알고리즘 공부 ** 중요하긴한데 무궁무진...ㅜㅠ
- R : 데이터(통계) 모델링
- 변수(=컬럼=피처)간의 관계
 가설 검정이 중요하다.
- 공통점 : 해석 !!!
- 보고서를 작성 (상사, 갑, 의사결정자)
- 현재의 나 : 면접 자료
- 면접 자료 : 소스코드 & 파워포인트


```python
## 새로운 모델 제안
```

- 하이퍼 파라미터 세팅
 + n_neighbors = 49
- default : 100%


## 머신 러닝 알고리즘의 두가지 큰 흐름
- 선형 모델 : 선형회귀, 로지스틱 회귀, 서포트 벡터 머신
- 의사결정트리 모델 : 1975년 의사결정트리 모델, KNN,
  + 랜덤포레스트
  + 부스팅계열 : LightGBM(2017), XHboost(2016)
- 선형 회귀, 로지스틱회귀, 랜덤포레스트, --LightGBM(=XGBoost)--


```python
kn49 = KNeighborsClassifier(n_neighbors=49)
kn49.fit(fish_data,fish_target)
kn49.score(fish_data, fish_target)

# = 정확도 = 71퍼센트
```




    0.7142857142857143




```python
fish_length = [25.4, 26.3, 26.5, 29.0, 29.0, 29.7, 29.7, 30.0, 30.0, 30.7, 31.0, 31.0, 
                31.5, 32.0, 32.0, 32.0, 33.0, 33.0, 33.5, 33.5, 34.0, 34.0, 34.5, 35.0, 
                35.0, 35.0, 35.0, 36.0, 36.0, 37.0, 38.5, 38.5, 39.5, 41.0, 41.0, 9.8, 
                10.5, 10.6, 11.0, 11.2, 11.3, 11.8, 11.8, 12.0, 12.2, 12.4, 13.0, 14.3, 15.0]
fish_weight = [242.0, 290.0, 340.0, 363.0, 430.0, 450.0, 500.0, 390.0, 450.0, 500.0, 475.0, 500.0, 
                500.0, 340.0, 600.0, 600.0, 700.0, 700.0, 610.0, 650.0, 575.0, 685.0, 620.0, 680.0, 
                700.0, 725.0, 720.0, 714.0, 850.0, 1000.0, 920.0, 955.0, 925.0, 975.0, 950.0, 6.7, 
                7.5, 7.0, 9.7, 9.8, 8.7, 10.0, 9.9, 9.8, 12.2, 13.4, 12.2, 19.7, 19.9]
```

- 2차원 파이선 리스트 작성후
- 라벨링하기.


```python
fish_data = [[l, w] for l, w in zip(fish_length, fish_weight)]
fish_target = [1] * 35 + [0] * 14
print(fish_target[0:40:5])
print(fish_data[0:40:5])
```

    [1, 1, 1, 1, 1, 1, 1, 0]
    [[25.4, 242.0], [29.7, 450.0], [31.0, 475.0], [32.0, 600.0], [34.0, 575.0], [35.0, 725.0], [38.5, 920.0], [9.8, 6.7]]
    

- Sample
- 도미 35마리, 빙어 14마리
- 49개의 샘플 존재
- 처음 35개를 훈련 / 나머지 14를 테스트


```python
from sklearn.neighbors import KNeighborsClassifier

# 클래스 인스턴스화
kn = KNeighborsClassifier()

# 훈련 세트로 0:34 인덱스 활용
train_input = fish_data[:35]
train_target = fish_target[:35]

# 테스트 세트로 35:0 인덱스 활용
test_input = fish_data[35:]
test_target = fish_target[35:]

#모형학습
kn = kn.fit(train_input, train_target)
print(kn.score(test_input, test_target))
```

    0.0
    

- 샘플링 편향
- 훈련세트와 테스트 세트가 골고루 섞이지 않음


## 샘플링 작


```python
import numpy as np

input_arr = np.array(fish_data)
target_arr = np.array(fish_target)
print(input_arr[0:49:7])
print(input_arr.shape, target_arr.shape)
```

    [[ 25.4 242. ]
     [ 30.  390. ]
     [ 32.  600. ]
     [ 34.  685. ]
     [ 36.  850. ]
     [  9.8   6.7]
     [ 11.8   9.9]]
    (49, 2) (49,)
    


```python
# random으로 배열을 만들거나 저장
np. random.seed(42)
index = np.arange(49)
np.random.shuffle(index)
print(index)
```

    [13 45 47 44 17 27 26 25 31 19 12  4 34  8  3  6 40 41 46 15  9 16 24 33
     30  0 43 32  5 29 11 36  1 21  2 37 35 23 39 10 22 18 48 20  7 42 14 28
     38]
    

- 77p 


```python
train_input = input_arr[index[:35]]
train_target = target_arr[index[:35]]

test_input = input_arr[index[35:]]
test_target = target_arr[index[35:]]

print(input_arr[13], train_input[0])
```

    [ 32. 340.] [ 32. 340.]
    

## 시각화


```python
train_input[:,0]
```




    array([32. , 12.4, 14.3, 12.2, 33. , 36. , 35. , 35. , 38.5, 33.5, 31.5,
           29. , 41. , 30. , 29. , 29.7, 11.3, 11.8, 13. , 32. , 30.7, 33. ,
           35. , 41. , 38.5, 25.4, 12. , 39.5, 29.7, 37. , 31. , 10.5, 26.3,
           34. , 26.5])




```python
import matplotlib.pyplot as plt  
fig, ax = plt.subplots()
ax.scatter(train_input[:, 0], train_input[:, 1])
ax.scatter(test_input[:, 0], test_input[:, 1])
ax.set_xlabel("length")
ax.set_ylabel("weight")
plt.show()
```


    
![png](output_41_0.png)
    


##두 번째 머신러닝 프로그램


```python
kn.fit(train_input, train_target)
kn.score(test_input, test_target)
```




    1.0




```python
kn.predict(test_input) # 예측 데이터
```




    array([0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0])




```python
test_target # 실제 데이터
```




    array([0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0])



## 데이터 전처리
- 머신러닝 시 , 데이터 전처리
- 결측치 처리, 이상치 처


```python
fish_length = [25.4, 26.3, 26.5, 29.0, 29.0, 29.7, 29.7, 30.0, 30.0, 30.7, 31.0, 31.0, 
                31.5, 32.0, 32.0, 32.0, 33.0, 33.0, 33.5, 33.5, 34.0, 34.0, 34.5, 35.0, 
                35.0, 35.0, 35.0, 36.0, 36.0, 37.0, 38.5, 38.5, 39.5, 41.0, 41.0, 9.8, 
                10.5, 10.6, 11.0, 11.2, 11.3, 11.8, 11.8, 12.0, 12.2, 12.4, 13.0, 14.3, 15.0]
fish_weight = [242.0, 290.0, 340.0, 363.0, 430.0, 450.0, 500.0, 390.0, 450.0, 500.0, 475.0, 500.0, 
                500.0, 340.0, 600.0, 600.0, 700.0, 700.0, 610.0, 650.0, 575.0, 685.0, 620.0, 680.0, 
                700.0, 725.0, 720.0, 714.0, 850.0, 1000.0, 920.0, 955.0, 925.0, 975.0, 950.0, 6.7, 
                7.5, 7.0, 9.7, 9.8, 8.7, 10.0, 9.9, 9.8, 12.2, 13.4, 12.2, 19.7, 19.9]
```


```python
# column_stack 활용
np.column_stack(([1,2,3],[4,5,6]))

```




    array([[1, 4],
           [2, 5],
           [3, 6]])




```python
fish_data = np.column_stack((fish_length, fish_weight))
print(fish_data[ : 5])
```

    [[ 25.4 242. ]
     [ 26.3 290. ]
     [ 26.5 340. ]
     [ 29.  363. ]
     [ 29.  430. ]]
    

- 종속변수 = y = 타깃 데이터 = target



```python
fish_target = np.concatenate((np.ones(35),np.zeros(14)))
print(fish_target)
```

    [1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1.
     1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0.
     0.]
    

#Python 데이터과학
NumPy 기본
- Pandas 데이터 가공 (=dplyr)
- Scipy 과학, 수학, 통계
- statsmodels 통계
- sklearn 머신러닝
- tensorflow, pytorch

### scikit-learn 훈련세트와 테스트 세트 나누기


```python
from sklearn.model_selection import train_test_split
train_input, test_input, train_target, test_target = train_test_split(
    # 독립변수, 종속변수
     fish_data, fish_target, random_state = 42
)

train_input.shape, test_input.shape, train_target.shape, train_target.shape

# 여기 있는 것들 수시로 쳐서 익숙해지기.
# 42는 관용적으로 쓰는 수치. 딱히 의미는 없음..

```




    ((36, 2), (13, 2), (36,), (36,))



- p92 도미와 빙어가 잘 섞여있니?


```python
print(test_target)
```

    [1. 0. 0. 0. 1. 1. 1. 1. 1. 1. 1. 1. 1.]
    

- 35(도미) : 14(빙어)
 + 2.5 : 14
- 테스트 셋 (비율)
 + 3.3 : 14

## 층화 샘플링
- 기초 통계, 설문조사
- 비율
- 여론조사
 + 남성 속옷을 구매하는 비율 (남자 : 여자 = 9 : 1)
 + 신제품 ( 남자5, 여자5)


```python

train_input, test_input, train_target, test_target = train_test_split(
    # 독립변수, 종속변수
     fish_data, fish_target, stratidy=fish_target, random_state = 42
)

train_input.shape, test_input.shape, train_target.shape, train_target.shape

```


```python
print(test_target)
```

    [1. 0. 0. 0. 1. 1. 1. 1. 1. 1. 1. 1. 1.]
    

- 테스트 세트의 비율이 2.25:1

## 수상한 도미 한 마리



```python
from sklearn.neighbors import KNeighborsClassifier
kn = KNeighborsClassifier()
kn.fit(train_input, train_target)
kn.score(test_input, test_target)
```




    1.0




```python
print(kn.predict([[25,150]]))
```

    [0.]
    


```python
import matplotlib.pyplot as plt
distances, indexes = kn.kneighbors([[25, 150]])
fig, ax = plt.subplots()
ax. scatter(train_input[:,0], train_input[:,1])
ax.scatter(25,150,marker='^')
plt.xlabel('length')
plt.ylabel('weight')
plt.show()

```


    
![png](output_65_0.png)
    



```python
plt.scatter(train_input[:,0], train_input[:,1])
plt.scatter(25, 150, marker='^')
plt.scatter(train_input[indexes,0], train_input[indexes,1], marker='D')
plt.xlim((0, 1000))
plt.xlabel('length')
plt.ylabel('weight')
plt.show()
```


    
![png](output_66_0.png)
    


## p.98 
- 두 특성(길이, 무게) 의 값이 놓인 범위가 매우 다르다.
- 두 특성의 스케일이 다름.
 + 스케일이 같도록 통계 처리가 필요.
 + feature exngineer 
- 머신러닝
 + 전체 데이터 전처리 ( 결측치처리, 이상치 처리)
 + 데이터 분리
 + 피처링 엔지니어링

## 표준점


```python
mean= np.mean(train_input, axis=0)
std = np.std(train_input, axis=0)

print(mean,std)
```

    [ 26.175      418.08888889] [ 10.21073441 321.67847023]
    



- 표준 점수 구하기


```python
# 브로드 캐스팅 : 서로 다른 배열을 계산할 때


train_scaled = (train_input - mean ) / std 
print( train_input.shape, mean.shape,  std.shape )
```

    (36, 2) (2,) (2,)
    


```python
plt.scatter(train_scaled[:,0], train_scaled[:,1])
plt.scatter(25, 150, marker='^')
plt.xlabel('length')
plt.ylabel('weight')
plt.show()
```


    
![png](output_73_0.png)
    



```python
new = ([25, 150] - mean) / std
plt.scatter(train_scaled[:,0], train_scaled[:,1])
plt.scatter(new[0], new[1], marker='^')
plt.xlabel('length')
plt.ylabel('weight')
plt.show()
```


    
![png](output_74_0.png)
    


통계처리 전 : KNN --> 예측이 틀림
통계처리 후 : KNN --> 맞음
-- 통계처리 --> Feature Engineering

- 모형학습 


```python
kn.fit(train_scaled, train_target)
```




    KNeighborsClassifier()




```python
#kn.score(test_input, test_taeget)
test_scaled = (test_input - mean ) / std
kn.score(test_scaled, test_target)
```




    1.0



- 예측 


```python
print(kn.predict([new]))
```

    [1.]
    


```python
distances, indexes = kn.kneighbors([new])
plt.scatter(train_scaled[:,0], train_scaled[:,1])
plt.scatter(new[0], new[1], marker='^')
plt.scatter(train_scaled[indexes,0], train_scaled[indexes,1], marker='D')
plt.xlabel('length')
plt.ylabel('weight')
plt.show()
```


    
![png](output_81_0.png)
    

