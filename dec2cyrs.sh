#!/bin/bash

dec2cyrs() {
    local input_number=$1
    local use_titlo=$2
    local result=""

    if (( input_number < 1 || input_number > 9999999999 )); then
        echo "Error. The number must be from 1 to 9999999999" >&2
        exit 1
    fi

    declare -A cyrillic_symbols=(
        [1000000000]="а꙲ в꙲ г꙲ д꙲ е꙲ ѕ꙲ з꙲ и꙲ ѳ꙲"
        [100000000]="а꙱ в꙱ г꙱ д꙱ е꙱ ѕ꙱ з꙱ и꙱ ѳ꙱"
        [10000000]="а꙰ в꙰ г꙰ д꙰ е꙰ ѕ꙰ з꙰ и꙰ ѳ꙰"
        [1000000]="а҉ в҉ г҉ д҉ е҉ ѕ҉ з҉ и҉ ѳ҉"
        [100000]="а҈ в҈ г҈ д҈ е҈ ѕ҈ з҈ и҈ ѳ҈"
        [10000]="а⃝ в⃝ г⃝ д⃝ е⃝ ѕ⃝ з⃝ и⃝ ѳ⃝"
        [1000]="҂а ҂в ҂г ҂д ҂є ҂ѕ ҂з ҂и ҂ѳ"
        [100]="рстуфхѱѡц"
        [10]="іклмнѯопч"
        [1]="авгдєѕзиѳ"
    )

    for divisor in 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 1; do
        quotient=$((input_number / divisor))
        input_number=$((input_number % divisor))
        
        if (( quotient > 0 )); then
            if (( divisor >= 1000 )); then
                IFS=' ' read -ra symbols <<< "${cyrillic_symbols[$divisor]}"
                if (( quotient <= ${#symbols[@]} )); then
                    result+="${symbols[$((quotient-1))]}"
                else
                    result+=$(printf "%0.s${symbols[-1]}" $(seq 1 $quotient))
                fi
            elif (( divisor == 10 && quotient >= 1 && quotient <= 9 )); then
                tens="${cyrillic_symbols[10]:$((quotient-1)):1}"
                ones="${cyrillic_symbols[1]:$((input_number-1)):1}"
                if (( quotient * 10 + input_number >= 11 && quotient * 10 + input_number <= 19 )); then
                    result+="$ones$tens"
                else
                    result+="$tens$ones"
                fi
                break
            else
                result+="${cyrillic_symbols[$divisor]:$((quotient-1)):1}"
            fi
        fi
    done

    if [[ $use_titlo == true ]]; then
        titlo="҃"
        if (( ${#result} == 1 )); then
            result="$result$titlo"
        else
            result="${result:0:${#result}-1}$titlo${result: -1}"
        fi
    fi

    echo "$result"
}

main() {
    local number=""
    local use_titlo=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -t|--titlo)
                use_titlo=true
                shift
                ;;
            *)
                if [[ -z $number ]]; then
                    number=$1
                else
                    echo "Error: Unknown argument $1" >&2
                    exit 1
                fi
                shift
                ;;
        esac
    done

    if [[ -z $number ]]; then
        echo "Error: No number specified for conversion" >&2
        exit 1
    fi

    if ! [[ $number =~ ^[0-9]+$ ]]; then
        echo "Error: Argument must be an integer" >&2
        exit 1
    fi

    result=$(dec2cyrs "$number" "$use_titlo")
    echo "$result"
}

main "$@"
