#MOGADOR

MOGADOR is genetic algorithm that can be used to generate good solutions to multi-objective corridor location problems. Within this repository, the algorithm has been implmented in the MATLAB intepreted programming environment for ease of use and inspection. It should primarily be considered of value in a teaching/learning context due to its single threaded execution and modest runtime performance. A newer, faster, and fully parallelized version of the algorithm has been implemented by the author using the Go programming language. This version should should be preferred for use in all serious real world corridor planning applications. 

The Go version of the algorithm is hosted at: github.com/ericdfournier/corridor 

## INSTALLATION

- Clone Git Repository: cd into a working directory of choice and clone the git repository via the following shell commands (on mac)

````bash
$ cd ~
$ git clone https://github.com/ericdfournier/MOGADOR.git
````

- Download and Unpack Zipped Git Repository: cd into a working directory of choice and unzip the zipped version of the repository downloaded from the project github page via the following shell commands (on mac)

````bash
$ mkdir ~/MOGADOR
$ cd ~/MOGADOR
$ unzip MOGADOR.zip
````

## DESCRIPTION

(MOGADOR) Multiobjective Genetic Algorithm for Corridor Location Problems

### PLATFORM

- MATLAB Version: 8.1.0.604 (R2013a)

### DEPENDENCIES

- Image Processing Toolbox                              Version 8.2
- Mapping Toolbox                                       Version 3.7
- Statistics Toolbox                                    Version 8.2

- Note: The GUI elements have been developed for use in a Mac OS X environment

### REFERENCES

- Zhang, X., & Armstrong, M. P. (2008). Genetic algorithms and the corridor location problem: multiple objectives and alternative solutions. Environment and Planning B: Planning and Design, 35(1), 148–168. doi:10.1068/b32167

### DETAILS

- Corridor planning often falls into the domain of multiobjective evaluation. MOGADOR is a multiobjective genentic algorithm for corridor location problems which produces a wide range of feasible corridor alternatives to help decision makers understand tradeoffs among competing objectives.