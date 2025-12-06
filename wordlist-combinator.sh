#!/bin/bash

#combiner 0 ${#inputarray[@]} $ARG_OUTPUT ""
function combiner() {
  local comb_array_pos=$1
  local comb_array_length=$2
  local comb_output_path=$3
  local comb_output_string=$4

  echo "local comb_array_pos : $comb_array_pos"
  echo "local comb_array_length : $comb_array_length"
  echo "local comb_output_path : $comb_output_path"
  echo "local comb_output_string : $comb_output_string"
  echo ""

  echo " ${inputarray[comb_array_pos]}"
  #$(cat ${inputarray[comb_array_pos]})

  for line in $(cat ${inputarray[comb_array_pos]}); do
    echo "$line"
    #echo '$comb_array_pos" == "$comb_array_length'
    #echo "$("$comb_array_pos" == "$comb_array_length")"
echo 'if [[ "$comb_array_pos" == "$comb_array_length" ]]'
echo "if [[ "$comb_array_pos" == "$comb_array_length" ]]"
echo " $(("$comb_array_pos" == "$comb_array_length" | echo ))"
echo "$(( 1 == 1 ))"

echo "$(($comb_array_pos == $comb_array_length))"

    if [[ "$comb_array_pos" -eq "$comb_array_length" ]];then 
      echo "IF TRUE"      
      local output="${comb_output_string}${line}"
      echo   "${comb_output_string}${line}"
      echo "$output"
      echo "$output" >> $comb_output_path
    else
      echo "IF FALSE"
      local next_array_pos=$((comb_array_pos+1))
      echo "next array pos : $next_array_pos"
      echo combiner next_array_pos: $next_array_pos comb_inputlists_length: $comb_inputlists_length output_path: $output_path comb_output_stringline :$comb_output_string$line

      combiner $next_array_pos $comb_inputlists_length $output_path $comb_output_string$line
    fi

  done
}



#handles option flags

while getopts "o:hv" opt; do
  case $opt in
    o) #output:
      ARG_OUTPUT=$OPTARG
      ;;
    v) #version
      echo -e "Wordlist-Combinator v1.0 \n\nCodeChonk"
      exit 0
      ;;
    h) #help
      echo "wordlist-combinator.sh [-o output] ListOne ListTwo ... "
      echo "-h: Help Info"
      echo "-v: Version"
      exit 0
      ;;
    \?)
      
      echo "Usage: wordlist-combinator.sh [-o output] ListOne ListTwo ..."
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

#Gives information and simulates loading times
echo -e "--Program Start--\n"
sleep 0.5s
echo "Combinating The Following Lists: $*"
sleep 0.7s
echo "initializing wordlist array"
sleep 0.5s

declare -a inputarray
outputsize=1
outputwords=1

# checks inputs for validity, displays information about given lists
for i in $*; do
	if [ -f "$i" ]; then
		echo -e "\n$i exists, adding to combinator"
		inputarray+=($i)
		echo "words:  $(wc -l $i | cut -d ' ' -f 1)"
		echo "bytes: $(wc -c $i | cut -d ' ' -f 1)"
		outputwords=$((($outputwords * $(wc -l $i | cut -d ' ' -f 1))))
    outputsize=$((($outputsize * $(wc -c $i | cut -d ' ' -f 1))))
	else
		echo "$i does not exist, aborting"  && exit 1
	fi
done 

# Prints information while emulating processing time
echo -e "\nNumber of input lists: ${#inputarray[@]}"
sleep 0.5s
echo "List of input lists: ${inputarray[@]}"
sleep 0.8s
echo "Output to: $ARG_OUTPUT"
sleep 0.2s

echo -e "\nOutput Word Count: $outputwords words"
echo -e "\nEstimated output size: $outputsize bytes"

sleep 1s

#was formerly using a different recursive implementation. Don't feel like rewriting it more thoroughly than necessary
#processor 0   "" ${inputarray[@]}

#function processor() {
array_pos=0
array_length=${#inputarray[@]}
output_path=$ARG_OUTPUT
output_string=""

echo "array_pos : $array_pos"
echo "array_length : $array_length"
echo "output_path : $output_path"
echo "output_string : $output_string"

arraysetnumber=0
adjarraysetnumber=0
declare -a listsarray
adjinputarraylength=$((${#inputarray[@]}+3))

 echo "arraysetnumber : $arraysetnumber"
 echo "adjarraysetnumber : $adjarraysetnumber"
 echo "declare : $declare"
 echo "adjinputarraylength : $adjinputarraylength"
 echo ""
echo " ${inputarray[@]}"

#copies argument array and trims it into an array of supplied lists
# for i in ${inputarray[@]}; do
#   if [[ $arraysetnumber -ge 3 ]];then
#     adjarraysetnumber=$(("$arraysetnumber"-3))
#     listsarray[$adjarraysetnumber]=$i 
#   fi
#   arraysetnumber=$(("$arraysetnumber"+1))
# done


# loop prints array for debugging purposes
#for ((j=0; j < "${#listsarray[@]}"; j++))do #$adjinputarraylength"
#  echo "$j : ${listsarray[$j]}"
#done

comb_inputlists_length=${#inputarray[@]} #$((${#listsarray[@]}-1))
  echo "comb inputlists length : $comb_inputlists_length"
# combiner 0 $comb_inputlists_length $ARG_OUTPUT ""
echo "combiner 0 ${#inputarray[@]} $ARG_OUTPUT """
combiner 0 ${#inputarray[@]} $ARG_OUTPUT ""

echo ""
echo "Done"
exit 0
