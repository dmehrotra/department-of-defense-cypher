import csv
import pdb as d
import re
import string

f = open('contracts.csv', 'rb')
regex = re.compile(".*?\((.*?)\)")
reader = csv.reader(f)
headers = reader.next()
column = {}

def format_number(v):
	format = v.replace(" ", "").replace(")","").replace("(","").replace("*","").replace(",","").replace("Small","").strip()
	if len(format.split('-')) > 3:
		return format
	else:
		return "Unknown"


def fuck_the_comma(format):
	try:
		if format[len(format) - 1] == ',':
			format = format[:-1]
	except IndexError:
		format = format
	
	return format

def fuck_the_parens(format):
	parens = re.findall(regex, format)
	for p in parens:
		format = format.replace("("+p+")",'')

	return format

def fuck_leading_spaces(format):
	format = format.decode('utf-8','ignore').encode("utf-8")
	format = ''.join(x for x in format if x in string.printable)
	try:
		if format[0] == ' ':
			format = format[1:]
	except IndexError:
		format = format
	return format

def format_purpose(v):
	format = v.strip()
	return format

def format_pow(v):
	
	
	format = v.replace("The work will be performed","").replace(" in ","").replace("within",'').replace('at','')
	format = format.split("Work")[0].split(". T")[0].split(". W")[0]
	format = format.split("and is expected")[0].split("and the ordering")[0]
	format = format.split(".<span>")[0].split("and work")[0].strip()
	format = fuck_the_parens(format)
	format = fuck_the_comma(format)
	return format


def format_ca(v):
	format = v.replace('<span>','').replace('</span>','').replace('is the contracting activity','').replace("The contracting activity is ",'').strip()
	format = fuck_the_parens(format)
	format = fuck_leading_spaces(format)
	format = fuck_the_comma(format)
	return format


for h in headers:
	column[h] = []

for row in reader:
	for h, v in zip(headers, row):
		if h == 'contract_number':
			column[h].append(format_number(v))
		if h == 'for_what':
			column[h].append(format_purpose(v))
		if h == 'place_of_work':
			column[h].append(format_pow(v))
		if h == 'contracting_activity':
			column[h].append(format_ca(v))
		else:
			column[h].append(v.strip())


with open('clean_contracts.csv', 'w') as csvfile:
    fieldnames = headers
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    for idx, val in enumerate(column['id']):
    	row = {}
    	
    	for h in headers:
    		if column[h][idx]:
    			row[h] = column[h][idx]
    		else:	
    			row[h] = "False"

    	writer.writerow(row)


