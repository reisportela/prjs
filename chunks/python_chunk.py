## BPLIM: input NIFs
## July 2019
## MPortela


import os
import pandas as pd
import re

# Create list with .txt files for the specified folder
files_list = list()
for (dirpath, dirnames, filenames) in os.walk('/Users/miguelportela/Documents/GitHub/prjs/pdfs'):
    files_list += [os.path.join(dirpath, file) for file in filenames if file.endswith('.txt')]
    

nipc = []

for file in files_list:

    f = open(file, "r", encoding='latin8')
    data = f.read()
    f.close()
    lines = str(data) 
    line = lines.splitlines()
    
    for num, word in enumerate(line):
        if num == 0:
            continue
        else:
            match1 = re.search(r'\d{9}', word) 
             # when it finds a 9 digit number, 3 outcomes are possible:
             # - finds matrícula in that line (match2)
             # - finds matricula in the previous line if it wasn't found on the currrent line
             # - does not find matricula
            if match1:
                    match2 = re.search(r'(m|M)(a|A)(t|T)(r|R)(i|í|I|Í)(c|C)(u|U)(l|L)(a|A)', word)
                    if match2:
                        nipc.append(float(match1.group()))
                    else:
                        match3 = re.search(r'(m|M)(a|A)(t|T)(r|R)(i|í|I|Í)(c|C)(u|U)(l|L)(a|A)', line[num-1])
                        if match3:
                            nipc.append(float(match1.group()))


df = pd.DataFrame({'nipc': nipc})

df.to_stata('nipcs.dta', write_index = False)
