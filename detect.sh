# author: kimson
#!/usr/bin/env sh

PREV=$(stat -c %Z *)

echo "감시할 확장자 명을 입력하세요. [ txt / py / c / ... ]\n"
read EXTENSION
clear
echo "감시 중인 확장자 명 [ $EXTENSION ]"
while true
do
    CUR=$(stat -c %Z *)
    
    if [ "$PREV" != "$CUR" ];then
        CHANGE_IDX=0

        PREV_ARR=(`echo ${PREV} | tr "," "\n"`)
        CUR_ARR=(`echo ${CUR} | tr "," "\n"`)

        FILES=(`echo $(stat -c %n * | tr "," "\n")`)

        echo "Change file detection !"

        for x in "${!PREV_ARR[@]}"
        do
            if [ "${PREV_ARR[$x]}" != "${CUR_ARR[$x]}" ];then
                CHANGE_IDX=$x
                FILE_NAME="${FILES[${CHANGE_IDX}]}"
                if [[ $FILE_NAME =~ $EXTENSION ]];then
                    # do something !
                    clear
                    echo -e "=============== [ logs ] ===============\n"
                    echo "감시 중인 확장자 명 [ $EXTENSION ]"
                    echo -e "\nThe change file is > $FILE_NAME.\n${CHANGE_IDX} of the files.\n"
                    # If you need to see a changed file, you can do this:
                    echo -e ">>>>>>>>>>>>>>> Preview <<<<<<<<<<<<<<<\n"
                    cat ${FILE_NAME}
                    echo -e "\n"
                    echo ">>>>>>>>>>>>>>> End preview <<<<<<<<<<<<<<<"
                    echo -e "\nDetection time : `echo $(DATE)`"
                    echo -e "\n=============== [ end logs ] ==============="
                fi
            fi
        done
    fi
    PREV=$CUR
done