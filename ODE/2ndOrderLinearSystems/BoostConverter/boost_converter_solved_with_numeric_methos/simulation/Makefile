CXX = g++

FLAGS = -std=c++14 -lboost_iostreams -lboost_system -lboost_filesystem

boost_converter: boost_converter.cpp
	$(CXX) $(FLAGS) $(INCLUDE) boost_converter.cpp -o $@

clean:
	$(RM) boost_converter