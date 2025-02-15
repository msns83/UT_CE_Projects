COMPILER = g++
COMPILER_FLAGS = -std=c++20
SOURCES = $(wildcard ./Source/*.cpp)
HEADERS = $(wildcard ./Source/*.hpp)
OBJECT_FILES = $(patsubst ./Source/%.cpp,./Build/%.o,$(SOURCES))
PROGRAM = ImageEditor

$(PROGRAM): $(OBJECT_FILES)
	$(COMPILER) $(COMPILER_FLAGS) -o $(PROGRAM) $(OBJECT_FILES)

./Build/%.o: ./Source/%.cpp $(HEADERS)
	$(COMPILER) $(COMPILER_FLAGS) -c $< -o $@

clean:
	rm -f $(OBJECT_FILES) $(PROGRAM)
sharp:
	./$(PROGRAM) -S < ./Import/input.txt
blur:
	./$(PROGRAM) -B < ./Import/input.txt
embos:
	./$(PROGRAM) -E < ./Import/input.txt
invert:
	./$(PROGRAM) -I < ./Import/input.txt
black:
	./$(PROGRAM) -G  < ./Import/input.txt
blurr:
	./$(PROGRAM) -B -B -B -B -B -B -B < ./Import/input.txt
emboss:
	./$(PROGRAM) -G 100:100:150:150 -I 250:250:50:50 -E < ./Import/input.txt