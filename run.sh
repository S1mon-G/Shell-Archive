BLUE='\033[0;34;4m'
GREEN='\033[0;32m'
NC='\033[0m'

now=$(date +"%Y-%m-%dT%H:%M:%S.%3N%z")
echo "Bash script starting at: $now" 

echo "Script full path: '$(realpath run.sh)'"

temp="./temp"
[ -d "$temp" ] && rm -rf "$temp"
mkdir -p "$temp"

while IFS= read -r url; do
filename=$(basename "$url")
jsonfile="$temp/$filename"
headerfile="$temp/$filename.headers"

echo "Downloading${BLUE}$url${NC}"

curl -s -D "$headerfile" "$url" -o "$jsonfile"

echo "${GREEN}done${NC}"

done < "urls.txt"

downloads="./downloads"
[ -d "$downloads" ] && rm -rf "$downloads"
mkdir -p "$downloads"

cp ./temp/*.json ./downloads

echo "Copying JSON files from '$(basename "$temp")'to '$(basename "$downloads")'"
