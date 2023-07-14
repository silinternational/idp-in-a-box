mkdir -p go-exe
go build -o go-exe ./cli/...
echo "If using a idp-cli.toml file, create it in the ./go-exe folder"
echo "Run '$ cd ./go-exe && ./cli multiregion help'"
