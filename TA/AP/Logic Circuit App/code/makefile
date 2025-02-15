COMPILER = g++ -std=c++20
OUTPUT = ModelSim.out
FILES = main.cpp interface.cpp circuit.cpp module.cpp gate.cpp properties.cpp
OBJECTS = $(FILES:%.cpp=Build/%.o)
FOLDER = mkdir -p Build

all: $(OUTPUT)

$(OUTPUT): $(OBJECTS)
	$(COMPILER) -o $(OUTPUT) $(OBJECTS)

Build/%.o: %.cpp
	$(FOLDER)
	$(COMPILER) -c $< -o $@

clean:
	rm -f Build/*.o $(OUTPUT)

.PHONY: all clean
