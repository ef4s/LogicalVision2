all:
	cd src && make && cd ..
	
atari:
	cd src && make atari && cd ..

clean:
	cd src && make clean && cd ..
