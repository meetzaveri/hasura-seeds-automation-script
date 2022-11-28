#!/bin/bash
# define color variables for formatting the output
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'

# get .txt file to loop over
seed_files=$(cat sql_seed_file_names.txt) # replace the .txt file name here

echo -n "please enter database name: "
read db_name

# for file in "seeds/default"/*; do
#   $(echo $file>> read.txt)
#   echo "name - $file"
# done

for file in $seed_files; do
  echo -e "${YELLOW} file name : $file"
  $(hasura seed apply --file $file --database-name $db_name) # uses hasura CLI to apply seed
  if [ $? -eq 0 ]; then
  echo -e "${CYAN} Seed $file applied"
  else
  echo -e "${RED} Error on $file"
  fi
done
