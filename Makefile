# Makefile for the notex editor featuring autodepend
# Use this answer to learn more: http://stackoverflow.com/a/30142139

SHELL = /bin/sh
CXX := g++
CXXFLAGS := -std=c++17 -Wall -g -L$(SFML_LIB) -I$(SFML_HEADERS)
# -std=c++17  	- Use C++17 standard
# -Wall  		- turns on most compiler warnings
# -g     		- adds debug information to the executable

# SFML configuration
SFML_VERSION=2.5.1
SFML_LIB=/usr/local/lib/SFML-$(SFML_VERSION)/lib
SFML_HEADERS=/usr/local/lib/SFML-$(SFML_VERSION)/include

srcdir := ./src
bindir := ./bin

APPNAME := notex
INCLUDES := -I$(srcdir)/header/
LDLIBS := -lsfml-graphics -lsfml-window -lsfml-system

# List of all .cpp source files from the directory specified in $srcdir
srcfiles := $(wildcard $(srcdir)/*.cpp)

# All .o files go to the bin directory
objfiles := $(srcfiles:%.cpp=$(bindir)/%.o)

# Gcc/Clang will create these .d files containing dependencies.
DEP = $(objfiles:%.o=%.d)

#Build the app specified in APPNAME for the "all" or "default" target
all: $(APPNAME)
default: $(APPNAME)
$(APPNAME): $(bindir)/$(APPNAME)		# Default target named after the binary



# Actual target of the binary - depends on all .o files.
$(bindir)/$(APPNAME) : $(objfiles)
# Create build directories - same structure as sources.
	@mkdir -p $(@D)
# Just link all the object files.
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDLIBS)

# Include all .d files
-include $(DEP)

# Build target for every single object file.
# The potential dependency on header files is covered
# by calling `-include $(DEP)`.
$(bindir)/%.o : %.cpp
	@mkdir -p $(@D)
# The -MMD flags additionaly creates a .d file with
# the same name as the .o file.
	$(CXX) $(CXXFLAGS) $(INCLUDES) -MMD -c $< -I src/ -o $@



echo: 									#Print source files
	@echo -e "\nSource files"
	@echo $(srcfiles)
	@echo -e "\nObject files"
	@echo $(objfiles)
	@echo -e ""

install:
	cp -rf bin $(DESTDIR)
	
.PHONY : clean
clean:
	rm -f $(bindir)/$(APPNAME)
	rm -f $(bindir)/$(srcdir)/*
	rm -fd $(bindir)/$(srcdir)
