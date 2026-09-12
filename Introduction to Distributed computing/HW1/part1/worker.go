package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"syscall"
)
func createFIFO(path string) bool {

	st, err := os.Stat(path)

	if err == nil {

		if (st.Mode() & os.ModeNamedPipe) == 0 {

			log.Printf("%s exists but is not a FIFO", path)

			return false
		}

		return true
	}

	err = syscall.Mkfifo(path, 0666)
	if err != nil {

		log.Printf("Could not create FIFO %s: %v", path, err)

		return false
	}

	return true
}

func openRequestPipe(path string) (*os.File, *bufio.Scanner, bool) {

	pipe, err := os.OpenFile(path, os.O_RDONLY, 0666)
	if err != nil {

		log.Println("ERROR: Cannot open request pipe")

		return nil, nil, false
	}

	reader := bufio.NewScanner(pipe)

	return pipe, reader, true
}

func openResponsePipe(path string) (*os.File, bool) {

	pipe, err := os.OpenFile(path, os.O_WRONLY, 0666)
	if err != nil {

		log.Println("ERROR: Cannot open response pipe")

		return nil, false
	}

	return pipe, true
}

func readRequest(reader *bufio.Scanner) (string, bool) {

	if !reader.Scan() {

		if reader.Err() != nil {

			log.Println("ERROR: Request pipe disconnected")

		} else {

			log.Println("ERROR: Interface disconnected")
		}

		return "", false
	}

	return reader.Text(), true
}

func sendResponse(pipe *os.File, message string) bool {

	_, err := pipe.WriteString(message + "\n")

	if err != nil {

		if strings.Contains(err.Error(), "broken pipe") {

			log.Println("ERROR: Interface closed unexpectedly")

		} else {

			log.Println("ERROR: Response pipe disconnected")
		}

		return false
	}

	return true
}
func evaluateParameters(req string) (string, bool) {

	parts := strings.Fields(req)

	if len(parts) != 3 {

		return "ERROR: Invalid arguments count", false
	}

	validOperations := []string{
		"ADD",
		"SUB",
		"MUL",
		"DIV",
        "MIN",
	}

	operation := parts[0]

	validOperation := false

	for _, op := range validOperations {

		if operation == op {

			validOperation = true

			break
		}
	}

	if !validOperation {

		return "ERROR: Invalid operation", false
	}

	_, err := strconv.Atoi(parts[1])
	if err != nil {

		return "ERROR: First argument is not a number", false
	}

	secondNumber, err := strconv.Atoi(parts[2])
	if err != nil {

		return "ERROR: Second argument is not a number", false
	}

	if operation == "DIV" && secondNumber == 0 {

		return "ERROR: Division by zero", false
	}

	return "", true
}

func calculateResponse(req string) string {

	parts := strings.Fields(req)

	operation := parts[0]

	firstNumber, _ := strconv.Atoi(parts[1])
	secondNumber, _ := strconv.Atoi(parts[2])

	var result int

	switch operation {

	case "ADD":
		result = firstNumber + secondNumber

	case "SUB":
		result = firstNumber - secondNumber

	case "MUL":
		result = firstNumber * secondNumber

	case "DIV":
		result = firstNumber / secondNumber
    case "MIN":

	    if firstNumber < secondNumber {
		    result = firstNumber
	    } else {
		    result = secondNumber
	    }

	}

	return fmt.Sprintf("RESULT: %d", result)
}

func processRequest(req string) string {

	return "OK received: " + strings.TrimSpace(req)
}

func connectToInterface(
	reqPipe string,
	resPipe string,
) (*os.File, *bufio.Scanner, *os.File) {

	for {

		req, reader, ok := openRequestPipe(reqPipe)
		if !ok {
			continue
		}

		res, ok := openResponsePipe(resPipe)
		if !ok {

			req.Close()

			continue
		}

		log.Println("Interface connected")

		return req, reader, res
	}
}

func communicationLoop(
	req *os.File,
	reader *bufio.Scanner,
	res *os.File,
) {

	for {

		request, ok := readRequest(reader)
		if !ok {

			req.Close()
			res.Close()

			return
		}


		message, ok := evaluateParameters(request)

		if ok {

			message = calculateResponse(request)
		}

		ok = sendResponse(res, message)
		if !ok {

			req.Close()
			res.Close()

			return
		}
	}
}


func main() {

	reqPipe := "/tmp/request.pipe"
	resPipe := "/tmp/response.pipe"

	if !createFIFO(reqPipe) {
		return
	}

	if !createFIFO(resPipe) {
		return
	}

	log.Println("Worker started...")

	for {

		req, reader, res := connectToInterface(
			reqPipe,
			resPipe,
		)

		communicationLoop(
			req,
			reader,
			res,
		)
	}
}
