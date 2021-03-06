# swipl: load_foreign_library(foreign('cvio.so')).

SRCDIR = .
LIBSDIR = ../../libs
INCLUDEDIR = ../../include
SRCFILES = $(shell find $(SRCDIR) -name "*.cpp")
OBJFILES = $(patsubst %.cpp,%.o,$(SRCFILES))

CXX = g++
MAKE = make
CXXFLAGS = -Wall -std=c++11 -fPIC $(INCLUDE) $(COFLAGS)
COFLAGS = -gdwarf-2 -g3 -O0
LDFLAGS = -Wall -fPIC $(LIBS) $(COFLAGS)
INCLUDE = -I$(SRCDIR) -I$(INCLUDEDIR)
LIBS = -lm -L$(SRCDIR) -L$(LIBSDIR)

# SWI-prolog
CXXFLAGS_SWI = `pkg-config --cflags swipl`
LDFLAGS_SWI = `pkg-config --libs swipl`

# Opencv
CXXFLAGS_CV = `pkg-config --cflags opencv`
LDFLAGS_CV = `pkg-config --libs opencv`

# Armadillo
LDFLAGS_ARMA = -larmadillo

# Qt5
CXXFLAGS_QT = `pkg-config --cflags Qt5Gui`
LDFLAGS_QT = `pkg-config --libs Qt5Gui`

all:cvio.so cvsampler.so cvdraw.so cvatari.so
	mv *.so $(LIBSDIR)/

atari:cvatari.so lv_utils.so
	mv *.so $(LIBSDIR)/


cvio.so:cvio.o
	$(CXX) -shared $(LIBS) cvio.o -o cvio.so $(LDFLAGS_CV) $(LDFLAGS_SWI) $(LDFLAGS_QT)

cvio.o:
	$(CXX) -shared $(CXXFLAGS) $(CXXFLAGS_CV) $(CXXFLAGS_SWI) $(CXXFLAGS_QT) -c cvio.cpp

cvsampler.so:cvsampler.o
	$(CXX) -shared $(LIBS) cvsampler.o -o cvsampler.so $(LDFLAGS_CV) $(LDFLAGS_SWI) $(LDFLAGS_QT) $(LDFLAGS_ARMA)

cvsampler.o:
	$(CXX) -shared $(CXXFLAGS) $(CXXFLAGS_CV) $(CXXFLAGS_SWI) $(CXXFLAGS_QT) -c cvsampler.cpp

cvdraw.so:cvdraw.o
	$(CXX) -shared $(LIBS) cvdraw.o -o cvdraw.so $(LDFLAGS_CV) $(LDFLAGS_SWI) $(LDFLAGS_QT)

cvdraw.o:
	$(CXX) -shared $(CXXFLAGS) $(CXXFLAGS_CV) $(CXXFLAGS_SWI) $(CXXFLAGS_QT) -c cvdraw.cpp

cvatari.so:cvatari.o
	$(CXX) -shared $(LIBS) cvatari.o -o cvatari.so $(LDFLAGS_CV) $(LDFLAGS_SWI) $(LDFLAGS_QT)

cvatari.o:
	$(CXX) -shared $(CXXFLAGS) $(CXXFLAGS_CV) $(CXXFLAGS_SWI) $(CXXFLAGS_QT) -c cvatari.cpp

lv_utils.so:lv_utils.o
	$(CXX) -shared $(LIBS) lv_utils.o -o lv_utils.so $(LDFLAGS_CV) $(LDFLAGS_SWI) $(LDFLAGS_QT)

lv_utils.o:
	$(CXX) -shared $(CXXFLAGS) $(CXXFLAGS_CV) $(CXXFLAGS_SWI) $(CXXFLAGS_QT) -c lv_utils.cpp

clean:
	rm -rf *.o *.so
	rm ../../libs/cv*.so

