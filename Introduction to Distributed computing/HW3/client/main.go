package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
)

func main() {
	if len(os.Args) < 2 {
		printHelp()
		os.Exit(1)
	}

	command := os.Args[1]
	switch command {
	case "put":
		if len(os.Args) < 5 {
			fmt.Println("Usage: go run main.go put <key> <value> <host:port>")
			os.Exit(1)
		}
		put(os.Args[2], os.Args[3], os.Args[4])
	case "get":
		if len(os.Args) < 4 {
			fmt.Println("Usage: go run main.go get <key> <host:port>")
			os.Exit(1)
		}
		get(os.Args[2], os.Args[3])
	case "help":
		printHelp()
	default:
		fmt.Printf("Unknown command: %s\n", command)
		printHelp()
		os.Exit(1)
	}
}

func printHelp() {
	fmt.Println("Distributed Key-Value Store Client")
	fmt.Println()
	fmt.Println("Usage:")
	fmt.Println("  go run main.go put <key> <value> <host:port>   - Store a key-value pair")
	fmt.Println("  go run main.go get <key> <host:port>            - Retrieve a value by key")
	fmt.Println("  go run main.go help                             - Show this help message")
	fmt.Println()
	fmt.Println("Examples:")
	fmt.Println("  go run main.go put x 10 localhost:8001")
	fmt.Println("  go run main.go get x localhost:8002")
}

func put(key, value, addr string) {
	reqBody, _ := json.Marshal(map[string]string{
		"key":   key,
		"value": value,
	})

	req, err := http.NewRequest(http.MethodPut, "http://"+addr+"/put", bytes.NewReader(reqBody))
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}
	req.Header.Set("Content-Type", "application/json")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)
	var result map[string]interface{}
	json.Unmarshal(body, &result)

	if success, ok := result["success"].(bool); ok && success {
		fmt.Printf("PUT %s=%s to %s: OK\n", key, value, addr)
	} else {
		errMsg := ""
		if e, ok := result["error"].(string); ok {
			errMsg = ": " + e
		}
		fmt.Printf("PUT %s=%s to %s: FAILED%s\n", key, value, addr, errMsg)
	}
}

func get(key, addr string) {
	resp, err := http.Get("http://" + addr + "/get?key=" + key)
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)
	var result map[string]interface{}
	json.Unmarshal(body, &result)

	if e, ok := result["error"].(string); ok && strings.TrimSpace(e) != "" {
		fmt.Printf("GET %s from %s: %s\n", key, addr, e)
	} else {
		fmt.Printf("GET %s from %s: value=%v version=%v\n", key, addr, result["value"], result["version"])
	}
}
