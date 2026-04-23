CXX := g++
CXXFLAGS := -std=c++20

CLIENT_SRC := client_src
SERVER_SRC := server_src
OBJECTS_DIR := objects

CLIENT_BIN := client
SERVER_BIN := server

CLIENT_SRCS := $(wildcard $(CLIENT_SRC)/*.cpp)
SERVER_SRCS := $(wildcard $(SERVER_SRC)/*.cpp)

CLIENT_OBJS := $(patsubst $(CLIENT_SRC)/%.cpp, $(OBJECTS_DIR)/%.o, $(CLIENT_SRCS))
SERVER_OBJS := $(patsubst $(SERVER_SRC)/%.cpp, $(OBJECTS_DIR)/%.o, $(SERVER_SRCS))

all: $(CLIENT_BIN) $(SERVER_BIN)

$(OBJECTS_DIR):
	mkdir -p $(OBJECTS_DIR)

$(CLIENT_BIN): $(OBJECTS_DIR) $(CLIENT_OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $(CLIENT_OBJS)

$(SERVER_BIN): $(OBJECTS_DIR) $(SERVER_OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $(SERVER_OBJS)

$(OBJECTS_DIR)/%.o: $(CLIENT_SRC)/%.cpp | $(OBJECTS_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(OBJECTS_DIR)/%.o: $(SERVER_SRC)/%.cpp | $(OBJECTS_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

clean:
	rm -f $(CLIENT_BIN) $(SERVER_BIN) $(CLIENT_OBJS) $(SERVER_OBJS)
	rm -rf $(OBJECTS_DIR)

.PHONY: all clean
