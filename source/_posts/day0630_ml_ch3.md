---
title: day0630_ml_ch3
date: 2022-06-30 12:43:07
tags:
---



## K- 최근접 이웃 회귀
- 지도 학습 알고리즘은 크게 분류와 회귀
- 지도 학습 : 종속변수 존재
 + 분류 : 도미와 빙어 분류 문제를 해결
 + 회귀 : 통계에서 들었던.. y = ax + b --> 수치 예측
 

## 데이터 불러오기 


```python
import numpy as np
print(np.__version__)
```

    1.21.6
    


```python
perch_length = np.array(
    [8.4, 13.7, 15.0, 16.2, 17.4, 18.0, 18.7, 19.0, 19.6, 20.0, 
     21.0, 21.0, 21.0, 21.3, 22.0, 22.0, 22.0, 22.0, 22.0, 22.5, 
     22.5, 22.7, 23.0, 23.5, 24.0, 24.0, 24.6, 25.0, 25.6, 26.5, 
     27.3, 27.5, 27.5, 27.5, 28.0, 28.7, 30.0, 32.8, 34.5, 35.0, 
     36.5, 36.0, 37.0, 37.0, 39.0, 39.0, 39.0, 40.0, 40.0, 40.0, 
     40.0, 42.0, 43.0, 43.0, 43.5, 44.0]
     )
perch_weight = np.array(
    [5.9, 32.0, 40.0, 51.5, 70.0, 100.0, 78.0, 80.0, 85.0, 85.0, 
     110.0, 115.0, 125.0, 130.0, 120.0, 120.0, 130.0, 135.0, 110.0, 
     130.0, 150.0, 145.0, 150.0, 170.0, 225.0, 145.0, 188.0, 180.0, 
     197.0, 218.0, 300.0, 260.0, 265.0, 250.0, 250.0, 300.0, 320.0, 
     514.0, 556.0, 840.0, 685.0, 700.0, 700.0, 690.0, 900.0, 650.0, 
     820.0, 850.0, 900.0, 1015.0, 820.0, 1100.0, 1000.0, 1100.0, 
     1000.0, 1000.0]
     )
```


```python
import matplotlib.pyplot as plt

fig, ax = plt.subplots() #객체지향
plt.scatter(perch_length, perch_weight)
plt.xlabel('length')
plt.ylabel('weight')
plt.show()
```


    
![png](output_4_0.png)
    



```python
from sklearn.model_selection import train_test_split
train_input, test_input, train_target,test_target= train_test_split(perch_length, perch_weight, random_state=42)

train_input.shape, test_input.shape, train_target.shape, test_target.shape
print(train_input.ndim)
```

    1
    

- 1차원 배열 --> 2차원 배열


```python
train_input = train_input.reshape(-1,1)
test_input = test_input.reshape(-1,1)
print(train_input.shape, test_input.shape)
print(train_input.ndim)
```

    (42, 1) (14, 1)
    2
    

## 결정 계수
- 정확하다
- 0~1 사이의 지표
- 1로 수렴할수록 예측 모형에 잘 맞다.


```python
from sklearn.neighbors import KNeighborsRegressor

knr = KNeighborsRegressor()

# 모형 학습
knr.fit(train_input, train_target) 

# 테스트 세트의 점수를 확인한다. 
print(knr.score(test_input, test_target))
```

    0.992809406101064
    


```python
from sklearn.metrics import mean_absolute_error

# 테스트 세트에 대한 예측을 만든다.
test_prediction = knr.predict(test_input)

#테스트 세트에 대한 평균 절댓값 오차를 계산한다.
mae = mean_absolute_error(test_target, test_prediction)

print(mae)
```

    19.157142857142862
    

- 예측이 평균적으로 19g 정도 다르다.
 + 확실한 건 오차가 존재한다.
 + 19g 정도가 의미하는게 뭐지?
 + 개선 : 17g
 + 개선
 + ... 계속해서 오차를 줄인다.


```python
print(knr.score(train_input, train_target))
```

    0.9698823289099254
    

# 과대적합 vs 과소적합
- 매우 힘듦. 도망 가자... 우리...by. 선우정아
- 과대적합 : 훈련세트 점수 좋음, 테스트 점수 매우 운 좋음
- 과소적합 : 테스트 세트의 점수가 매우 좋음
- 결론 : 제대로 모형이 훈련되지 않은 것이다.
 + 모형을 서비스에 합칠 수 없음.


```python
print("훈련평가:", knr.score(train_input, train_target))
print("테스트 평가:", knr.score(train_input, train_target))
```

    훈련평가: 0.9698823289099254
    테스트 평가: 0.9698823289099254
    


```python
# 이웃의 개수를 3으로 재지정 
knr.n_neighbors = 3
knr.fit(train_input, train_target)
print("훈련 평가:", knr.score(train_input, train_target))
print("테스트 평가:", knr.score(test_input, test_target))

```

    훈련 평가: 0.9804899950518966
    테스트 평가: 0.9746459963987609
    
