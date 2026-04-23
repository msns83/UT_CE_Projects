CXX       = g++
CXXFLAGS  = -std=c++17
TARGETS   = extract_transform load calculation output pipeline

.PHONY: all clean

all: $(TARGETS)

extract_transform: extract_transform.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

load: load.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

calculation: calculation.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

output: output.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

pipeline: main.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

clean:
	rm -f $(TARGETS)
