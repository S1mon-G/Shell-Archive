now=$(date +"%Y-%m-%dT%H:%M:%S.%3N%z")
echo "Bash script starting at: $now" 

echo "Script full path: '$(realpath run.sh)'"

temp_dir="temp_dir.temp"
[ -d "$temp_dir" ] && rm -rf "$temp_dir"
mkdir -p "$temp_dir"
