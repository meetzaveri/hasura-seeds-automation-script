# hasura-seeds-automation-script
This repository aims at generating seeds and applying seeds via automation scripts and some bash command magic. This will take help of hasura CLI command to generate seeds and apply seeds. Please go through instructions posted in readme.md file

## Step by step instructions

### First, extract tables from psql 
Script I used to extract tables from psql

This is to extract all tables from `public` schema into output file of `temp.txt`

```bash
postgres=> \o temp.txt
postgres=> \dt+ public.*
```

here we will output tables list generated via `\dt+ public.*` command (which lists all the tables under specific schema) to `temp.txt` file.

This would show raw output like
```
Schema |                 Name                 | Type  |  Owner   | Persistence | Access method |    Size    |             Description             
--------+--------------------------------------+-------+----------+-------------+---------------+------------+-------------------------------------
 public | account_status_types                 | table | postgres | permanent   | heap          | 16 kB      | 
 public | api_keys                             | table | postgres | permanent   | heap          | 16 kB      | 
```


Now we want those table names only. We could use `cut` command to trim through range of columns. I used following script to extract table names only from specific column of a text file

```bash
cut -c9-47 temp.txt >filtered_tables_list.txt ### please use column number acc. to your file. 
```

this will go and extract text from col 9 to col 47 and create rows in temp1.txt output file. 

Result would look like
```
 account_status_types                 
 api_keys                             
 bank_accounts                
```

We got the list of tables now (filtered from raw text file). We could now use `generate_seeds.sh` to generate seeds via hasura CLI which will use this text file for looping through tables and would generate seeds respectively.

Make sure if you are using `config.yaml` as a setup, then update endpoint value from which you are trying to generate seeds from. For admin secret, you can use `--admin-secret` flag or already pass it in `config.yaml` file. You will be prompted for entering your database name.

Please go to `generate_seeds.sh` file here in this repo.

### Post generation of seeds, apply seeds to specific 

If you are using hasura CLI's `config.yaml`, then make changes accordingly (like changing endpoint to which you'll apply seeds against).

All seeds will be generated under directory `seeds` -> `your_database_name` -> all seeds. Here we can, run bash command
```bash
### type your database name here instead of "default".
find seeds/default 
```

Then you'll see the output like (raw)
```
seeds/default/1669627757302_users.sql
seeds/default/1669286275005_staff_members.sql
seeds/default/1669286239857_bank_accounts.sql
...
```

#### Use generated seed filenames list and create bash script for applying those seeds via automation

Copy those lines (from raw output) and paste it into another newly created text file.

When you list all those seed filenames under one text file, then you can take out seed file name by trimming through columns of that text file by using `cut` command.
```bash
cut -c15-63 read.txt >temp2.txt   ### Here again, please check column acc. to your file. Based on your format, you'll figure out which column range to trim out.
```

The resultant text file would contain (filtered from raw part)
```
1669627757302_users.sql
1669286275005_staff_members.sql
1669286239857_bank_accounts.sql
...
```

Now copy this text file name and insert it into `apply_seeds.sh` line no. 6 (i.e. seed_files variable). This will be responsible as input text file from which script will loop through and apply seeds with those seed file names.

update that line in script of `apply_seeds.sh`.
```bash
seed_files=$(cat enter_your_text_file_name.txt)
```

Please refer `apply_seeds.sh` file for applying seeds.

### Conclusion
I hope these automation tricks and scripts saved you time and you understood thoroughly. Please open a GH issue if you think documentation or script can be improved. Thank you for dropping by here!


