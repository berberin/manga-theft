#!/usr/bin/env python
# coding: utf-8

import re
import requests
from bs4 import BeautifulSoup
import json




urlSample = "https://manganelo.com/genre-all/{}"



headers = {
    "Host": "manganelo.com",
    "Origin": "https://manganelo.com",
    "Referer": "https://manganelo.com",
}

manga_list = []


for i in range (1, 1400):
    try:
        response = requests.get(urlSample.format(i), headers=headers)
        if (response.status_code != 200):
            continue
        else:
            response = response.text
        soup = BeautifulSoup(response, "html.parser")
        items = soup.find_all("div", class_="content-genres-item")

        for item in items:
            try:
                titleItem = item.find("a", class_="genres-item-img")
                title = titleItem['title']
                url = titleItem['href']

                reId = re.findall(r'manga/(.+)$', url)
                if len(reId) > 0:
                    id = reId[0]
                else:
                    id = url

                imgUrl = item.find("img", class_="img-loading")['src']
                # description = item.find("div", class_="genres-item-description").text
                authorItem = item.select("span.genres-item-author")
                if (len(authorItem)>0):
                    author = authorItem[0].get_text()
                else:
                    author = ''
            
            
                resp = requests.get(url, headers=headers)
                if (resp.status_code != 200):
                    print(resp.text)
                    continue
                
                soup3 = BeautifulSoup(resp.text,"html.parser")
                description = soup3.find("div", class_="panel-story-info-description").text

                reAlias = re.findall(r'info-alternative.*</td>.+<h2>(.*?)</h2>', resp.text, re.S)
                if (len(reAlias)>0):
                    aliases = reAlias[0].split(';')
                    for i in range(0, len(aliases)):
                        aliases[i] = aliases[i].strip()
                else:
                    aliases = []
                
                reStatus = re.findall(r'info-status.*</td>\s*.+>(.*)</td>', resp.text)
                if (len(reStatus)>0):
                    status = reStatus[0]
                else:
                    status = 'Unknown'

                reGenres = re.findall(r'info-genres.+</td>(.+</td>)', resp.text, re.S)
                if (len(reGenres)>0):
                    soup2 = BeautifulSoup(reGenres[0], "html.parser")
                    genres = soup2.select('td.table-value a.a-h')
                    tags = []
                    for gen in genres:
                        tags.append(gen.get_text())
                else:
                    tags = []

                manga_list.append({
                    "id": id,
                    "url": url,
                    "title": title,
                    "alias": aliases,
                    "imgUrl": imgUrl,
                    "tags": tags,
                    "author": author,
                    "description": description,
                    "status": status,
                    "lang": 'en',
                    "repoSlug": 'en>manganelo>'
                })
            except:
                print(len(manga_list))
                continue
    except:
        continue

    print(len(manga_list))
  
    
  

with open('manganelo_data.json', 'w', encoding='utf-8') as f:
    json.dump(manga_list, f, ensure_ascii=False, indent=4)
