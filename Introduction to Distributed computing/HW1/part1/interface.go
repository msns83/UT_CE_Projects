package main

import (
	"bufio"
	"log"
	"os"
	"strings"
	"syscall"
	"time"
)

func readUserInput(scanner *bufio.Scanner) string {

	log.Print("Please write your operation: ")

	if !scanner.Scan() {
		return ""
	}

	return scanner.Text()
}

func evaluateCommand(line string) (string, bool) {

	parts := strings.Fields(line)

	if len(parts) != 3 {

		log.Println("ERROR: Invalid arguments count")

		return "", false
	}

	return line, true
}

func openRequestPipe(path string) (*os.File, bool) {

	pipe, err := os.OpenFile(
		path,
		os.O_WRONLY|syscall.O_NONBLOCK,
		0666,
	)

	if err != nil {

		if strings.Contains(err.Error(), "no such device or address") {

			log.Println("ERROR: Waiting for worker...")

		} else {

			log.Println("ERROR: Cannot open request pipe")
		}

		return nil, false
	}

	return pipe, true
}

func openResponsePipe(path string) (*os.File, *bufio.Scanner, bool) {

	pipe, err := os.OpenFile(path, os.O_RDONLY, 0666)
	if err != nil {

		log.Println("ERROR: Cannot open response pipe")

		return nil, nil, false
	}

	reader := bufio.NewScanner(pipe)

	return pipe, reader, true
}

func sendRequest(pipe *os.File, msg string) bool {

	_, err := pipe.WriteString(msg + "\n")

	if err != nil {

		if strings.Contains(err.Error(), "broken pipe") {

			log.Println("ERROR: Worker closed unexpectedly")

		} else {

			log.Println("ERROR: Request pipe disconnected")
		}

		return false
	}

	return true
}

func readResponse(reader *bufio.Scanner) (string, bool) {

	if !reader.Scan() {

		if reader.Err() != nil {

			log.Println("ERROR: Response pipe disconnected")

		} else {

			log.Println("ERROR: Worker disconnected")
		}

		return "", false
	}

	return reader.Text(), true
}

func connectToWorker(
	reqPipe string,
	resPipe string,
) (*os.File, *os.File, *bufio.Scanner) {

	for {

		req, ok := openRequestPipe(reqPipe)
		if !ok {

			time.Sleep(time.Second)

			continue
		}

		res, reader, ok := openResponsePipe(resPipe)
		if !ok {

			req.Close()

			time.Sleep(time.Second)

			continue
		}

		log.Println("Connected to worker")

		return req, res, reader
	}
}

func communicationLoop(
	req *os.File,
	res *os.File,
	reader *bufio.Scanner,
	input *bufio.Scanner,
) {

	for {

		line := readUserInput(input)

		if line == "" {
			continue
		}

		cmd, ok := evaluateCommand(line)
		if !ok {
			continue
		}

		ok = sendRequest(req, cmd)
		if !ok {

			req.Close()
			res.Close()

			return
		}

		response, ok := readResponse(reader)
		if !ok {

			req.Close()
			res.Close()

			return
		}

		log.Println(response)
	}
}

func main() {

	reqPipe := "/tmp/request.pipe"
	resPipe := "/tmp/response.pipe"

	input := bufio.NewScanner(os.Stdin)

	for {

		req, res, reader := connectToWorker(
			reqPipe,
			resPipe,
		)

		communicationLoop(
			req,
			res,
			reader,
			input,
		)

		log.Println("Reconnecting...")
	}
}
