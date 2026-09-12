package main

import (
	"encoding/json"
	"net/http"
	"strconv"
	"errors"
)

type Response struct {
	Operation string  `json:"operation"`
	A         float64 `json:"a"`
	B         float64 `json:"b"`
	Result    float64 `json:"result"`
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("service is healthy"))
}

func isGetMethod(r *http.Request) bool {
	return r.Method == http.MethodGet
}

func parseRequest(r *http.Request) (string, float64, float64, error) {
	op := r.URL.Query().Get("op")
	aStr := r.URL.Query().Get("a")
	bStr := r.URL.Query().Get("b")

	if op == "" || aStr == "" || bStr == "" {
		return "", 0, 0, errors.New("missing parameters")
	}

	a, err := strconv.ParseFloat(aStr, 64)
	if err != nil {
		return "", 0, 0, errors.New("a must be number")
	}

	b, err := strconv.ParseFloat(bStr, 64)
	if err != nil {
		return "", 0, 0, errors.New("b must be number")
	}

	return op, a, b, nil
}

func calculate(op string, a, b float64) (float64, error) {
	switch op {
	case "add":
		return a + b, nil

	case "sub":
		return a - b, nil

	case "mul":
		return a * b, nil

	case "div":
		if b == 0 {
			return 0, errors.New("division by zero")
		}
		return a / b, nil

	default:
		return 0, errors.New("invalid operation")
	}
}

func writeJSON(w http.ResponseWriter, data any) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(data)
}

func computeHandler(w http.ResponseWriter, r *http.Request) {
	if !isGetMethod(r) {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	op, a, b, err := parseRequest(r)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	result, err := calculate(op, a, b)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	response := Response{
		Operation: op,
		A:         a,
		B:         b,
		Result:    result,
	}

	writeJSON(w, response)
}


func main() {

	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/compute", computeHandler)

	http.ListenAndServe(":8080", nil)
}
