from bs4 import beautifulsoup

soup = beautifulsoup(open("index.html", encoding="utf-8"),
    "html.parser")

soup = soup.find('div',class _ = "computer")

# print(soup)
 soup = soup.find('p')
 print(soup)

 final_text = soup.get_text()
 print(final_text)