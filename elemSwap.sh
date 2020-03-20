
#!/bin/bash
# search through files, if filename contains .html, search file and swap two elements
# iterate over files where filename contains .html, swap two elements. 
for i in `find . -type f -name "*.html"`;
do
  getElementsByClass
done


from bs4 import BeautifulSoup

with open("~/Users/ca62219/Documents/projects/ddins/index.html") as fp:
    soup = BeautifulSoup(fp)

soup = BeautifulSoup("<html>data</html>")