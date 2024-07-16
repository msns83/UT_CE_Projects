COMPILER := g++ -std=c++20

SOURCE := ./Source
COMMAND := ./Source/Command
BUILD := ./Build

SRC_FILES := $(wildcard $(SOURCE)/*.cpp) $(wildcard $(COMMAND)/*.cpp)
OBJ_FILES := $(patsubst $(SOURCE)/%.cpp,$(BUILD)/%.o,$(SRC_FILES))
PROGRAM := sputify.out

$(PROGRAM): $(OBJ_FILES)
	$(COMPILER) -o $@ $^

$(BUILD)/%.o: $(SOURCE)/%.cpp $(SOURCE)/%.hpp
	mkdir -p $(dir $@)
	$(COMPILER) -c -o $@ $<

$(BUILD)/%.o: $(COMMAND)/%.cpp $(COMMAND)/%.hpp
	mkdir -p $(dir $@)
	$(COMPILER) -c -o $@ $<

$(BUILD)/main.o: $(SOURCE)/main.cpp
	mkdir -p $(dir $@)
	$(COMPILER) -c -o $@ $<

clean:
	rm -rf $(BUILD) $(PROGRAM)

run:
	./$(PROGRAM) < ./Import/test4.txt > ./Import/out.txt
	diff ./Import/answer4.txt ./Import/out.txt
	

