package main

import (
	"log"
	"net"
	"net/rpc"
	"os"
	"path/filepath"
)

type GetFileArgs struct {
	Directory string
	Filename  string
}

type GetFileReply struct {
	Success bool
	Data    []byte
	Message string
}

type FileService struct{}

func (s *FileService) GetFile(args *GetFileArgs, reply *GetFileReply) error {
	log.Printf("Received file request: %s/%s", args.Directory, args.Filename)

	if args.Directory != "files" && args.Directory != "images" {
		reply.Success = false
		reply.Message = "Invalid directory specified"
		return nil
	}

	cleanPath := filepath.Clean(args.Filename)
	fullPath := filepath.Join(args.Directory, cleanPath)

	data, err := os.ReadFile(fullPath)
	if err != nil {
		reply.Success = false
		reply.Message = "File not found"
		return nil
	}

	reply.Success = true
	reply.Data = data
	reply.Message = "File retrieved successfully via RPC"
	return nil
}

func main() {
	log.Println("Starting File Server (VM3)...")

	fileService := new(FileService)
	rpc.Register(fileService)

	listener, err := net.Listen("tcp", ":8003")
	if err != nil {
		log.Fatalf("Listener error: %v", err)
	}

	log.Println("File RPC Service listening on port 8003...")
	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Printf("Accept error: %v", err)
			continue
		}
		go rpc.ServeConn(conn)
	}
}
