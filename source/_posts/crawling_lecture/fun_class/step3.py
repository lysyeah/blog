# -*- coding: utf-8 -*-
# fun_class/data

def main():
    print("파일 불러오기 시작")
    with open("data/news_article.txt", encoding='utf-8')as file:
        text= file.read()

    print("파일 불러오기 완료..!")
    n=0
    for word in text.split():
        if word in ['카카오', '카카오모빌리티']:
             n +=1
    print("단어 갯수: ", n)

if __name__ == "__main__":
    main()


