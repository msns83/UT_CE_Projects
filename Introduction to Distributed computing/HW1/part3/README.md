### 1. Build the Docker Image
Run the following command in the project directory to build the Docker image:

```bash
docker build -t go-calculator-service .
```

---

### 2. Run the Docker Container

```bash
docker run -p 8080:8080 go-calculator-service
```

This command starts the container and maps **port 8080** of the container to **port 8080 on the host**.

---

### 3. Port Used

The service runs on:

```
Port: 8080
```

Inside the container the application listens on:

```
http://localhost:8080
```

---

### 4. Connecting from Host to VM

If Docker is running inside a **Virtual Machine**, you can access the service from the host using the VM's IP address.

Example:

```
http://<VM-IP>:8080
```

Example:

```
http://192.168.56.101:8080
```

---

### 5. Example curl Commands

Health check:

```bash
curl http://localhost:8080/health
```

Addition example:

```bash
curl "http://localhost:8080/compute?op=add&a=5&b=3"
```

Subtraction example:

```bash
curl "http://localhost:8080/compute?op=sub&a=10&b=4"
```

Multiplication example:

```bash
curl "http://localhost:8080/compute?op=mul&a=6&b=7"
```

Division example:

```bash
curl "http://localhost:8080/compute?op=div&a=20&b=5"
```