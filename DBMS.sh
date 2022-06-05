#!/bin/bash

#style
#red=`tput setaf 1 `
greencolor=`tput setaf 2 `
blue=$(tput setaf 4)
purple=$(tput setaf 5)
reset=$(tput sgr0)
bold=$(tput bold)
heighligt=$(tput smso)
green=$(tput setab 2)
red=$(tput setab 1)

#to store DB in directory and if there is an error will redirect to error file
mkdir Database 2>>./.error.log

#declare Database path
readonly pathOfDB="./Database"

clear

echo "${blue}${bold}          ⛁  Welcome To DataBase Management System ⛁                          "

function createDB {
  read -p "To Create Database , Enter DataBase Name : " newDB
  while [[ ! $newDB =~ ^[a-zA-Z]*$ || $newDB = "" ]]; do

    echo -e "\n                  ${purple}${red} please Enter valid Name !! 😥  ${reset}"
    read newDB
  done
  if [[ ! -d $pathOfDB/$newDB ]]; then

    mkdir $pathOfDB/$newDB

    # $? --> represent the exit status of previous command
    if [[ $? == 0 ]]; then

      echo -e "\n                 ${purple}${green} Database $newDB created successfully 👏 ${reset}"
    fi
  else

    echo -e "\n                   ${purple}${red}  Database Exists 😱  ${reset}"

  fi

  mainMenu
}

function listDB {
  index=0
  echo -e "${purple}${green} Databases : ${reset}"
  for DB in `ls $pathOfDB`; do
    database[index]=$DB
    let index=index+1

    echo -e "\n                  ${purple}${green} $DB ${reset}"
  done

 if [[  `ls -A $pathOfDB/ | wc -m` == "0" ]]; then

    echo -e "\n                   ${purple}${red} There Is No Database To Be Listed 😱 ${reset}"
  fi

  mainMenu
}

function dropDB {
  read -p "Enter Database Name: " dbName

  if [[ -d $pathOfDB/$dbName ]]; then
    rm -r $pathOfDB/$dbName
    echo -e "\n                   ${purple}${green}  Database $dbName deleted successfully 👏  ${reset}"
  else
    echo -e "\n                   ${purple}${red}  Database $dbName doesn't Exist 😱 ${reset}"
  fi

  mainMenu

}

function connectDB {
  read -p "Enter Database Name: " Name
  if [[ -d $pathOfDB/$Name ]]; then
    cd $pathOfDB/$Name

    echo -e "\n                ${purple}${green}  Connected to Database $Name successfully 👏  ${reset}"
  else
    echo -e "\n                ${purple}${red}  Database $Name doesn't Exist 😱 ${reset}"
    mainMenu

  fi

  tableMenu 2>>/dev/null
}

function mainMenu {

  echo -e "${blue} ${bold}
          ========================================
                        DataBase Menu 
          ========================================
 	         please enter your choice :-

		        (1) Create DB                  
		        (2) List DB              
		        (3) Drop DB                    
		        (4) Connect To DBs                  
		        (exit) Exit       

	   ========================================
	${reset}"

  echo "Please Enter your Option : "
  read option

  echo ""

  case $option in
  1) createDB ;;
  2) listDB ;;
  3) dropDB ;;
  4) connectDB ;;
  exit) exit ;;
  *) echo -e "\n                ${purple}${red}invalid option " 😥   ${reset} ; mainMenu ;

  esac

}

mainMenu

#--------------------------------------------------------------------------------------------------------------------------------------------#

function createTB {

  read -p "Table Name: " tableName
  while [[ ! $tableName =~ ^[a-zA-Z]*$ || $tableName = "" ]]; do

    echo -e "\n                  ${purple}${red} please Enter valid Name !! 😥  ${reset}"
    read tableName
  done
  if [[ -f $tableName ]]; then
   echo -e "\n                   ${purple}${red}  Table Exists 😱  ${reset}"

    tableMenu
  fi
  touch $tableName
  touch .$tableName

  read -p "Number of Columns: " colsNum
  while [[ ! $colsNum =~ ^[0-9]*$ || $colsNum = "" ]]; do

    echo -e "\n                  ${purple}${red} please Enter Number !! 😥  ${reset}"
   
    read colsNum
  done
  counter=1
  sep=":"

  primary=""
  echo "Column Name"$sep"Type"$sep"key" >>.$tableName

  while [ $counter -le $colsNum ]; do
    read -p "Name of Column Number $counter:" colName
    while [[ ! $colName =~ ^[a-zA-Z]*$ || $colName = "" ]]; do

     echo -e "\n                  ${purple}${red} please Enter valid Name !! 😥  ${reset}"
      read colName
    done

    echo "Type is: "
    select var in "int" "str"; do
      case $var in
      int)
        colType="int" ;
        break
        ;;
      str)
        colType="str" ;
        break
        ;;
      *) echo -e "\n                ${purple}${red}invalid option " 😥   ${reset}  ;;
      esac

    done

    if [[ $primary == "" ]]; then
      echo -e "Make PrimaryKey ? "
      select opt in "yes" "no"; do
        case $opt in
        yes)
          primary="PK"
          echo $colName$sep$colType$sep$primary >>.$tableName

          break
          ;;
        no)
          echo $colName$sep$colType$sep"" >>.$tableName
          break
          ;;
        *) echo -e "\n                ${purple}${red}invalid option " 😥   ${reset}  ;;
        esac
      done
    else
      echo $colName$sep$colType$sep"" >>.$tableName
    fi
    if [[ $counter == $colsNum ]]; then
      cols=$cols$colName
    else
      cols=$cols$colName$sep
    fi
    ((counter++))
  done
  echo $cols >$tableName

  # $? --> represent the exit status of previous command
  if [[ $? == 0 ]]; then

     echo -e "\n                 ${purple}${green} Table $tableName created successfully 👏 ${reset}"


  else
     echo -e "\n                ${purple}${red} Try again , Table wasn't created successfully " 😥   ${reset} 


  fi

  tableMenu

}

function listTB {

  index=0

 echo -e "${purple}${green} Tables : ${reset}"

  for Table in `ls $pwd ` 
   do
    table[index]=$Table ;
    let index=index+1 ;
    echo "                   ${purple}${green} $Table ${reset}"

  done
  if [[ `ls -l` ==  "total 0"  ]]; then
    echo -e "\n                   ${purple}${red} There Is No Tables To Be Listed 😱 ${reset}"


  fi
  tableMenu
}

function dropTB {
  read -p "Enter Table Name: " tbName

  if [[ -f $tbName ]]; then

    rm $tbName
    rm .$tbName

      echo -e "\n                   ${purple}${green}  Table $tbName deleted successfully 👏  ${reset}"
  else
    echo -e "\n                   ${purple}${red}  Table $tbName doesn't Exist 😱 ${reset}"


  fi

  tableMenu
}

function insert {
  row=""

  read -p "Enter Table Name: " tableName
  if [[ -f $tableName ]]; then

    colsNum=$(cat .$tableName | wc -l)
    sep=":"
    newLine="\n"

    for ((i = 2; i <= $colsNum; i++)); do

      name=$(awk -F ":" '{ if(NR=='$i') print $1}' .$tableName)
      ttype=$(awk -F ":" '{if(NR=='$i') print $2}' .$tableName)
      key=$(awk -F ":" '{if(NR=='$i') print $3}' .$tableName)

      echo -e "Enter $name ($ttype) Value: \n"
      read input

      if [[ $ttype == "int" ]]; then

        while [[ ! $input =~ ^[0-9]*$  || $input = "" ]]; do

          echo -e "\n                ${purple}${red} invalid DataType !! " 😥   ${reset} 
         
          read input
        done

      fi

      if [[ $key == "PK" ]]; then
        while [[ true ]]; do
          if [[ $input =~ ^[$(awk 'BEGIN{FS=":" ; ORS=" "}{if(NR != 1)print $(('$i'-1))}' $tableName)]$ ]]; then

            echo -e "\n                ${purple}${red} invalid input for Primary Key !!" 😥   ${reset} 
      
            read input
          else
            break

          fi
        done
      fi

      if [[ $i == $colsNum ]]; then
        row+=$input$newLine
      else
        row+=$input$sep
      fi

    done  #for end

    echo -e $row"\c" >>$tableName

    if [[ $? == 0 ]]; then

      echo -e "\n                   ${purple}${green}  Data Inserted Successfully 👏  ${reset}"
    else

      echo -e "\n                   ${purple}${red} Error Inserting Data into Table $tableName 😱 ${reset}"
    fi
    row=""

  else

     echo -e "\n                   ${purple}${red}  Table $tableName doesn't Exist 😱 ${reset}"

  fi

  tableMenu

}

function update {

  read -p "Enter Table Name: " tableName

  if [[ -f $tableName ]]; then
  
    read -p "Enter Column name  to update : " setSpecificColumn
    specificCol=$(awk -F ":" '{ if(NR==1) {for(i=1;i<=NF;i++){if($i=="'$setSpecificColumn'") print i}}}' $tableName)
    if [[ $specificCol == "" ]]; then
     echo -e "\n                   ${purple}${red}  Column $setSpecificColumn doesn't Exist 😱 ${reset}"
    else
      read -p "Enter condition Column name : " colCond
      colCondition=$(awk -F ":" '{ if(NR==1) {for(i=1;i<=NF;i++){if($i=="'$colCond'") print i}}}' $tableName)
      if [[ $colCondition == "" ]]; then
        echo -e "\n                   ${purple}${red}  Column $colCond doesn't Exist 😱 ${reset}"
      else
        echo -e "Enter Condition Value: \c"
        read val
        res=$(awk -F ":" '{if ($'$colCondition'=="'$val'" && NR!=1) print $'$colCondition'}' $tableName)

        if [[ $res == "" ]]; then
          echo -e "\n                   ${purple}${red}  Value $val Not Found 😱 ${reset}"

        else

          n=$(grep -n $setSpecificColumn .$tableName | cut -d: -f1)
          name=$(awk -F ":" '{ if(NR=='$n') print $1}' .$tableName)
          ttype=$(awk -F ":" '{if(NR=='$n') print $2}' .$tableName)
          key=$(awk -F ":" '{if(NR=='$n') print $3}' .$tableName)

          read -p "Enter new value To Update Column : " newValue
          NR=$(awk -F ":" '{if ($'$colCondition'=="'$val'" && NR!=1) print NR}' $tableName)
          for it in $NR; do

            if [[ $ttype == "int" ]]; then

              while [[ ! $newValue =~ ^[0-9]*$ ]]; do

                echo -e "\n                ${purple}${red} invalid DataType !! " 😥   ${reset} 
                read newValue
              done

            fi

            if [[ $key == "PK" ]]; then
              while [[ true ]]; do
                if [[ $newValue =~ ^[$(awk 'BEGIN{FS=":" ; ORS=" "}{if(NR != 1)print $specificCol}' $tableName)]$ ]]; then

                  echo -e "\n                ${purple}${red} invalid input for Primary Key !!" 😥   ${reset} 

                  read newValue
                else
                  break

                fi
              done
            fi

            oldValue=$(awk -F ":" '{if(NR=='$it'){for(i=1;i<=NF;i++){if(i=='$specificCol') print $i}}}' $tableName)
            sed -i ''$it's/'$oldValue'/'$newValue'/g' $tableName
            
            echo -e "\n                   ${purple}${green}  Row Updated Successfully 👏  ${reset}"

          done
          tableMenu

        fi
      fi
    fi

  else

    echo -e "\n                   ${purple}${red}  Table $tableName doesn't Exist 😱 ${reset}"

  fi

  tableMenu
}

function deleteFromTable {
  read -p "Enter Table Name:" tableName
  if [[ -f $tableName ]]; then
  read -p "Enter Condition Column name: " colName

  colFind=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$colName'") print i}}}' $tableName)
  if [[ $colFind == "" ]]; then
    echo -e "\n                   ${purple}${red}  Column $colName doesn't Exist 😱 ${reset}"
    tableMenu
  else
    read -p "Enter Condition Value: " val

    res=$(awk 'BEGIN{FS=":"}{if ($'$colFind'=="'$val'") print $'$colFind'}' $tableName 2>>./.error.log)
    if [[ $res == "" ]]; then
    
      echo -e "\n                   ${purple}${red}  Value $val Not Found 😱 ${reset}"
      tableMenu
    else
      NR=$(awk 'BEGIN{FS=":"}{if ($'$colFind'=="'$val'") print NR}' $tableName 2>>./.error.log)
      sed -i ''$NR'd' $tableName 2>>./.error.log
      
      echo -e "\n                   ${purple}${green}  Row Deleted Successfully 👏  ${reset}"

      tableMenu
    fi
  fi
  else

    echo -e "\n                   ${purple}${red}  Table $tableName doesn't Exist 😱 ${reset}"

  fi

  tableMenu
}

#---------------------------------------------------------------------------------------------------------------------------#

function selectAll {
  read -p "Enter Table Name: " tableName
   if [[ -f $tableName ]]; then
    echo -e "\n ${greencolor}"
    column -t -s ':' $tableName 2>>./.error.log

    echo -e "\n ${reset}"
  else
    echo -e "\n                   ${purple}${red}  Table $tableName doesn't Exist 😱 ${reset}"
  fi
  selectMenu
}

function selectCol {
  read -p "Enter Table Name: " tableName

    if [[ -f $tableName ]]; then
    read -p "Enter sepecific Column name : " colName


    specificCol=$(awk -F ":" '{ if(NR==1) {for(i=1;i<=NF;i++){if($i=="'$colName'") print i } } }' $tableName)
  

    if [[ $specificCol == "" ]]; then
      echo -e "\n                   ${purple}${red}  Column $colName doesn't Exist 😱 ${reset}"
    else

      
        echo -e "${greencolor}"
        awk 'BEGIN{FS=":"}{print $'$specificCol'}' $tableName

       echo -e "\n ${reset}"

    fi
  else
    echo -e "\n                   ${purple}${red}  Table $tableName doesn't Exist 😱 ${reset}"
  fi
  selectMenu
}

function allCond {
  echo -e "Select all columns from TABLE Where Column(OPERATOR)VALUE \n"

  read -p "Enter Table Name: " tableName

    if [[ -f $tableName ]]; then
    echo -e "Enter required Column name: \c"
    read colName
    colFind=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$colName'") print i}}}' $tableName)
    if [[ $colFind == "" ]]; then
      echo -e "\n                   ${purple}${red}  Column $colName doesn't Exist 😱 ${reset}"
      selectMenu
    else
      echo -e "\nSupported Operators: [==, !=, >, <, >=, <=] \nSelect OPERATOR: \c"
      read op
      if [[ $op == "==" ]] || [[ $op == "!=" ]] || [[ $op == ">" ]] || [[ $op == "<" ]] || [[ $op == ">=" ]] || [[ $op == "<=" ]]; then
        echo -e "\nEnter required VALUE: \c"
        read val


        res=$(awk 'BEGIN{FS=":"}{if ($'$colFind$op$val') print $0}' $tableName 2>>./.error.log | column -t -s ':')
 
        
        if [[ $res == "" ]]; then
          echo -e "\n                   ${purple}${red}  Value $val Not Found 😱 ${reset}"
          selectMenu
        else
          

              
           echo -e "${greencolor}"
           awk 'BEGIN{FS=":"}{if ($'$colFind$op$val') print $0}' $tableName 2>>./.error.log | column -t -s ':'

           echo -e "\n ${reset}"

          selectMenu
        fi
      else

        echo -e "\n                ${purple}${red} Unsupported Operator " 😥   ${reset}
        
        selectMenu
      fi
    fi
  else
    echo -e "\n                   ${purple}${red}  Table $tableName  doesn't Exist 😱 ${reset}"
  fi
  selectMenu
}

function selectMenu {

  echo -e "${blue} ${bold}
          ========================================
                        Select Menu
          ========================================
                 please enter your choice :-

                   (1) Select All Columns of a Table
                   (2) Select Specific Column from a Table
                   (3) Select From Table under condition  
                   (4) Back To Tables Menu
		   (5) Back To Main Menu
                   (exit) Exit
           ========================================
        ${reset}"

  echo "Please Enter your Option : "
  read option

  echo ""

  case $option in
  1) selectAll ;;
  2) selectCol ;;
  3) allCond ;;
  4) clear ; tableMenu ;;
  5) clear ; cd ../.. 2>>./.error.log ; mainMenu ;;
  exit) exit ;;
  *) echo -e "\n                ${purple}${red}invalid option " 😥   ${reset} ; selectMenu ;;

  esac

}

#---------------------------------------------------------------------------------------------------------------------------#

function tableMenu {

  echo -e "${blue} ${bold}
          ========================================
                        Table Menu
          ========================================
                 please enter your choice :-

                   (1) Create Table
                   (2) List Table
                   (3) Drop Table
                   (4) insert into Table
		   (5) Select From Table
		   (6) Delete From Table
		   (7) Update Table
                   (8) Back To Main Menu
                   (exit) Exit

           ========================================
        ${reset}"

  echo "Please Enter your Option : "
  read option

  echo ""


  case $option in
  1) createTB ;;
  2) listTB ;;
  3) dropTB ;;
  4) insert ;;
  5) selectMenu ;;
  6) deleteFromTable ;;
  7) update ;;
  8) clear ; cd ../.. 2>>./.error.log ; mainMenu ;;
  exit) exit ;;
  *) echo -e "\n                ${purple}${red}invalid option " 😥   ${reset} ; tableMenu ;;

  esac

}

tableMenu "$@"
