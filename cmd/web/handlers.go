package main

import (
	"net/http"
	"text/template"
)

func getHome(w http.ResponseWriter, r *http.Request) {
	t, err := template.ParseFiles("./assets/templates/home.page.html")
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	t.Execute(w, nil)
}
