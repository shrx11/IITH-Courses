
import psycopg2
import psycopg2.extras

import psycopg2
import time
import re

start = time.perf_counter()


connection = psycopg2.connect(
    host="localhost",
    dbname="research_engine",
    user="testuser",
    password="password",
)
connection.autocommit = True

venues = [] # list of names
researchers = [] # list of (first_name,middle_name,last_name)
papers = [] # list of (title,abstract,yop,vid)
authors = [] # list with (order,rid,pid)
citations = [] # set with (refid,pid)

f = open('source.txt', 'r')

title = None
temp_authors = []
year = None
venue = None
vname=None
ref_indices = []
abstract = None
paper_entry = {'title':title, 'abstract': abstract, 'yop': year, 'vname':venue}


#----------PARSING PHASE--------------#
for line in f.readlines():
    if line != "\n":
            if line[:2]=='#*':
                title = line.strip()[2:]
                if re.search('workshop|conference', title, re.IGNORECASE):
                    split = re.split(': ',title)
                    paper_entry['title'] = split[0]
                else:
                    split = []
                    paper_entry['title'] = title
                if len(split)>1:
                    vname = split[1]
                pass
            elif line[:2]=='#@':
                temp_authors = line.strip()[2:]
                temp_authors = filter(bool,re.split(';|,', temp_authors))
                pass                
            elif line[:2]=='#t':
                year = int(line.strip()[2:])
                paper_entry['yop'] = year
                pass            
            elif line[:2]=='#c':
                venue = line.strip()[2:]
                if venue!='':
                    vname=venue
                pass
        
            elif line[:2]=='#i':
                pid = int(line.strip()[6:])+1
                pass

            elif line[:2]=='#%':
                ref_indices.append(int(line.strip()[2:])+1)
                pass
                
            elif line[:2]=='#!':
                abstract = line.strip()[2:]
                paper_entry['abstract'] = abstract

    else:

            if vname:
                venues.append({'name':vname})
            paper_entry['vname'] = vname
            papers.append(paper_entry)

            
            order = 1
            for a in temp_authors:
                names = a.strip().split(' ')
                first_name = names[0]
                last_name = names[-1]
                middle_name = ''
                for n in names[1:-1]:
                    middle_name += n   

                if middle_name == '':
                    middle_name = None           
                
                researchers.append({'First_name': first_name, 
                                    'Middle_name': middle_name,
                                    'Last_name': last_name})

                authors.append({ **researchers[-1], 'order':order, 'pid': pid})
                order+=1

            for refid in ref_indices:
                citations.append({'Refid': refid,'Pid': pid})
            

            title = None
            temp_authors = []
            year = None
            venue = None
            vname=None
            ref_indices = []
            abstract = None
            paper_entry = {'title':title, 'abstract': abstract, 'yop': year, 'vname':vname}

#------------------------------------- #

#-----------LOADING PHASE--------------#

with connection.cursor() as cursor:
    
    psycopg2.extras.execute_batch(cursor,
        """
        INSERT INTO venue (Name) VALUES (
            %(name)s
        ) ON CONFLICT DO NOTHING;
        """,venues)

with connection.cursor() as cursor:

    psycopg2.extras.execute_batch(cursor,
        """
        do $func$

        BEGIN
        PERFORM Vid from venue WHERE Name=%(vname)s;
        IF NOT FOUND THEN
            INSERT INTO research_paper (Title, Abstract, YOP, Vid) VALUES (%(title)s, %(abstract)s, %(yop)s, NULL);
        ELSE
            INSERT INTO research_paper (Title, Abstract, YOP, Vid) SELECT %(title)s, %(abstract)s, %(yop)s,Vid from  venue WHERE Name=%(vname)s;
        END IF;
        END $func$
        """,papers)



with connection.cursor() as cursor:
    
    psycopg2.extras.execute_batch(cursor,
        """
        INSERT INTO researcher(First_name, Middle_name, Last_name) VALUES (
            %(First_name)s,
            %(Middle_name)s,
            %(Last_name)s
        ) ON CONFLICT DO NOTHING;
        """,researchers)

with connection.cursor() as cursor:
    
    psycopg2.extras.execute_batch(cursor,
        """
        INSERT INTO reference(Refid, Pid) VALUES (
            %(Refid)s,
            %(Pid)s
        ) ON CONFLICT DO NOTHING;""",citations)


with connection.cursor() as cursor:

    
    psycopg2.extras.execute_batch(cursor,
        """
        do $func$

        BEGIN
        IF %(Middle_name)s is NULL THEN
            PERFORM Rid from researcher WHERE First_name=%(First_name)s AND Middle_name is NULL AND last_name=%(Last_name)s;
            IF NOT FOUND THEN
                INSERT INTO author(Auth_Order, Rid, Pid) VALUES (%(order)s,NULL, %(pid)s) ON CONFLICT DO NOTHING;
            ELSE
                INSERT INTO author(Auth_Order, Rid, Pid) SELECT %(order)s, Rid, %(pid)s from  researcher WHERE First_name=%(First_name)s AND Middle_name is NULL AND last_name=%(Last_name)s ON CONFLICT DO NOTHING;
            END IF;
        ELSE
            PERFORM Rid from researcher WHERE First_name=%(First_name)s AND Middle_name=%(Middle_name)s AND last_name=%(Last_name)s;
            IF NOT FOUND THEN
                INSERT INTO author(Auth_Order, Rid, Pid) VALUES (%(order)s,NULL, %(pid)s) ON CONFLICT DO NOTHING;
            ELSE
                INSERT INTO author(Auth_Order, Rid, Pid) SELECT %(order)s, Rid, %(pid)s from  researcher WHERE First_name=%(First_name)s AND Middle_name=%(Middle_name)s AND last_name=%(Last_name)s ON CONFLICT DO NOTHING;
            END IF;
        END IF;

        END $func$
        """,authors)

#--------------------------------#

elapsed = time.perf_counter() - start
print(f'Time {elapsed:0.4}')
