BLUE='\033[0;34;4m'
GREEN='\033[0;32m'
NC='\033[0m'
DONE_MSG="${GREEN}done${NC}"
TEMP_DIR='./temp'
DOWNLOAD_DIR='./downloads'
ARCHIVES_DIR='./archives'


now=$(date +"%Y-%m-%dT%H:%M:%S.%z")
echo "> Bash script starting at: $now"

echo "> Script full path: '$(realpath run.sh)'"

[ -d "$TEMP_DIR" ] && rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

while IFS= read -r url; do
filename=$(basename "$url")
jsonfile="$TEMP_DIR/$filename"
headerfile="$TEMP_DIR/$filename.headers"

echo "> Downloading${BLUE}$url${NC}"

curl -s -D "$headerfile" "$url" -o "$jsonfile"

echo "$DONE_MSG"

done < "urls.txt"

[ -d "$DOWNLOAD_DIR" ] && rm -rf "$DOWNLOAD_DIR"
mkdir -p "$DOWNLOAD_DIR"

echo "> Copying JSON files from '$(basename "$TEMP_DIR")'to '$(basename "$DOWNLOAD_DIR")'"

cp "$TEMP_DIR"/*.json "$DOWNLOAD_DIR"

echo "$DONE_MSG"

echo "> Compiling HTTP response headers from '$(basename "$TEMP_DIR")' to '$(basename "$DOWNLOAD_DIR")'"

OUTPUT="$DOWNLOAD_DIR/headers.txt"

for file in "$TEMP_DIR"/*.json.headers; do
echo "### $(basename "$file")" >> "$OUTPUT"

while IFS= read -r line; do
echo "$line" >> "$OUTPUT"
done < "$file"

echo "\n" >> "$OUTPUT"
done

echo "$DONE_MSG"

echo "> Compressing all files in '$DOWNLOAD_DIR' to '$ARCHIVES_DIR'"
mkdir -p "$ARCHIVES_DIR"

ARCHIVE_NAME="$ARCHIVES_DIR/$now.tar.gz"

tar -czf "$ARCHIVE_NAME" -C "$DOWNLOAD_DIR" . 

echo ""$DONE_MSG" (archive file name: "$ARCHIVE_NAME")"

echo "> Bash script ending at: "$now""
echo "Bye!"