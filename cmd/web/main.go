package main

import (
	"log"
	"net/http"
)

func main() {
	srv := http.Server{
		Addr:    ":8000",
		Handler: routes(),
	}

	log.Println("Listening on localhost:8000")
	srv.ListenAndServe()
}
