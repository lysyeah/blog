```python
## 합성곱 신경망의 구성 요소

- 인공신경망 (회귀식)
 + y = 기울기 x 데이터 + 상수
 + y = 가중치 x 데이터 + 상수


 - 출력할 때는 활성함수를 통과해야 함.
  + 조건문
  + 0.5보다 크면 1/ 작으면 0
  + 0보다 크면 원래값 출력, 0보다 작으면 무조건 0 
```


      File "<ipython-input-1-72d599125f19>", line 4
        + y = 기울기 x 데이터 + 상수
        ^
    IndentationError: unexpected indent
    



```python
import tensorflow as tf
print(tf.__version__)
```

    2.8.2
    


```python
from tensorflow import keras
from sklearn.model_selection import train_test_split

(train_input, train_target), (test_input, test_target) = \
    keras.datasets.fashion_mnist.load_data()

train_scaled = train_input.reshape(-1, 28, 28, 1) / 255.0
train_scaled, val_scaled, train_target, val_target = train_test_split( 
    train_scaled, train_target, test_size=0.2, random_state=42
)

train_scaled.shape,  val_scaled.shape,  train_target.shape, val_target.shape
```




    ((48000, 28, 28, 1), (12000, 28, 28, 1), (48000,), (12000,))



## 합성곱 신경망 만들기


```python
model = keras.Sequential()

# 딥러닝 전반부 / 표본 작업
model.add(keras.layers.Conv2D( 32, kernel_size= 3, activation='relu', padding='same', input_shape=(28,28,1)))
model.add(keras.layers.MaxPooling2D(2))
model.add(keras.layers.Conv2D(63, kernel_size=3, activation='relu', padding='same'))
model.add(keras.layers.MaxPooling2D(2))

# 딥러닝 후반부
# 필리핀 사진 / 한국사진
model.add(keras.layers.Flatten())
model.add(keras.layers.Dense(100, activation='relu'))
model.add(keras.layers.Dropout(0.4))
model.add(keras.layers.Dense(10, activation='softmax'))
```


```python
model.summary()
```

    Model: "sequential_2"
    _________________________________________________________________
     Layer (type)                Output Shape              Param #   
    =================================================================
     conv2d_3 (Conv2D)           (None, 28, 28, 32)        320       
                                                                     
     max_pooling2d_2 (MaxPooling  (None, 14, 14, 32)       0         
     2D)                                                             
                                                                     
     conv2d_4 (Conv2D)           (None, 14, 14, 63)        18207     
                                                                     
     max_pooling2d_3 (MaxPooling  (None, 7, 7, 63)         0         
     2D)                                                             
                                                                     
     flatten (Flatten)           (None, 3087)              0         
                                                                     
     dense (Dense)               (None, 100)               308800    
                                                                     
     dropout (Dropout)           (None, 100)               0         
                                                                     
     dense_1 (Dense)             (None, 10)                1010      
                                                                     
    =================================================================
    Total params: 328,337
    Trainable params: 328,337
    Non-trainable params: 0
    _________________________________________________________________
    


```python
keras.utils.plot_model(model)
```




    
![png](output_6_0.png)
    




```python
keras.utils.plot_model(model, show_shapes=True, to_file='cnn-architecture.png', dpi=300)
```




    
![png](output_7_0.png)
    




```python
## 모델 컴파일과 훈련
```


```python
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', 
              metrics='accuracy')

checkpoint_cb = keras.callbacks.ModelCheckpoint('best-cnn-model.h5', 
                                                save_best_only=True)
early_stopping_cb = keras.callbacks.EarlyStopping(patience=2,
                                                  restore_best_weights=True)

history = model.fit(train_scaled, train_target, epochs=20,
                    validation_data=(val_scaled, val_target),
                    callbacks=[checkpoint_cb, early_stopping_cb])
```

    Epoch 1/20
    1500/1500 [==============================] - 18s 4ms/step - loss: 0.5133 - accuracy: 0.8171 - val_loss: 0.3420 - val_accuracy: 0.8752
    Epoch 2/20
    1500/1500 [==============================] - 5s 3ms/step - loss: 0.3396 - accuracy: 0.8786 - val_loss: 0.2749 - val_accuracy: 0.8975
    Epoch 3/20
    1500/1500 [==============================] - 5s 3ms/step - loss: 0.2926 - accuracy: 0.8927 - val_loss: 0.2568 - val_accuracy: 0.9038
    Epoch 4/20
    1500/1500 [==============================] - 5s 3ms/step - loss: 0.2612 - accuracy: 0.9057 - val_loss: 0.2422 - val_accuracy: 0.9115
    Epoch 5/20
    1500/1500 [==============================] - 5s 3ms/step - loss: 0.2359 - accuracy: 0.9139 - val_loss: 0.2344 - val_accuracy: 0.9150
    Epoch 6/20
    1500/1500 [==============================] - 5s 3ms/step - loss: 0.2174 - accuracy: 0.9191 - val_loss: 0.2258 - val_accuracy: 0.9152
    Epoch 7/20
    1500/1500 [==============================] - 5s 3ms/step - loss: 0.1982 - accuracy: 0.9259 - val_loss: 0.2249 - val_accuracy: 0.9197
    Epoch 8/20
    1500/1500 [==============================] - 5s 3ms/step - loss: 0.1820 - accuracy: 0.9320 - val_loss: 0.2259 - val_accuracy: 0.9172
    Epoch 9/20
    1500/1500 [==============================] - 5s 3ms/step - loss: 0.1663 - accuracy: 0.9368 - val_loss: 0.2309 - val_accuracy: 0.9194
    


```python
import matplotlib.pyplot as plt
```


```python
plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.xlabel('epoch')
plt.ylabel('loss')
plt.legend(['train', 'val'])
plt.show()
```


    
![png](output_11_0.png)
    



```python
model.evaluate(val_scaled, val_target)
```

    375/375 [==============================] - 1s 2ms/step - loss: 0.2249 - accuracy: 0.9197
    




    [0.2249407321214676, 0.9197499752044678]




```python
plt.imshow(val_scaled[0].reshape(28, 28), cmap='gray_r')
plt.show()
```


    
![png](output_13_0.png)
    



```python
preds = model.predict(val_scaled[0:1])
print(preds)
```

    [[2.1743567e-16 3.9216802e-22 4.3546272e-19 7.4669600e-20 1.8280050e-16
      1.1351690e-15 7.3785950e-18 1.5740125e-16 1.0000000e+00 4.4099451e-18]]
    


```python
plt.bar(range(1, 11), preds[0])
plt.xlabel('class')
plt.ylabel('prob.')
plt.show()
```


    
![png](output_15_0.png)
    



```python
classes = ['티셔츠', '바지', '스웨터', '드레스', '코트',
           '샌달', '셔츠', '스니커즈', '가방', '앵클 부츠']
```


```python
import numpy as np
print(classes[np.argmax(preds)])
```

    가방
    


```python
test_scaled = test_input.reshape(-1, 28, 28, 1) / 255.0
model.evaluate(test_scaled, test_target)
```

    313/313 [==============================] - 1s 3ms/step - loss: 0.2481 - accuracy: 0.9134
    




    [0.24810977280139923, 0.9133999943733215]



## 특성 맵 시각화


```python

```
