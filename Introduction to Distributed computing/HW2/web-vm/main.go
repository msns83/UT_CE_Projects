package main

import (
	"html/template"
	"log"
	"net/http"
	"net/rpc"
	"os"
	"runtime"
	"time"
	"bytes"
	"encoding/json"
    "strconv"
)

type LoginArgs struct {
	Username string
	Password string
}

type LoginReply struct {
	Success bool
	Message string
}

type GetFileArgs struct {
	Directory string
	Filename  string
}

type GetFileReply struct {
	Success bool
	Data    []byte
	Message string
}

type MemoryEvent struct {
	EventType  string `json:"event_type"`
	Service    string `json:"service"`
	MemoryMB   uint64 `json:"memory_mb"`
	Threshold  uint64 `json:"threshold_mb"`
	Timestamp  string `json:"timestamp"`
}

var loginTmpl = template.Must(template.ParseFiles("templates/login.html"))
var welcomeTmpl = template.Must(template.ParseFiles("templates/welcome.html"))
var memoryLeak [][]byte

func getEnv(key, fallback string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return fallback
}

func loginHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodGet {
		loginTmpl.Execute(w, nil)
		return
	}

	if r.Method == http.MethodPost {
		username := r.FormValue("username")
		password := r.FormValue("password")

		authIp := getEnv("AUTH_VM_IP", "127.0.0.1:8002")
		client, err := rpc.Dial("tcp", authIp)
		if err != nil {
			log.Printf("Failed to dial Auth VM: %v", err)
			loginTmpl.Execute(w, map[string]string{"Error": "Authentication service is down."})
			return
		}
		defer client.Close()

		args := LoginArgs{Username: username, Password: password}
		var reply LoginReply

		err = client.Call("AuthService.Login", &args, &reply)
		if err != nil {
			log.Printf("RPC Login Call failed: %v", err)
			loginTmpl.Execute(w, map[string]string{"Error": "Authentication service error."})
			return
		}

		if reply.Success {
			http.SetCookie(w, &http.Cookie{
				Name:  "session_token",
				Value: username,
				Path:  "/",
			})
			http.Redirect(w, r, "/", http.StatusFound)
		} else {
			loginTmpl.Execute(w, map[string]string{"Error": reply.Message})
		}
	}
}

func welcomeHandler(w http.ResponseWriter, r *http.Request) {
	cookie, err := r.Cookie("session_token")
	if err != nil || cookie.Value == "" {
		http.Redirect(w, r, "/login", http.StatusFound)
		return
	}

	welcomeTmpl.Execute(w, map[string]string{"Username": cookie.Value})
}

func fetchImageHandler(w http.ResponseWriter, r *http.Request) {
	_, err := r.Cookie("session_token")
	if err != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	fileIp := getEnv("FILE_VM_IP", "127.0.0.1:8003")
	client, err := rpc.Dial("tcp", fileIp)
	if err != nil {
		log.Printf("Failed to dial File VM: %v", err)
		http.Error(w, "File service down", http.StatusInternalServerError)
		return
	}
	defer client.Close()

	args := GetFileArgs{Directory: "images", Filename: "logo.png"}
	var reply GetFileReply

	err = client.Call("FileService.GetFile", &args, &reply)
	if err != nil || !reply.Success {
		log.Printf("RPC GetFile Call failed: %v | msg: %s", err, reply.Message)
		http.Error(w, "Could not fetch image", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "image/png")
	w.Write(reply.Data)
}

func logoutHandler(w http.ResponseWriter, r *http.Request) {
	http.SetCookie(w, &http.Cookie{
		Name:   "session_token",
		Value:  "",
		Path:   "/",
		MaxAge: -1,
	})
	http.Redirect(w, r, "/login", http.StatusFound)
}

func monitorMemory() {
	ticker := time.NewTicker(5 * time.Second)

	for range ticker.C {

		var m runtime.MemStats
		runtime.ReadMemStats(&m)

		usedMB := m.Alloc / 1024 / 1024

		if usedMB > 300 {
			publishMemoryAlert(usedMB)
		}
	}
}

func publishMemoryAlert(memoryMB uint64) {

	event := MemoryEvent{
		EventType: "HIGH_MEMORY_USAGE",
		Service:   "web-server",
		MemoryMB:  memoryMB,
		Threshold: 300,
		Timestamp: time.Now().Format(time.RFC3339),
	}

	body, _ := json.Marshal(event)

	subscriberIP := getEnv("SUBSCRIBER_IP", "127.0.0.1:9000")

	_, err := http.Post(
		"http://"+subscriberIP+"/event",
		"application/json",
		bytes.NewBuffer(body),
	)

	if err != nil {
		log.Printf("Publish error: %v", err)
	}
}

func consumeMemoryHandler(w http.ResponseWriter, r *http.Request) {

	mbStr := r.URL.Query().Get("mb")

	mb, err := strconv.Atoi(mbStr)
	if err != nil {
		http.Error(w, "invalid mb", http.StatusBadRequest)
		return
	}

	block := make([]byte, mb*1024*1024)

	memoryLeak = append(memoryLeak, block)
	log.Printf(
		"Allocated %d MB, total blocks=%d",
		mb,
		len(memoryLeak),
	)

	w.Write([]byte("Memory allocated successfully\n"))
}

func main() {
	http.HandleFunc("/", welcomeHandler)
	http.HandleFunc("/login", loginHandler)
	http.HandleFunc("/fetch-image", fetchImageHandler)
	http.HandleFunc("/logout", logoutHandler)
	http.HandleFunc("/consume-memory", consumeMemoryHandler)

	go monitorMemory()

	log.Println("Starting Web Service (VM1) on port 8000...")
	log.Fatal(http.ListenAndServe(":8000", nil))
}
