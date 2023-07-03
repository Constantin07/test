package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

var port string = "8080" // default port to listen

func getRoot(w http.ResponseWriter, req *http.Request) {
	// Print headers
	for k, v := range req.Header {
		fmt.Printf("%v: %v\n", k, v)
	}
	w.Header().Set("Content-Type", "application/json")
	io.WriteString(w, "{\"status\": \"UP\"}\n")
}

func main() {
	if value, ok := os.LookupEnv("PORT"); ok {
		port = value
	}
	fmt.Printf("Starting server at port %s\n", port)

	http.HandleFunc("/", getRoot)

	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}
