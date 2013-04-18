#/bin/sh

while read line; do
plugin="$line"
# Prozedur:
echo "$plugin" >> test.txt
done < plugins.list
