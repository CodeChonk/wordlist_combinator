#!/bin/bash

# preset variables
ARG_OUTPUT=/dev/stdout
declare -a inputarray
outputsize=1
outputwords=1

#recursive function puts together and outputs combined words
function combinator() {
  #I suppose the first two variables are unneccesary, the third is because I couldn't seem to put that in a conditional statement correctly
  local comb_array_pos=$1
  local comb_output_string=$2
  local islastlist=$(("$comb_array_pos" == "$inputarraylessone"))
  
  #for each item in the list in the array at that position, add it to the output string and output it if it's the correct position
  for line in $(cat ${inputarray[$comb_array_pos]}); do
    if [[ $islastlist -eq 1 ]];then      
      local output="${comb_output_string}${line}"  
      echo "$output" >> $ARG_OUTPUT
    else
      local next_array_pos=$((comb_array_pos+1))
      combinator $next_array_pos $comb_output_string$line
    fi
  done
}

#options handler
while getopts "ohv" opt; do
  case $opt in
    o) #output:
      ARG_OUTPUT=$2
      shift $((OPTIND-1))
      ;;
    v) #verbose
      verbose=1
      ;;
    h) #help
      echo "wordlist-combinator.sh [-o output.file] [-v] list-one list-two ... "
      echo ""
      echo "-h: Help Info"
      echo "-v: verbose. I only recommend using if used with -o. Would otherwise interfere with downstream piped commands"
      echo "-o: output to file. Must be the first argument to function correctly."
      echo -e "\n\nWordlist Combinator v1.1 -- CodeChonk 2025"
      exit 0
      ;;
    \?)
      echo "-h for help"
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

# checks inputs for validity, displays information about given lists if verbose flag is set and creates input array list
for i in $*; do
	if [ -f "$i" ]; then
		
    if [[ "$verbose" ]];then 
      echo -e "\n$i exists, adding to combinator" 
    fi
		inputarray+=($i)
		if [[ "$verbose" ]];then 
      echo "words:  $(wc -l $i | cut -d ' ' -f 1)"
    fi
    if [[ "$verbose" ]];then 
      echo "bytes: $(wc -c $i | cut -d ' ' -f 1)"
    fi
		outputwords=$((($outputwords * $(wc -l $i | cut -d ' ' -f 1))))
    outputsize=$((($outputsize * $(wc -c $i | cut -d ' ' -f 1))))
	else
		echo "$i does not exist, aborting"  && exit 1
	fi
done

inputarraylessone=$((${#inputarray[@]}-1))

combinator 0 ""


  
