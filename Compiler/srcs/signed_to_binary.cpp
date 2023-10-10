#include "../inc/ASM_to_MC.hpp"

std::string signed_to_binary(const std::string &decimalstr, int size)
{
    int         decimal = std::stoi(decimalstr);
    std::string binarystr;
    bool        isNegative = (decimal < 0) ? true : false;

    if (isNegative)
        decimal = -decimal;    
    while (decimal > 0)
    {
        binarystr = std::to_string(decimal % 2) + binarystr;
        decimal /= 2;
    }
    while (binarystr.size() < (size_t)size)
        binarystr = '0' + binarystr;    
    if (isNegative)
    {
        for (char& bit : binarystr)
            bit = (bit == '0') ? '1' : '0';        
        for (int i = binarystr.size() - 1; i >= 0; --i)
        {
            if (binarystr[i] == '0')
            {
                binarystr[i] = '1';
                break;
            }
            binarystr[i] = '0';
        }
    }
    return (binarystr);
}