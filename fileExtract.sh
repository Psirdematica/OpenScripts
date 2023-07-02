#! /bin/bash

:'
Created With Love by 
JOSEPH SEDEM SETSOAFIA (Psridem)
For Psirdematica 
on Sunday, the 2nd of July, 2023.
this script will unzip all zip files in the given directory path(s) (passed as argument), 
remove spaces from the filenames and extracting the student names into a single text file.
This script was created to help me extract the names of students from their submitted assignment files
into a new sheet called Marksheet where I can append their marks after marking their codes.
'


#install unzip and unrar
# sudo apt -y install unzip unrar

#set filenames and other configurations
Zipfile=*.zip
Rarfile=*.rar
string_to_remove="_assignsubmission_file_"
marksheet="Sheet.txt" #for extracted names
Marksheet="MarkSheet.txt" #for unique names


for dirPath in $@
# for dirPath in $dirPATH/
    do
        echo "I'm in ${dirPath} "
        cd $dirPath
        #Removing Spaces from file names
        for file in ./*
            do 
                echo "Renaming ${file} ..."
                # Replace all spaces in the file name with underscores
                newfilename=$(echo "$file" | tr ' ' '_')
                newfilename=$(echo "$newfilename" | tr '-' '_')
                # Rename the file with the new name
                mv "$file" "$newfilename"
            done
        #create an extracted directory to keep the extracted files
        mkdir -p ./extracted/
        #looping through each zipfile in the current directory
        for zipfile in $Zipfile
            do
                if [ -f "$zipfile" ]
                then
                    ls "$zipfile"
                    #use sed to replace an instance of a string '.zip' in the filename unlike tr which does it char by char
                    zipname=$(echo "$zipfile" | sed 's/\.zip$/_/')
                    unzip -qo "$zipfile" -d ./extracted/"$zipname"/
                fi
            done 
        #extracting rarfiles if they exist
        for rarfile in $Rarfile
            do
                if [ -f "$rarfile" ]
                then
                    ls "$rarfile"
                    #use sed to replace an instance of a string '.rar' in the filename unlike tr which does it char by char
                    rarname=$(echo "$rarfile" | sed 's/\.rar$/_/')
                    #create the directory for the unrar files
                    mkdir -p ./extracted/"$rarname"/
                    #unrar the files to their respective directory 
                    # x -> extract, -o+ -> overwrite, -c- -> no comments while extracting
                    unrar x -o+ -c- $rarfile ./extracted/"$rarname"/
                fi
            done 
        
        cd ./extracted/
        for entry in ./*
            do
                echo "$entry"
                #enter the directory
                cd "$entry"/
                #create a marksheet
                echo "" > $marksheet
                #replace the spaces in filenames
                for file in ./*
                    do 
                        # echo "${file}"
                        # Replace all spaces in the file name with underscores
                        newfilename=$(echo "$file" | tr ' ' '_')
                        # Rename the file with the new name
                        mv "$file" "$newfilename"
                    done
        
                # looping through all the files present in the current dirPath
                for file in *
                    do
                        # echo "${file}"
                        student=${file/$string_to_remove*/: }
                        echo "${student}" >> $marksheet
                    done
                # get unique names into a newfile
                sort "$marksheet" | uniq > "$Marksheet"

                #go back to the next extracted directory
                cd ../
            done
    done
