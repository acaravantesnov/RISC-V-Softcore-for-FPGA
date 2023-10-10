#include "../inc/ASM_to_MC.hpp"

void	generate_mc(t_instruction *ins)
{
	short							index_1, index_2;
	std::string						rd, imm, pcrel_21, rs1, rs2, pcrel_13, shamt, csr, rs1_or_zimm;
	std::vector<t_isa>::iterator	it;

	for (it = isa.begin(); it != isa.end(); it++)
		if (it->ins_name == ins->name)
			break;

	switch (ins->type)
	{
		case U:
			index_1 = ins->args.find(',');
			rd = ins->args.substr(0, index_1);
			if (rd[0] == 'x')
				rd = rd.substr(1);
			imm = ins->args.substr(index_1 + 2);
			
			ins->machine_code = signed_to_binary(imm, 20) + \
			signed_to_binary(rd, 5);
			if (ins->name == "lui")
				ins->machine_code += isa[0].code.substr(10);
			else if (ins->name == "auipc")
				ins->machine_code += isa[1].code.substr(10);
			break;
		case J:
			index_1 = ins->args.find(',');
			rd = ins->args.substr(0, index_1);
			if (rd[0] == 'x')
				rd = rd.substr(1);
			pcrel_21 = ins->args.substr(index_1 + 2);

			ins->machine_code = (signed_to_binary(pcrel_21, 21))[0] + \
			signed_to_binary(pcrel_21, 21).substr(10, 10) + \
			(signed_to_binary(pcrel_21, 21))[9] + \
			signed_to_binary(pcrel_21, 21).substr(1, 8) + \
			signed_to_binary(rd, 5) + isa[2].code.substr(10);
			break;
		case I_Jalr:
			index_1 = ins->args.find(',');
			rd = ins->args.substr(0, index_1);
			if (rd[0] == 'x')
				rd = rd.substr(1);
			index_2 = (ins->args.substr(index_1 + 1)).find('(');
			imm = ins->args.substr(index_1 + 2, index_2 - index_1 + 2);
			rs1 = ins->args.substr(index_1 + index_2 + 3, \
			ins->args.length() - (index_1 + index_2) - 4);
			if (rs1[0] == 'x')
				rs1 = rs1.substr(1);
			
			ins->machine_code = signed_to_binary(imm, 12) + \
			signed_to_binary(rs1, 5) + isa[3].code.substr(7, 3) + \
			signed_to_binary(rd, 5) + isa[3].code.substr(10);
			break;
		case B:
			index_1 = ins->args.find(',');
			rs1 = ins->args.substr(0, index_1);
			if (rs1[0] == 'x')
				rs1 = rs1.substr(1);
			index_2 = (ins->args.substr(index_1 + 1)).find(',');
			rs2 = ins->args.substr(index_1 + 2, index_2 - index_1 + 2);
			if (rs2[0] == 'x')
				rs2 = rs2.substr(1);
			pcrel_13 = ins->args.substr(index_1 + index_2 + 3);

			ins->machine_code = (signed_to_binary(pcrel_13, 13))[0] + \
			(signed_to_binary(pcrel_13, 13)).substr(2, 6) + \
			signed_to_binary(rs2, 5) + \
			signed_to_binary(rs1, 5);
			
			if (ins->name == "beq")
				ins->machine_code += isa[4].code.substr(7, 3);
			else if (ins->name == "bne")
				ins->machine_code += isa[5].code.substr(7, 3);
			else if (ins->name == "blt")
	      		ins->machine_code += isa[6].code.substr(7, 3);
			else if (ins->name == "bge")
  	    		ins->machine_code += isa[7].code.substr(7, 3);
			else if (ins->name == "bltu")
    	  		ins->machine_code += isa[8].code.substr(7, 3);
			else if (ins->name == "bgeu")
    			ins->machine_code += isa[9].code.substr(7, 3);

			ins->machine_code += (signed_to_binary(pcrel_13, 13)).substr(8, 4) + \
			(signed_to_binary(pcrel_13, 13))[1] + "1100011";
			break;
		case I_Loads:
			index_1 = ins->args.find(',');
			rd = ins->args.substr(0, index_1);
			if (rd[0] == 'x')
				rd = rd.substr(1);
			index_2 = (ins->args.substr(index_1 + 1)).find('(');
			imm = ins->args.substr(index_1 + 2, index_2 - index_1 + 2);
			rs1 = ins->args.substr(index_1 + index_2 + 3, \
			ins->args.length() - (index_1 + index_2) - 4);
			if (rs1[0] == 'x')
				rs1 = rs1.substr(1);

			ins->machine_code = signed_to_binary(imm, 12) + \
			signed_to_binary(rs1, 5);

			if (ins->name == "lb")
				ins->machine_code += isa[10].code.substr(7, 3);
 			else if (ins->name == "lh")
 				ins->machine_code += isa[11].code.substr(7, 3);
 			else if (ins->name == "lw")
 				ins->machine_code += isa[12].code.substr(7, 3);
 			else if (ins->name == "lbu")
 				ins->machine_code += isa[13].code.substr(7, 3);
 			else if (ins->name == "lhu")
 				ins->machine_code += isa[14].code.substr(7, 3);

			ins->machine_code += signed_to_binary(rd, 5) + "0000011";
			break;
		case S:
			index_1 = ins->args.find(',');
			rs2 = ins->args.substr(0, index_1);
			if (rs2[0] == 'x')
				rs2 = rs2.substr(1);
			index_2 = (ins->args.substr(index_1 + 1)).find('(');
			imm = ins->args.substr(index_1 + 2, index_2 - index_1 + 2);
			rs1 = ins->args.substr(index_1 + index_2 + 3, \
			ins->args.length() - (index_1 + index_2) - 4);
			if (rs1[0] == 'x')
				rs1 = rs1.substr(1);

			ins->machine_code = \
			signed_to_binary(imm, 12).substr(0, 7) + \
			signed_to_binary(rs2, 5) + \
			signed_to_binary(rs1, 5);

			if (ins->name == "sb")
 				ins->machine_code += isa[15].code.substr(7, 3);
 			else if (ins->name == "sh")
 				ins->machine_code += isa[16].code.substr(7, 3);
 			else if (ins->name == "sw")
 				ins->machine_code += isa[17].code.substr(7, 3);

			ins->machine_code += signed_to_binary(imm, 12).substr(7) + "0100011";
			break;
		case I:
			index_1 = ins->args.find(',');
			rd = ins->args.substr(0, index_1);
			if (rd[0] == 'x')
				rd = rd.substr(1);
			index_2 = (ins->args.substr(index_1 + 1)).find(',');
			rs1 = ins->args.substr(index_1 + 2, index_2 - index_1 + 2);
			if (rs1[0] == 'x')
				rs1 = rs1.substr(1);
			imm = ins->args.substr(index_1 + index_2 + 3);

			ins->machine_code = signed_to_binary(imm, 12) + \
			signed_to_binary(rs1, 5);
			
			if (ins->name == "addi")
				ins->machine_code += isa[18].code.substr(7, 3);
			else if (ins->name == "slti")
 				ins->machine_code += isa[19].code.substr(7, 3);
 			else if (ins->name == "sltiu")
 				ins->machine_code += isa[20].code.substr(7, 3);
			else if (ins->name == "xori")
				ins->machine_code += isa[21].code.substr(7, 3);
			else if (ins->name == "ori")
				ins->machine_code += isa[22].code.substr(7, 3);
			else if (ins->name == "andi")
				ins->machine_code += isa[23].code.substr(7, 3);

			ins->machine_code += signed_to_binary(rd, 5) + "0010011";
			break;
		case I_Shifts:
			index_1 = ins->args.find(',');
			rd = ins->args.substr(0, index_1);
			if (rd[0] == 'x')
				rd = rd.substr(1);
			index_2 = (ins->args.substr(index_1 + 1)).find(',');
			rs1 = ins->args.substr(index_1 + 2, index_2 - index_1 + 2);
			if (rs1[0] == 'x')
				rs1 = rs1.substr(1);
			shamt = ins->args.substr(index_1 + index_2 + 3);

			if (ins->name == "srai")
				ins->machine_code = "0100000";
			else
				ins->machine_code = "0000000";

			ins->machine_code += signed_to_binary(shamt, 5) + \
			signed_to_binary(rs1, 5);

			if (ins->name == "slli")
				ins->machine_code += "001";
			else
				ins->machine_code += "101";

			ins->machine_code += signed_to_binary(rd, 5) + "0010011";
			break;
		case R:
			index_1 = ins->args.find(',');
			rd = ins->args.substr(0, index_1);
			if (rd[0] == 'x')
				rd = rd.substr(1);
			index_2 = (ins->args.substr(index_1 + 1)).find(',');
			rs1 = ins->args.substr(index_1 + 2, index_2 - index_1 + 2);
			if (rs1[0] == 'x')
				rs1 = rs1.substr(1);
			rs2 = ins->args.substr(index_1 + index_2 + 3);
			if (rs2[0] == 'x')
				rs2 = rs2.substr(1);

			if ((ins->name == "sub") || (ins->name == "sra"))
				ins->machine_code = "0100000";
			else
				ins->machine_code = "0000000";

			ins->machine_code += signed_to_binary(rs2, 5) + \
			signed_to_binary(rs1, 5);

			if (ins->name == "add")
				ins->machine_code += isa[27].code.substr(7, 3);
			else if (ins->name == "sub")
				ins->machine_code += isa[28].code.substr(7, 3);
			else if (ins->name == "sll")
				ins->machine_code += isa[29].code.substr(7, 3);
			else if (ins->name == "slt")
				ins->machine_code += isa[30].code.substr(7, 3);
			else if (ins->name == "sltu")
				ins->machine_code += isa[31].code.substr(7, 3);
			else if (ins->name == "xor")
				ins->machine_code += isa[32].code.substr(7, 3);
			else if (ins->name == "srl")
				ins->machine_code += isa[33].code.substr(7, 3);
			else if (ins->name == "sra")
				ins->machine_code += isa[34].code.substr(7, 3);
			else if (ins->name == "or")
				ins->machine_code += isa[35].code.substr(7, 3);
			else if (ins->name == "and")
				ins->machine_code += isa[36].code.substr(7, 3);

			ins->machine_code += signed_to_binary(rd, 5) + "0110011";
			break;
		case I_Atomic:
			index_1 = ins->args.find(',');
			rd = ins->args.substr(0, index_1);
			if (rd[0] == 'x')
				rd = rd.substr(1);
			index_2 = (ins->args.substr(index_1 + 1)).find(',');
			csr = ins->args.substr(index_1 + 2, index_2 - index_1 + 2);
			if (csr[0] == 'x')
				csr = csr.substr(1);
			rs1_or_zimm = ins->args.substr(index_1 + index_2 + 3);
			if (rs1_or_zimm[0] == 'x')
				rs1_or_zimm = rs1_or_zimm.substr(1);

			ins->machine_code = signed_to_binary(csr, 12) + \
			signed_to_binary(rs1_or_zimm, 5);

			if (ins->name == "csrrw")
				ins->machine_code += isa[37].code.substr(7, 3);
			else if (ins->name == "csrrs")
				ins->machine_code += isa[38].code.substr(7, 3);
			else if (ins->name == "csrrc")
				ins->machine_code += isa[39].code.substr(7, 3);
			else if (ins->name == "csrrwi")
				ins->machine_code += isa[40].code.substr(7, 3);
			else if (ins->name == "csrrsi")
				ins->machine_code += isa[41].code.substr(7, 3);
			else if (ins->name == "csrrci")
				ins->machine_code += isa[42].code.substr(7, 3);

			ins->machine_code += signed_to_binary(rd, 5) + "1110011";
			break;
		default:
			break;
	}
}
