package main

import (
	"encoding/json"
	"log"
	"net"
	"net/rpc"
	"os"

	"golang.org/x/crypto/bcrypt"
)

type User struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

var userStore = map[string]string{}

func loadUsers() {
	data, err := os.ReadFile("users.json")
	if err != nil {
		log.Fatalf("Failed to read users.json: %v", err)
	}
	var users []User
	if err := json.Unmarshal(data, &users); err != nil {
		log.Fatalf("Failed to parse users.json: %v", err)
	}

	for _, u := range users {
		userStore[u.Username] = u.Password
	}
	log.Printf("Loaded %d users into memory.", len(users))
}

type LoginArgs struct {
	Username string
	Password string
}

type LoginReply struct {
	Success bool
	Message string
}

type AuthService struct{}

func (s *AuthService) Login(args *LoginArgs, reply *LoginReply) error {
	log.Printf("Received login attempt for user: %s", args.Username)
	
	hashedPassword, exists := userStore[args.Username]
	if !exists {
		reply.Success = false
		reply.Message = "User not found"
		return nil
	}

	err := bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(args.Password))
	if err != nil {
		reply.Success = false
		reply.Message = "Invalid credentials"
		return nil
	}

	reply.Success = true
	reply.Message = "Login successful"
	return nil
}

func main() {
	log.Println("Starting Auth Service (VM2)...")
	loadUsers()

	authService := new(AuthService)
	rpc.Register(authService)

	listener, err := net.Listen("tcp", ":8002")
	if err != nil {
		log.Fatalf("Listener error: %v", err)
	}
	
	log.Println("Auth RPC Service listening on port 8002...")
	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Printf("Accept error: %v", err)
			continue
		}
		go rpc.ServeConn(conn)
	}
}
