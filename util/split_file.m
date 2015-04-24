function substr = split_file(c)
substr = strsplit(char(c), {'_','.'},'CollapseDelimiters',true);