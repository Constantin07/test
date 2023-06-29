package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"
)

var port string = "8080" // default port to listen

func getRoot(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("Request at %v\n", time.Now())
	for k, v := range r.Header {
		fmt.Printf("%v: %v\n", k, v)
	}
	io.WriteString(w, "OK\n")
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
