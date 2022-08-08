- 크롤링 2 가지
 + HTML - 단일 페이지 크롤링 = 의미가 없음.
 + 여러 페이지 크롤링 = 의미가 있음.
 + API 활용
   + JSON, XML 


```python
from bs4 import BeautifulSoup
import requests
import pandas as pd
from datetime import datetime
import time

def get_code(company_code):
  url = 'https://finance.naver.com/item/main.naver?code=' + company_code
  response = requests.get(url)
  soup = BeautifulSoup(response.content, "html.parser")
  
  return soup

def get_price(company_code):
  soup = get_code(company_code)
  no_today = soup.select_one('p.no_today')
  #print(no_today)
  result = no_today.select_one('span.blind').text
  # 81,000 --> 숫자로 변경하는 코드 작성
  #print(result)
  return result

def  create_df(company_code, company_name, price_list):
  data = pd.DataFrame({
      '종목코드':company_code,
      '상장회사':company_name,
      '주가': price_list
  })

  return data

if __name__ == '__main__':
  company_codes = ['035720', '005930','030200']
  company_names = ['카카오','삼성전자','KT']
  
  cur_time = datetime.now()
  print("-" * 60)
  print(cur_time)
  print("-" * 60)

#company_code = '035720'
#get_price(company_code)
#soup = get_code(company_code)
#print(soup)

  prices_list = []
  for code in company_codes:
    nowPrice = get_price(code)
    print("종목코드:", code)
    print("현재주가:", nowPrice)
    prices_list.append(nowPrice)

  stock_df = create_df(company_codes,company_names,prices_list)
  print("-"*60)
  print(stock_df)   
  print("-"*60)
```

    ------------------------------------------------------------
    2022-08-08 01:37:52.342302
    ------------------------------------------------------------
    종목코드: 035720
    현재주가: 81,300
    종목코드: 005930
    현재주가: 60,800
    종목코드: 030200
    현재주가: 37,750
    ------------------------------------------------------------
         종목코드  상장회사      주가
    0  035720   카카오  81,300
    1  005930  삼성전자  60,800
    2  030200    KT  37,750
    ------------------------------------------------------------
    

## 여러 페이지의 데이터 가져오기 


```python
!pip install fake_useragent
```

    Looking in indexes: https://pypi.org/simple, https://us-python.pkg.dev/colab-wheels/public/simple/
    Collecting fake_useragent
      Downloading fake-useragent-0.1.11.tar.gz (13 kB)
    Building wheels for collected packages: fake-useragent
      Building wheel for fake-useragent (setup.py) ... [?25l[?25hdone
      Created wheel for fake-useragent: filename=fake_useragent-0.1.11-py3-none-any.whl size=13502 sha256=475f4334c820e78c4046759206e6499b23ae8168ab1ca5767846c606c2686387
      Stored in directory: /root/.cache/pip/wheels/ed/f7/62/50ab6c9a0b5567267ab76a9daa9d06315704209b2c5d032031
    Successfully built fake-useragent
    Installing collected packages: fake-useragent
    Successfully installed fake-useragent-0.1.11
    


```python
from fake_useragent import UserAgent

company_code = '005930'
url = 'https://finance.naver.com/item/sise_day.nhn?code=' + company_code
ua = UserAgent()
headers = {
    'User-agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'
}
response = requests.get(url, headers = headers)
# print(response)

soup = BeautifulSoup(response.content, 'html.parser')
last_page = int(soup.select_one('td.pgRR').a['href'].split('=')[-1])
print(last_page)
print(type(last_page))

df = None 
count = 0
for page in range(1, last_page + 1):
  req = requests.get(f'{url}&page={page}', headers=headers)
  df = pd.concat([df, pd.read_html(req.text, encoding = "euc-kr")[0]], ignore_index=True)
  if count > 10:
    break
  count += 1
  
  time.sleep(10)
 
df.dropna(inplace=True)
df.reset_index(drop=True, inplace=True)
```

    656
    <class 'int'>
    


    ---------------------------------------------------------------------------

    KeyboardInterrupt                         Traceback (most recent call last)

    <ipython-input-37-dd1a185738b8> in <module>()
         24   count += 1
         25 
    ---> 26   time.sleep(10)
         27 
         28 df.dropna(inplace=True)
    

    KeyboardInterrupt: 



```python
df
```





  <div id="df-c56f4117-1ee4-4766-b946-056f8af66446">
    <div class="colab-df-container">
      <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>날짜</th>
      <th>종가</th>
      <th>전일비</th>
      <th>시가</th>
      <th>고가</th>
      <th>저가</th>
      <th>거래량</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2022.08.08</td>
      <td>60800.0</td>
      <td>700.0</td>
      <td>61400.0</td>
      <td>61400.0</td>
      <td>60600.0</td>
      <td>6088895.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2022.08.05</td>
      <td>61500.0</td>
      <td>0.0</td>
      <td>61700.0</td>
      <td>61900.0</td>
      <td>61200.0</td>
      <td>9567620.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2022.08.04</td>
      <td>61500.0</td>
      <td>200.0</td>
      <td>61700.0</td>
      <td>61800.0</td>
      <td>61200.0</td>
      <td>9125439.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2022.08.03</td>
      <td>61300.0</td>
      <td>400.0</td>
      <td>61600.0</td>
      <td>61600.0</td>
      <td>61000.0</td>
      <td>10053861.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>70</th>
      <td>2022.06.02</td>
      <td>66700.0</td>
      <td>700.0</td>
      <td>66600.0</td>
      <td>67000.0</td>
      <td>66400.0</td>
      <td>14959443.0</td>
    </tr>
    <tr>
      <th>71</th>
      <td>2022.05.31</td>
      <td>67400.0</td>
      <td>300.0</td>
      <td>67500.0</td>
      <td>67500.0</td>
      <td>66700.0</td>
      <td>24365002.0</td>
    </tr>
    <tr>
      <th>72</th>
      <td>2022.05.30</td>
      <td>67700.0</td>
      <td>1200.0</td>
      <td>67500.0</td>
      <td>67800.0</td>
      <td>66900.0</td>
      <td>14255484.0</td>
    </tr>
    <tr>
      <th>73</th>
      <td>2022.05.27</td>
      <td>66500.0</td>
      <td>600.0</td>
      <td>66700.0</td>
      <td>66900.0</td>
      <td>66200.0</td>
      <td>11405555.0</td>
    </tr>
    <tr>
      <th>74</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>75 rows × 7 columns</p>
</div>
      <button class="colab-df-convert" onclick="convertToInteractive('df-c56f4117-1ee4-4766-b946-056f8af66446')"
              title="Convert this dataframe to an interactive table."
              style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M0 0h24v24H0V0z" fill="none"/>
    <path d="M18.56 5.44l.94 2.06.94-2.06 2.06-.94-2.06-.94-.94-2.06-.94 2.06-2.06.94zm-11 1L8.5 8.5l.94-2.06 2.06-.94-2.06-.94L8.5 2.5l-.94 2.06-2.06.94zm10 10l.94 2.06.94-2.06 2.06-.94-2.06-.94-.94-2.06-.94 2.06-2.06.94z"/><path d="M17.41 7.96l-1.37-1.37c-.4-.4-.92-.59-1.43-.59-.52 0-1.04.2-1.43.59L10.3 9.45l-7.72 7.72c-.78.78-.78 2.05 0 2.83L4 21.41c.39.39.9.59 1.41.59.51 0 1.02-.2 1.41-.59l7.78-7.78 2.81-2.81c.8-.78.8-2.07 0-2.86zM5.41 20L4 18.59l7.72-7.72 1.47 1.35L5.41 20z"/>
  </svg>
      </button>

  <style>
    .colab-df-container {
      display:flex;
      flex-wrap:wrap;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

      <script>
        const buttonEl =
          document.querySelector('#df-c56f4117-1ee4-4766-b946-056f8af66446 button.colab-df-convert');
        buttonEl.style.display =
          google.colab.kernel.accessAllowed ? 'block' : 'none';

        async function convertToInteractive(key) {
          const element = document.querySelector('#df-c56f4117-1ee4-4766-b946-056f8af66446');
          const dataTable =
            await google.colab.kernel.invokeFunction('convertToInteractive',
                                                     [key], {});
          if (!dataTable) return;

          const docLinkHtml = 'Like what you see? Visit the ' +
            '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
            + ' to learn more about interactive tables.';
          element.innerHTML = '';
          dataTable['output_type'] = 'display_data';
          await google.colab.output.renderOutput(dataTable, element);
          const docLink = document.createElement('div');
          docLink.innerHTML = docLinkHtml;
          element.appendChild(docLink);
        }
      </script>
    </div>
  </div>





```python
import requests

url = "http://data.ex.co.kr/openapi/trtm/realUnitTrtm?key=1308370912&type=json&iStartUnitCode=101&iEndUnitCode=103"
response = requests.get(url)
print(response)
```

    <Response [200]>
    


```python
json = response.json()
json
```




    {'code': 'SUCCESS',
     'count': 544,
     'message': '인증키가 유효합니다.',
     'numOfRows': 10,
     'pageNo': 1,
     'pageSize': 55,
     'realUnitTrtmVO': [{'efcvTrfl': '51',
       'endUnitCode': '103 ',
       'endUnitNm': '수원신갈',
       'iEndUnitCode': None,
       'iStartEndStdTypeCode': None,
       'iStartUnitCode': None,
       'numOfRows': None,
       'pageNo': None,
       'startEndStdTypeCode': '2',
       'startEndStdTypeNm': '도착기준통행시간',
       'startUnitCode': '101 ',
       'startUnitNm': '서울',
       'stdDate': '20220808',
       'stdTime': '07:25',
       'sumTmUnitTypeCode': None,
       'tcsCarTypeCode': '1',
       'tcsCarTypeDivCode': '1',
       'tcsCarTypeDivName': '소형차',
       'tcsCarTypeName': '1종',
       'timeAvg': '10.25',
       'timeMax': '11.533',
       'timeMin': '9.500'},
      {'efcvTrfl': '161',
       'endUnitCode': '103 ',
       'endUnitNm': '수원신갈',
       'iEndUnitCode': None,
       'iStartEndStdTypeCode': None,
       'iStartUnitCode': None,
       'numOfRows': None,
       'pageNo': None,
       'startEndStdTypeCode': '2',
       'startEndStdTypeNm': '도착기준통행시간',
       'startUnitCode': '101 ',
       'startUnitNm': '서울',
       'stdDate': '20220808',
       'stdTime': '07:30',
       'sumTmUnitTypeCode': None,
       'tcsCarTypeCode': '1',
       'tcsCarTypeDivCode': '1',
       'tcsCarTypeDivName': '소형차',
       'tcsCarTypeName': '1종',
       'timeAvg': '9.958333333333334',
       'timeMax': '12.183',
       'timeMin': '8.350'},
      {'efcvTrfl': '41',
       'endUnitCode': '103 ',
       'endUnitNm': '수원신갈',
       'iEndUnitCode': None,
       'iStartEndStdTypeCode': None,
       'iStartUnitCode': None,
       'numOfRows': None,
       'pageNo': None,
       'startEndStdTypeCode': '2',
       'startEndStdTypeNm': '도착기준통행시간',
       'startUnitCode': '101 ',
       'startUnitNm': '서울',
       'stdDate': '20220808',
       'stdTime': '07:35',
       'sumTmUnitTypeCode': None,
       'tcsCarTypeCode': '1',
       'tcsCarTypeDivCode': '1',
       'tcsCarTypeDivName': '소형차',
       'tcsCarTypeName': '1종',
       'timeAvg': '10.016666666666667',
       'timeMax': '10.633',
       'timeMin': '8.750'},
      {'efcvTrfl': '34',
       'endUnitCode': '103 ',
       'endUnitNm': '수원신갈',
       'iEndUnitCode': None,
       'iStartEndStdTypeCode': None,
       'iStartUnitCode': None,
       'numOfRows': None,
       'pageNo': None,
       'startEndStdTypeCode': '2',
       'startEndStdTypeNm': '도착기준통행시간',
       'startUnitCode': '101 ',
       'startUnitNm': '서울',
       'stdDate': '20220808',
       'stdTime': '07:40',
       'sumTmUnitTypeCode': None,
       'tcsCarTypeCode': '1',
       'tcsCarTypeDivCode': '1',
       'tcsCarTypeDivName': '소형차',
       'tcsCarTypeName': '1종',
       'timeAvg': '9.933333333333334',
       'timeMax': '12.183',
       'timeMin': '8.350'},
      {'efcvTrfl': '157',
       'endUnitCode': '103 ',
       'endUnitNm': '수원신갈',
       'iEndUnitCode': None,
       'iStartEndStdTypeCode': None,
       'iStartUnitCode': None,
       'numOfRows': None,
       'pageNo': None,
       'startEndStdTypeCode': '2',
       'startEndStdTypeNm': '도착기준통행시간',
       'startUnitCode': '101 ',
       'startUnitNm': '서울',
       'stdDate': '20220808',
       'stdTime': '07:45',
       'sumTmUnitTypeCode': None,
       'tcsCarTypeCode': '1',
       'tcsCarTypeDivCode': '1',
       'tcsCarTypeDivName': '소형차',
       'tcsCarTypeName': '1종',
       'timeAvg': '9.858333333333333',
       'timeMax': '12.600',
       'timeMin': '8.083'},
      {'efcvTrfl': '41',
       'endUnitCode': '103 ',
       'endUnitNm': '수원신갈',
       'iEndUnitCode': None,
       'iStartEndStdTypeCode': None,
       'iStartUnitCode': None,
       'numOfRows': None,
       'pageNo': None,
       'startEndStdTypeCode': '2',
       'startEndStdTypeNm': '도착기준통행시간',
       'startUnitCode': '101 ',
       'startUnitNm': '서울',
       'stdDate': '20220808',
       'stdTime': '07:50',
       'sumTmUnitTypeCode': None,
       'tcsCarTypeCode': '1',
       'tcsCarTypeDivCode': '1',
       'tcsCarTypeDivName': '소형차',
       'tcsCarTypeName': '1종',
       'timeAvg': '9.866666666666667',
       'timeMax': '10.500',
       'timeMin': '8.650'},
      {'efcvTrfl': '44',
       'endUnitCode': '103 ',
       'endUnitNm': '수원신갈',
       'iEndUnitCode': None,
       'iStartEndStdTypeCode': None,
       'iStartUnitCode': None,
       'numOfRows': None,
       'pageNo': None,
       'startEndStdTypeCode': '2',
       'startEndStdTypeNm': '도착기준통행시간',
       'startUnitCode': '101 ',
       'startUnitNm': '서울',
       'stdDate': '20220808',
       'stdTime': '07:55',
       'sumTmUnitTypeCode': None,
       'tcsCarTypeCode': '1',
       'tcsCarTypeDivCode': '1',
       'tcsCarTypeDivName': '소형차',
       'tcsCarTypeName': '1종',
       'timeAvg': '9.666666666666666',
       'timeMax': '10.733',
       'timeMin': '8.083'},
      {'efcvTrfl': '544',
       'endUnitCode': '103 ',
       'endUnitNm': '수원신갈',
       'iEndUnitCode': None,
       'iStartEndStdTypeCode': None,
       'iStartUnitCode': None,
       'numOfRows': None,
       'pageNo': None,
       'startEndStdTypeCode': '2',
       'startEndStdTypeNm': '도착기준통행시간',
       'startUnitCode': '101 ',
       'startUnitNm': '서울',
       'stdDate': '20220808',
       'stdTime': '08  ',
       'sumTmUnitTypeCode': None,
       'tcsCarTypeCode': '1',
       'tcsCarTypeDivCode': '1',
       'tcsCarTypeDivName': '소형차',
       'tcsCarTypeName': '1종',
       'timeAvg': '8.533333333333333',
       'timeMax': '12.166',
       'timeMin': '7.483'},
      {'efcvTrfl': '203',
       'endUnitCode': '103 ',
       'endUnitNm': '수원신갈',
       'iEndUnitCode': None,
       'iStartEndStdTypeCode': None,
       'iStartUnitCode': None,
       'numOfRows': None,
       'pageNo': None,
       'startEndStdTypeCode': '2',
       'startEndStdTypeNm': '도착기준통행시간',
       'startUnitCode': '101 ',
       'startUnitNm': '서울',
       'stdDate': '20220808',
       'stdTime': '08:00',
       'sumTmUnitTypeCode': None,
       'tcsCarTypeCode': '1',
       'tcsCarTypeDivCode': '1',
       'tcsCarTypeDivName': '소형차',
       'tcsCarTypeName': '1종',
       'timeAvg': '9.683333333333334',
       'timeMax': '12.000',
       'timeMin': '7.700'},
      {'efcvTrfl': '45',
       'endUnitCode': '103 ',
       'endUnitNm': '수원신갈',
       'iEndUnitCode': None,
       'iStartEndStdTypeCode': None,
       'iStartUnitCode': None,
       'numOfRows': None,
       'pageNo': None,
       'startEndStdTypeCode': '2',
       'startEndStdTypeNm': '도착기준통행시간',
       'startUnitCode': '101 ',
       'startUnitNm': '서울',
       'stdDate': '20220808',
       'stdTime': '08:05',
       'sumTmUnitTypeCode': None,
       'tcsCarTypeCode': '1',
       'tcsCarTypeDivCode': '1',
       'tcsCarTypeDivName': '소형차',
       'tcsCarTypeName': '1종',
       'timeAvg': '9.633333333333333',
       'timeMax': '11.566',
       'timeMin': '8.600'}]}




```python
cars = json['realUnitTrtmVO']
records = []
for car in cars:
  dic = {}
  dic['date'] = car['stdDate']
  dic['time'] = car['stdTime']
  dic['timeAvg'] = car['timeAvg']
  records.append(dic)

records
```




    [{'date': '20220808', 'time': '07:25', 'timeAvg': '10.25'},
     {'date': '20220808', 'time': '07:30', 'timeAvg': '9.958333333333334'},
     {'date': '20220808', 'time': '07:35', 'timeAvg': '10.016666666666667'},
     {'date': '20220808', 'time': '07:40', 'timeAvg': '9.933333333333334'},
     {'date': '20220808', 'time': '07:45', 'timeAvg': '9.858333333333333'},
     {'date': '20220808', 'time': '07:50', 'timeAvg': '9.866666666666667'},
     {'date': '20220808', 'time': '07:55', 'timeAvg': '9.666666666666666'},
     {'date': '20220808', 'time': '08  ', 'timeAvg': '8.533333333333333'},
     {'date': '20220808', 'time': '08:00', 'timeAvg': '9.683333333333334'},
     {'date': '20220808', 'time': '08:05', 'timeAvg': '9.633333333333333'}]




```python
df = pd.DataFrame(records)
df
```





  <div id="df-25e8f4db-006c-40ce-a49b-bcd2d33fd7b0">
    <div class="colab-df-container">
      <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>time</th>
      <th>timeAvg</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>20220808</td>
      <td>07:25</td>
      <td>10.25</td>
    </tr>
    <tr>
      <th>1</th>
      <td>20220808</td>
      <td>07:30</td>
      <td>9.958333333333334</td>
    </tr>
    <tr>
      <th>2</th>
      <td>20220808</td>
      <td>07:35</td>
      <td>10.016666666666667</td>
    </tr>
    <tr>
      <th>3</th>
      <td>20220808</td>
      <td>07:40</td>
      <td>9.933333333333334</td>
    </tr>
    <tr>
      <th>4</th>
      <td>20220808</td>
      <td>07:45</td>
      <td>9.858333333333333</td>
    </tr>
    <tr>
      <th>5</th>
      <td>20220808</td>
      <td>07:50</td>
      <td>9.866666666666667</td>
    </tr>
    <tr>
      <th>6</th>
      <td>20220808</td>
      <td>07:55</td>
      <td>9.666666666666666</td>
    </tr>
    <tr>
      <th>7</th>
      <td>20220808</td>
      <td>08</td>
      <td>8.533333333333333</td>
    </tr>
    <tr>
      <th>8</th>
      <td>20220808</td>
      <td>08:00</td>
      <td>9.683333333333334</td>
    </tr>
    <tr>
      <th>9</th>
      <td>20220808</td>
      <td>08:05</td>
      <td>9.633333333333333</td>
    </tr>
  </tbody>
</table>
</div>
      <button class="colab-df-convert" onclick="convertToInteractive('df-25e8f4db-006c-40ce-a49b-bcd2d33fd7b0')"
              title="Convert this dataframe to an interactive table."
              style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M0 0h24v24H0V0z" fill="none"/>
    <path d="M18.56 5.44l.94 2.06.94-2.06 2.06-.94-2.06-.94-.94-2.06-.94 2.06-2.06.94zm-11 1L8.5 8.5l.94-2.06 2.06-.94-2.06-.94L8.5 2.5l-.94 2.06-2.06.94zm10 10l.94 2.06.94-2.06 2.06-.94-2.06-.94-.94-2.06-.94 2.06-2.06.94z"/><path d="M17.41 7.96l-1.37-1.37c-.4-.4-.92-.59-1.43-.59-.52 0-1.04.2-1.43.59L10.3 9.45l-7.72 7.72c-.78.78-.78 2.05 0 2.83L4 21.41c.39.39.9.59 1.41.59.51 0 1.02-.2 1.41-.59l7.78-7.78 2.81-2.81c.8-.78.8-2.07 0-2.86zM5.41 20L4 18.59l7.72-7.72 1.47 1.35L5.41 20z"/>
  </svg>
      </button>

  <style>
    .colab-df-container {
      display:flex;
      flex-wrap:wrap;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

      <script>
        const buttonEl =
          document.querySelector('#df-25e8f4db-006c-40ce-a49b-bcd2d33fd7b0 button.colab-df-convert');
        buttonEl.style.display =
          google.colab.kernel.accessAllowed ? 'block' : 'none';

        async function convertToInteractive(key) {
          const element = document.querySelector('#df-25e8f4db-006c-40ce-a49b-bcd2d33fd7b0');
          const dataTable =
            await google.colab.kernel.invokeFunction('convertToInteractive',
                                                     [key], {});
          if (!dataTable) return;

          const docLinkHtml = 'Like what you see? Visit the ' +
            '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
            + ' to learn more about interactive tables.';
          element.innerHTML = '';
          dataTable['output_type'] = 'display_data';
          await google.colab.output.renderOutput(dataTable, element);
          const docLink = document.createElement('div');
          docLink.innerHTML = docLinkHtml;
          element.appendChild(docLink);
        }
      </script>
    </div>
  </div>





```python
import lxml
import requests
from bs4 import BeautifulSoup

url = "http://data.ex.co.kr/openapi/trtm/realUnitTrtm?key=1308370912&type=xml&iStartUnitCode=101&iEndUnitCode=103"
result = requests.get(url)
content = result.content
soup = BeautifulSoup(content, "lxml") # html.parser 
# print(soup)
print(soup.prettify())
```

    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <html>
     <body>
      <data>
       <code>
        SUCCESS
       </code>
       <message>
        인증키가 유효합니다.
       </message>
       <count>
        544
       </count>
       <numofrows>
        10
       </numofrows>
       <pageno>
        1
       </pageno>
       <pagesize>
        55
       </pagesize>
       <realunittrtmvo>
        <efcvtrfl>
         51
        </efcvtrfl>
        <endunitcode>
         103
        </endunitcode>
        <endunitnm>
         수원신갈
        </endunitnm>
        <startendstdtypecode>
         2
        </startendstdtypecode>
        <startendstdtypenm>
         도착기준통행시간
        </startendstdtypenm>
        <startunitcode>
         101
        </startunitcode>
        <startunitnm>
         서울
        </startunitnm>
        <stddate>
         20220808
        </stddate>
        <stdtime>
         07:25
        </stdtime>
        <tcscartypecode>
         1
        </tcscartypecode>
        <tcscartypedivcode>
         1
        </tcscartypedivcode>
        <tcscartypedivname>
         소형차
        </tcscartypedivname>
        <tcscartypename>
         1종
        </tcscartypename>
        <timeavg>
         10.25
        </timeavg>
        <timemax>
         11.533
        </timemax>
        <timemin>
         9.500
        </timemin>
       </realunittrtmvo>
       <realunittrtmvo>
        <efcvtrfl>
         161
        </efcvtrfl>
        <endunitcode>
         103
        </endunitcode>
        <endunitnm>
         수원신갈
        </endunitnm>
        <startendstdtypecode>
         2
        </startendstdtypecode>
        <startendstdtypenm>
         도착기준통행시간
        </startendstdtypenm>
        <startunitcode>
         101
        </startunitcode>
        <startunitnm>
         서울
        </startunitnm>
        <stddate>
         20220808
        </stddate>
        <stdtime>
         07:30
        </stdtime>
        <tcscartypecode>
         1
        </tcscartypecode>
        <tcscartypedivcode>
         1
        </tcscartypedivcode>
        <tcscartypedivname>
         소형차
        </tcscartypedivname>
        <tcscartypename>
         1종
        </tcscartypename>
        <timeavg>
         9.958333333333334
        </timeavg>
        <timemax>
         12.183
        </timemax>
        <timemin>
         8.350
        </timemin>
       </realunittrtmvo>
       <realunittrtmvo>
        <efcvtrfl>
         41
        </efcvtrfl>
        <endunitcode>
         103
        </endunitcode>
        <endunitnm>
         수원신갈
        </endunitnm>
        <startendstdtypecode>
         2
        </startendstdtypecode>
        <startendstdtypenm>
         도착기준통행시간
        </startendstdtypenm>
        <startunitcode>
         101
        </startunitcode>
        <startunitnm>
         서울
        </startunitnm>
        <stddate>
         20220808
        </stddate>
        <stdtime>
         07:35
        </stdtime>
        <tcscartypecode>
         1
        </tcscartypecode>
        <tcscartypedivcode>
         1
        </tcscartypedivcode>
        <tcscartypedivname>
         소형차
        </tcscartypedivname>
        <tcscartypename>
         1종
        </tcscartypename>
        <timeavg>
         10.016666666666667
        </timeavg>
        <timemax>
         10.633
        </timemax>
        <timemin>
         8.750
        </timemin>
       </realunittrtmvo>
       <realunittrtmvo>
        <efcvtrfl>
         34
        </efcvtrfl>
        <endunitcode>
         103
        </endunitcode>
        <endunitnm>
         수원신갈
        </endunitnm>
        <startendstdtypecode>
         2
        </startendstdtypecode>
        <startendstdtypenm>
         도착기준통행시간
        </startendstdtypenm>
        <startunitcode>
         101
        </startunitcode>
        <startunitnm>
         서울
        </startunitnm>
        <stddate>
         20220808
        </stddate>
        <stdtime>
         07:40
        </stdtime>
        <tcscartypecode>
         1
        </tcscartypecode>
        <tcscartypedivcode>
         1
        </tcscartypedivcode>
        <tcscartypedivname>
         소형차
        </tcscartypedivname>
        <tcscartypename>
         1종
        </tcscartypename>
        <timeavg>
         9.933333333333334
        </timeavg>
        <timemax>
         12.183
        </timemax>
        <timemin>
         8.350
        </timemin>
       </realunittrtmvo>
       <realunittrtmvo>
        <efcvtrfl>
         157
        </efcvtrfl>
        <endunitcode>
         103
        </endunitcode>
        <endunitnm>
         수원신갈
        </endunitnm>
        <startendstdtypecode>
         2
        </startendstdtypecode>
        <startendstdtypenm>
         도착기준통행시간
        </startendstdtypenm>
        <startunitcode>
         101
        </startunitcode>
        <startunitnm>
         서울
        </startunitnm>
        <stddate>
         20220808
        </stddate>
        <stdtime>
         07:45
        </stdtime>
        <tcscartypecode>
         1
        </tcscartypecode>
        <tcscartypedivcode>
         1
        </tcscartypedivcode>
        <tcscartypedivname>
         소형차
        </tcscartypedivname>
        <tcscartypename>
         1종
        </tcscartypename>
        <timeavg>
         9.858333333333333
        </timeavg>
        <timemax>
         12.600
        </timemax>
        <timemin>
         8.083
        </timemin>
       </realunittrtmvo>
       <realunittrtmvo>
        <efcvtrfl>
         41
        </efcvtrfl>
        <endunitcode>
         103
        </endunitcode>
        <endunitnm>
         수원신갈
        </endunitnm>
        <startendstdtypecode>
         2
        </startendstdtypecode>
        <startendstdtypenm>
         도착기준통행시간
        </startendstdtypenm>
        <startunitcode>
         101
        </startunitcode>
        <startunitnm>
         서울
        </startunitnm>
        <stddate>
         20220808
        </stddate>
        <stdtime>
         07:50
        </stdtime>
        <tcscartypecode>
         1
        </tcscartypecode>
        <tcscartypedivcode>
         1
        </tcscartypedivcode>
        <tcscartypedivname>
         소형차
        </tcscartypedivname>
        <tcscartypename>
         1종
        </tcscartypename>
        <timeavg>
         9.866666666666667
        </timeavg>
        <timemax>
         10.500
        </timemax>
        <timemin>
         8.650
        </timemin>
       </realunittrtmvo>
       <realunittrtmvo>
        <efcvtrfl>
         44
        </efcvtrfl>
        <endunitcode>
         103
        </endunitcode>
        <endunitnm>
         수원신갈
        </endunitnm>
        <startendstdtypecode>
         2
        </startendstdtypecode>
        <startendstdtypenm>
         도착기준통행시간
        </startendstdtypenm>
        <startunitcode>
         101
        </startunitcode>
        <startunitnm>
         서울
        </startunitnm>
        <stddate>
         20220808
        </stddate>
        <stdtime>
         07:55
        </stdtime>
        <tcscartypecode>
         1
        </tcscartypecode>
        <tcscartypedivcode>
         1
        </tcscartypedivcode>
        <tcscartypedivname>
         소형차
        </tcscartypedivname>
        <tcscartypename>
         1종
        </tcscartypename>
        <timeavg>
         9.666666666666666
        </timeavg>
        <timemax>
         10.733
        </timemax>
        <timemin>
         8.083
        </timemin>
       </realunittrtmvo>
       <realunittrtmvo>
        <efcvtrfl>
         544
        </efcvtrfl>
        <endunitcode>
         103
        </endunitcode>
        <endunitnm>
         수원신갈
        </endunitnm>
        <startendstdtypecode>
         2
        </startendstdtypecode>
        <startendstdtypenm>
         도착기준통행시간
        </startendstdtypenm>
        <startunitcode>
         101
        </startunitcode>
        <startunitnm>
         서울
        </startunitnm>
        <stddate>
         20220808
        </stddate>
        <stdtime>
         08
        </stdtime>
        <tcscartypecode>
         1
        </tcscartypecode>
        <tcscartypedivcode>
         1
        </tcscartypedivcode>
        <tcscartypedivname>
         소형차
        </tcscartypedivname>
        <tcscartypename>
         1종
        </tcscartypename>
        <timeavg>
         8.533333333333333
        </timeavg>
        <timemax>
         12.166
        </timemax>
        <timemin>
         7.483
        </timemin>
       </realunittrtmvo>
       <realunittrtmvo>
        <efcvtrfl>
         203
        </efcvtrfl>
        <endunitcode>
         103
        </endunitcode>
        <endunitnm>
         수원신갈
        </endunitnm>
        <startendstdtypecode>
         2
        </startendstdtypecode>
        <startendstdtypenm>
         도착기준통행시간
        </startendstdtypenm>
        <startunitcode>
         101
        </startunitcode>
        <startunitnm>
         서울
        </startunitnm>
        <stddate>
         20220808
        </stddate>
        <stdtime>
         08:00
        </stdtime>
        <tcscartypecode>
         1
        </tcscartypecode>
        <tcscartypedivcode>
         1
        </tcscartypedivcode>
        <tcscartypedivname>
         소형차
        </tcscartypedivname>
        <tcscartypename>
         1종
        </tcscartypename>
        <timeavg>
         9.683333333333334
        </timeavg>
        <timemax>
         12.000
        </timemax>
        <timemin>
         7.700
        </timemin>
       </realunittrtmvo>
       <realunittrtmvo>
        <efcvtrfl>
         45
        </efcvtrfl>
        <endunitcode>
         103
        </endunitcode>
        <endunitnm>
         수원신갈
        </endunitnm>
        <startendstdtypecode>
         2
        </startendstdtypecode>
        <startendstdtypenm>
         도착기준통행시간
        </startendstdtypenm>
        <startunitcode>
         101
        </startunitcode>
        <startunitnm>
         서울
        </startunitnm>
        <stddate>
         20220808
        </stddate>
        <stdtime>
         08:05
        </stdtime>
        <tcscartypecode>
         1
        </tcscartypecode>
        <tcscartypedivcode>
         1
        </tcscartypedivcode>
        <tcscartypedivname>
         소형차
        </tcscartypedivname>
        <tcscartypename>
         1종
        </tcscartypename>
        <timeavg>
         9.633333333333333
        </timeavg>
        <timemax>
         11.566
        </timemax>
        <timemin>
         8.600
        </timemin>
       </realunittrtmvo>
      </data>
     </body>
    </html>
    


```python
timeAvg_lists = soup.find_all("timeavg")
stddate_lists = soup.find_all("stddate")
stdtime_lists = soup.find_all("stdtime")
```


```python
timeAvg_lists
```




    [<timeavg>10.25</timeavg>,
     <timeavg>9.958333333333334</timeavg>,
     <timeavg>10.016666666666667</timeavg>,
     <timeavg>9.933333333333334</timeavg>,
     <timeavg>9.858333333333333</timeavg>,
     <timeavg>9.866666666666667</timeavg>,
     <timeavg>9.666666666666666</timeavg>,
     <timeavg>8.533333333333333</timeavg>,
     <timeavg>9.683333333333334</timeavg>,
     <timeavg>9.633333333333333</timeavg>]




```python
avgTime = []
stddate = []
stdtime = []
for timeAvg, date, time in zip(timeAvg_lists, stddate_lists, stdtime_lists):
  # print(timeAvg, date, time)
  # print(time.get_text())
  avgTime.append(timeAvg.get_text())
  stddate.append(date.get_text())
  stdtime.append(time.get_text())

df = pd.DataFrame({
    "date": stddate, 
    "time": stdtime, 
    "avgTime": avgTime
})

df
```





  <div id="df-e5885753-f7f7-4b7c-82d2-a6a0edc6d25c">
    <div class="colab-df-container">
      <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>time</th>
      <th>avgTime</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>20220808</td>
      <td>07:25</td>
      <td>10.25</td>
    </tr>
    <tr>
      <th>1</th>
      <td>20220808</td>
      <td>07:30</td>
      <td>9.958333333333334</td>
    </tr>
    <tr>
      <th>2</th>
      <td>20220808</td>
      <td>07:35</td>
      <td>10.016666666666667</td>
    </tr>
    <tr>
      <th>3</th>
      <td>20220808</td>
      <td>07:40</td>
      <td>9.933333333333334</td>
    </tr>
    <tr>
      <th>4</th>
      <td>20220808</td>
      <td>07:45</td>
      <td>9.858333333333333</td>
    </tr>
    <tr>
      <th>5</th>
      <td>20220808</td>
      <td>07:50</td>
      <td>9.866666666666667</td>
    </tr>
    <tr>
      <th>6</th>
      <td>20220808</td>
      <td>07:55</td>
      <td>9.666666666666666</td>
    </tr>
    <tr>
      <th>7</th>
      <td>20220808</td>
      <td>08</td>
      <td>8.533333333333333</td>
    </tr>
    <tr>
      <th>8</th>
      <td>20220808</td>
      <td>08:00</td>
      <td>9.683333333333334</td>
    </tr>
    <tr>
      <th>9</th>
      <td>20220808</td>
      <td>08:05</td>
      <td>9.633333333333333</td>
    </tr>
  </tbody>
</table>
</div>
      <button class="colab-df-convert" onclick="convertToInteractive('df-e5885753-f7f7-4b7c-82d2-a6a0edc6d25c')"
              title="Convert this dataframe to an interactive table."
              style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M0 0h24v24H0V0z" fill="none"/>
    <path d="M18.56 5.44l.94 2.06.94-2.06 2.06-.94-2.06-.94-.94-2.06-.94 2.06-2.06.94zm-11 1L8.5 8.5l.94-2.06 2.06-.94-2.06-.94L8.5 2.5l-.94 2.06-2.06.94zm10 10l.94 2.06.94-2.06 2.06-.94-2.06-.94-.94-2.06-.94 2.06-2.06.94z"/><path d="M17.41 7.96l-1.37-1.37c-.4-.4-.92-.59-1.43-.59-.52 0-1.04.2-1.43.59L10.3 9.45l-7.72 7.72c-.78.78-.78 2.05 0 2.83L4 21.41c.39.39.9.59 1.41.59.51 0 1.02-.2 1.41-.59l7.78-7.78 2.81-2.81c.8-.78.8-2.07 0-2.86zM5.41 20L4 18.59l7.72-7.72 1.47 1.35L5.41 20z"/>
  </svg>
      </button>

  <style>
    .colab-df-container {
      display:flex;
      flex-wrap:wrap;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

      <script>
        const buttonEl =
          document.querySelector('#df-e5885753-f7f7-4b7c-82d2-a6a0edc6d25c button.colab-df-convert');
        buttonEl.style.display =
          google.colab.kernel.accessAllowed ? 'block' : 'none';

        async function convertToInteractive(key) {
          const element = document.querySelector('#df-e5885753-f7f7-4b7c-82d2-a6a0edc6d25c');
          const dataTable =
            await google.colab.kernel.invokeFunction('convertToInteractive',
                                                     [key], {});
          if (!dataTable) return;

          const docLinkHtml = 'Like what you see? Visit the ' +
            '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
            + ' to learn more about interactive tables.';
          element.innerHTML = '';
          dataTable['output_type'] = 'display_data';
          await google.colab.output.renderOutput(dataTable, element);
          const docLink = document.createElement('div');
          docLink.innerHTML = docLinkHtml;
          element.appendChild(docLink);
        }
      </script>
    </div>
  </div>



