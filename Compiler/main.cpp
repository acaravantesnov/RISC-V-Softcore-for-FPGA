#include "inc/ASM_to_MC.hpp"

int main(int argc, char **argv)
{
	std::vector<t_instruction> instructions;
	std::vector<t_instruction>::iterator ins_it;
	std::ifstream asm_file;
	std::ofstream mc_file;
	std::string line, args;

	if (argc != 2)
		return (1);
	open_files(argv, asm_file, mc_file);
	while (getline(asm_file, line))
		instructions.push_back(t_instruction(line.substr(0, line.find(" ")), \
		line.substr(line.find(" ") + 1)));
	for (ins_it = instructions.begin(); ins_it != instructions.end(); ins_it++)
	{
		generate_mc(&(*ins_it));
		mc_file << ins_it->machine_code << std::endl;
	}
	asm_file.close();
	mc_file.close();
	return (0);
}

