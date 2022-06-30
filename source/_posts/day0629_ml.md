## 파이썬 주요 라이브러리
  """- Machine learning
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
-30cm 도미라고 알려줘



```python
fish_length = 31
if fish_length >= 30:
  print("도미")
  
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
plt.show()  ## 이 방법 쓰지말기.


```


    
![png](output_7_0.png)
    



```python
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
ax.scatter(bream_length, bream_weight)
ax.set_xlabel('length')
ax.set_ylabel('length')
plt.show() #이처럼 많이쓰니까 이렇게 쓰기. 외우기.암기.

```


    
![png](output_8_0.png)
    


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


    
![png](output_10_0.png)
    


- 두개의 리스트 합치


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

    [[25.4, 242.0], [26.3, 290.0], [26.5, 340.0], [29.0, 363.0], [29.0, 430.0], [29.7, 450.0], [29.7, 500.0], [30.0, 390.0], [30.0, 450.0], [30.7, 500.0], [31.0, 475.0], [31.0, 500.0], [31.5, 500.0], [32.0, 340.0], [32.0, 600.0], [32.0, 600.0], [33.0, 700.0], [33.0, 700.0], [33.5, 610.0], [33.5, 650.0], [34.0, 575.0], [34.0, 685.0], [34.5, 620.0], [35.0, 680.0], [35.0, 700.0], [35.0, 725.0], [35.0, 720.0], [36.0, 714.0], [36.0, 850.0], [37.0, 1000.0], [38.5, 920.0], [38.5, 955.0], [39.5, 925.0], [41.0, 975.0], [41.0, 950.0], [9.8, 6.7], [10.5, 7.5], [10.6, 7.0], [11.0, 9.7], [11.2, 9.8], [11.3, 8.7], [11.8, 10.0], [11.8, 9.9], [12.0, 9.8], [12.2, 12.2], [12.4, 13.4], [13.0, 12.2], [14.3, 19.7], [15.0, 19.9]]
    

- 라벨링 해준다 = 지도해준다
= 지도 학습 


```python
fish_target = [1] * 35 + [0] *14
print(fish_target)
```

    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    

## 모델


```python
from sklearn.neighbors import KNeighborsClassifier

# 클래스 인스턴스화
kn = KNeighborsClassifier()

# 모형 학습
kn.fit(fish_data, fish_target)
```




    KNeighborsClassifier()




```python
# 예측 정확도
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

    물고기 길이를 입력하세요...10
    물고기 무게를 입력하세요...50
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
