#!/bin/bash
RED='\033[0;31m' # these are color variables defined in starting lines
CYAN='\033[0;36m'
YELLOW='\033[1;33m'

tables=$(cat table_list.txt) # please paste your table list .txt file name here

echo -n "please enter database name: "
read db_name

for i in $tables; do
echo -e "${YELLOW} table: $i"
$(hasura seed create $i --from-table $i --database-name $db_name) # uses hasura CLI to create seed
if [ $? -eq 0 ]; then
echo -e "${CYAN} Seed $i created"
else
$(echo $i >> remaining_table_names.txt) 
# if in some case error occurs, we can store those table names in some file (here remaining_table_names.txt ). 
# we can later attempt again to generate seeds using that .txt file

echo -e "${RED} Error on $i"
fi
done
