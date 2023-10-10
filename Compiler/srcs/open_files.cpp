#include "../inc/ASM_to_MC.hpp"

void open_files(char **argv, std::ifstream &asm_file, std::ofstream &mc_file)
{
	std::string argv1;
	std::string asm_file_name;

	argv1 = std::string(argv[1]);
	asm_file.open(argv1, std::ios::in);
	if (asm_file.fail() || (argv1.find(".s") == std::string::npos))
		exit (1);
	if (argv1.find("/") != std::string::npos)
		asm_file_name = \
		argv1.substr(argv1.find_last_of("/"), argv1.find(".s") - argv1.find_last_of("/"));
	else
		asm_file_name = argv1.substr(0, argv1.find(".s"));
	mc_file.open("tests/mc_files/" + asm_file_name + ".mem", \
	std::ios::out | std::ios::trunc);
}
