# get hrefs out of an html doc
# Print hrefs of each anchor

import sys

inputArgs = sys.argv

for inputFile in inputArgs[1:]:

	from bs4 import BeautifulSoup

	htmlDoc = open(file)
	soup = BeautifulSoup(htmlDoc,features="lxml")
	import re
	for link in soup.find_all("a", {'href': re.compile(r'/RSO/')}):
	    link.attrs["href"] = "/blahbiddyblahblah/"
	    print(link)

	htmlDoc.close()

	html = soup.prettify("utf-8")
	with open(inputFile, "wb") as file:
	    file.write(html)
