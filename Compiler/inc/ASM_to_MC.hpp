#ifndef ASM_TO_MC_HPP
# define ASM_TO_MC_HPP

# include <iostream>
# include <fstream>
# include <string>
# include <vector>
# include <array>
# include <algorithm>
# include <stdbool.h>
# include <bitset>

enum instruction_type { U, J, I_Jalr, B, I_Loads, S, I, I_Shifts, R, I_Atomic };

typedef struct s_isa
{
	std::string ins_name;
	std::string code;
} t_isa;

static std::vector<t_isa>	isa = \
{				//func7func3opcode
	{"lui",		"          0110111"}, // 0
	{"auipc",	"          0010111"}, // 1
	{"jal",		"          1101111"}, // 2
	{"jalr",	"       0001100111"}, // 3
	{"beq",		"       0001100011"}, // 4
	{"bne",		"       0011100011"}, // 5
	{"blt",		"       1001100011"}, // 6
	{"bge",		"       1011100011"}, // 7
	{"bltu",	"       1101100011"}, // 8
	{"bgeu",	"       1111100011"}, // 9
	{"lb",		"       0000000011"}, // 10
	{"lh",		"       0010000011"}, // 11
	{"lw",		"       0100000011"}, // 12
	{"lbu",		"       1000000011"}, // 13
	{"lhu", 	"       1010000011"}, // 14
	{"sb",		"       0000100011"}, // 15
	{"sh",		"       0010100011"}, // 16
	{"sw",		"       0100100011"}, // 17
	{"addi",	"       0000010011"}, // 18
	{"slti",	"       0100010011"}, // 19
	{"sltiu",	"       0110010011"}, // 20
	{"xori",	"       1000010011"}, // 21
	{"ori",		"       1100010011"}, // 22
	{"andi",	"       1110010011"}, // 23
	{"slli",	"00000000010010011"}, // 24
	{"srli",	"00000001010010011"}, // 25
	{"srai",	"01000001010010011"}, // 26
	{"add",		"00000000000110011"}, // 27
	{"sub",		"01000000000110011"}, // 28
	{"sll",		"00000000010110011"}, // 29
	{"slt",		"00000000100110011"}, // 30
	{"sltu",	"00000000110110011"}, // 31
	{"xor",		"00000001000110011"}, // 32
	{"srl",		"00000001010110011"}, // 33
	{"sra",		"01000001010110011"}, // 34
	{"or",		"00000001100110011"}, // 35
	{"and",		"00000001110110011"}, // 36
	{"csrrw",	"       0011110011"}, // 37
	{"csrrs",	"       0101110011"}, // 38
	{"csrrc",	"       0111110011"}, // 39
	{"csrrwi",	"       1011110011"}, // 40
	{"csrrsi",	"       1101110011"}, // 41
	{"csrrci",	"       1111110011"}  // 42
};

typedef struct s_instruction
{
	instruction_type		type;
	std::string				name;
	std::string				args;
	std::string				machine_code;

	s_instruction(const std::string &name, const std::string &args): \
	name(name), args(args), machine_code(std::string(32, '0'))
	{
		size_t	i;

		for (i = 0; i < isa.size(); i++)
			if (this->name == isa[i].ins_name)
				break;

		if ((i == 0) || (i == 1))
			this->type = U;
		else if (i == 2)
			this->type = J;
		else if (i == 3)
			this->type = I_Jalr;
		else if ((i >= 4) && (i <= 9))
			this->type = B;
		else if ((i >= 10) && (i <= 14))
			this->type = I_Loads;
		else if ((i >= 15) && (i <= 17))
			this->type = S;
		else if ((i >= 18) && (i <= 23))
			this->type = I;
		else if ((i >= 24) && (i <= 26))
			this->type = I_Shifts;
		else if ((i >= 27) && (i <= 36))
			this->type = R;
		else
			this->type = I_Atomic;
	}
} t_instruction;

void		open_files(char **argv, std::ifstream &asm_file, std::ofstream &mc_file);
void		generate_mc(t_instruction *ins);
std::string	signed_to_binary(const std::string &numberString, int size);

#endif
