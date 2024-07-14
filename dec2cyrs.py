import argparse

def dec2cyrs(input_number, use_titlo=False):
    if not 1 <= input_number <= 9999999999:
         raise ValueError("The number must be from 1 to 9999999999")
    cyrillic_symbols = {
        1000000000: ["а꙲", "в꙲", "г꙲", "д꙲", "е꙲", "ѕ꙲", "з꙲", "и꙲", "ѳ꙲"],
        100000000: ["а꙱", "в꙱", "г꙱", "д꙱", "е꙱", "ѕ꙱", "з꙱", "и꙱", "ѳ꙱"],
        10000000: ["а꙰", "в꙰", "г꙰", "д꙰", "е꙰", "ѕ꙰", "з꙰", "и꙰", "ѳ꙰"],
        1000000: ["а҉", "в҉", "г҉", "д҉", "е҉", "ѕ҉", "з҉", "и҉", "ѳ҉"],
        100000: ["а҈", "в҈", "г҈", "д҈", "е҈", "ѕ҈", "з҈", "и҈", "ѳ҈"],
        10000: ["а⃝", "в⃝", "г⃝", "д⃝", "е⃝", "ѕ⃝", "з⃝", "и⃝", "ѳ⃝"],
        1000: ["҂а", "҂в", "҂г", "҂д", "҂є", "҂ѕ", "҂з", "҂и", "҂ѳ"],
        100: "рстуфхѱѡц",
        10: "іклмнѯѻпч",
        1: "авгдєѕзиѳ"
    }
    result = ""
    
    for divisor, symbols in cyrillic_symbols.items():
        quotient, input_number = divmod(input_number, divisor)
        if quotient > 0:
            if isinstance(symbols, list):
                if quotient <= len(symbols):
                    result += symbols[quotient - 1]
                else:
                    result += symbols[-1] * quotient
            elif divisor == 10 and 1 <= quotient <= 9:
                tens = symbols[quotient - 1]
                ones = cyrillic_symbols[1][input_number - 1] if input_number > 0 else ""
                if 11 <= (quotient * 10 + input_number) <= 19:
                    result += ones + tens
                else:
                    result += tens + ones
                break
            else:
                result += symbols[quotient - 1]
    
    if use_titlo:
        titlo = "҃"
        if len(result) == 1:
            result = result + titlo
        else:
            result = result[:-1] + titlo + result[-1]
    
    return result

def main():
    parser = argparse.ArgumentParser(description="Convert decimal numbers to Cyrillic numerals")
    parser.add_argument("number", type=int, help="The number to convert")
    parser.add_argument("-t", "--titlo", action="store_true", help="Add titlo to the result")
    
    args = parser.parse_args()

    result = dec2cyrs(args.number, args.titlo)
    print(result)

if __name__ == "__main__":
    main()
