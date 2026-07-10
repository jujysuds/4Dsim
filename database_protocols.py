import os

#This program will take the input file, loop, and write contents to a file based on <comment_array> (i.e. component names)

#Gives first instance of a number in string- if none, returns final index of string (I think the final index is len(string) for range idea)
def first_num(string):
    if(any(char.isdigit() for char in string)):
        for i in range(0,len(string)):
            if string[i].isdigit():
                return i;
    else:
        return len(string);

input_file = '../../../Docs/MATLAB/input.txt'
output_file = 'db/instruments.db'
output2_file = 'tempApp/Db/instruments.proto'
protocol_file = 'instruments.proto'

#Provide 3 letter code for all components - currently given is the code for Beam Position Monitors (ai), which sample at 0.5Hz. Will add 'if element in aoVals: to skip weird input
aiVals = ['IPM']
aiParams = ['XPOS', 'YPOS']

aoVals = ['V-WIEN','H-WIEN']
aoLetters = ['M']
aoParams = ['BDL','XPARAM', 'YPARAM']

manualExclusion = ['MARKER']
refreshTime = '2 second'

#Gathers all comments/component names from injector file and puts in *array2*
array2 = []
with open(input_file, 'r') as file:
    for line in file:
        if(not(line.startswith('%'))):
            
            if('%' in line):
                line = line[0:line.index('%')]
            
            array = line.split()

            if(array[len(array) - 1] != '-'):
                array2.append(array[len(array) - 1])
file.close()

#We have captured component names - now need to write to database (output_file) standard thing plus their names
with open(output_file, 'w+') as file:
    
    file.write('#./temp/db/instruments.db\n')
    
    for element in array2:
        
            #element2 = list(element)
            name = ''
            elementkept = ''
            
            stopper = first_num(element)
            
            for i in range(0,len(element)):
                #Same here - not 3, but the first number instance, then this may be done
                if i < stopper:
                    name+=element[i]
                else:
                    elementkept += element[i]
             
            #Match idea fell apart adding in generality to aiVals
            if(name in aiVals):
                
                 #Can loop over i in ai_vals and then bob is the uncle
                for thing in aiParams:
                    file.write('record(ai, \"' + element + ':' + thing + '\"){\n'
                       + '\tfield(SCAN, \"'+ refreshTime + '\")\n'
                       + '\tfield(INP, \"@'+ protocol_file + ' get_'+ name + '('
                       + elementkept + ':' + thing +') $(PORT)\")\n'
                       + '\tfield(DTYP, \"stream\")\n'
                       + '}\n')
            
            #Currently manual name != 'MARKER' idea, not ideal 
            elif((name[0] in aoLetters or name in aoVals) and name not in manualExclusion):
                 #Writes record for each component in the array made from input file
                for thing in aoParams:                 

                    file.write('record(ao, \"' + element + ':' + thing + '\"){\n'
                       + '\tfield(SCAN, \"Passive")\n'
                       + '\tfield(OUT, \"@'+ protocol_file + ' set_'+ name + '('
                       + elementkept + ':' + thing + ') $(PORT)\")\n'
                       + '\tfield(DTYP, \"stream\")\n'
                       + '}\n')
    
    #Outside loop to be placed at end of file, after loop finishes execution
    file.write('record(stringout, \"quit\"){\n'
               + '\tfield(SCAN, \"Passive")\n'
               + '\tfield(DTYP, \"stream\")\n'
               + '\tfield(OUT, \"@'+ protocol_file + ' send_QUIT $(PORT)\")\n}\n')

file.close()                        

#This section will identify all unique 3 letter strings (all component types in the array) and make accessors in .proto file
with open(output2_file, 'w+') as file:
    #ALERT - Terminator = LF may be problematic, but that remains to be seen   
    file.write('#./tempApp/Db/instruments.proto\n' 
               + 'Terminator = LF;\n'
               + 'ReplyTimeout = 3000;\n')

    uniqueguys = []
    for element in array2:
       
        #element2 - just the letters of the component (ex: MQW for quads)
        element2 = ''
        for i in range(0, first_num(element)):
            element2 += element[i]

        if element2 not in uniqueguys:
            uniqueguys.append(element2)
    
    #Boring - just writes blocks of code that function as accessors in the proto file for all unique components  
    for element in uniqueguys:
        if((element[0] in aoLetters or element in aoVals or element in aiVals) and element not in manualExclusion):  
            file.write(  'set_' + element +'{\n'
                       + '\tExtraInput = Ignore;\n'
                       + '\tout \"' + element + '\\$1 %f\";\n'
                       + '\t@init { out \"' + element + '\\$1?\"; '
                       + 'in \"'+ element + '\\$1 %f\"; }\n}\n')

            file.write(  'get_' + element + '{\n'
                       + '\tExtraInput = Ignore;\n'
                       + '\tout \"' + element + '\\$1?\";\n'
                       + '\tin \"' + element + '\\$1 %f\";\n}\n')
    
    #Non-loop element, need to have quit routine at bottom of file
    file.write(  'send_QUIT{\n'
               + '\tout \"quit\";\n'
               + '\tExtraInput = Ignore;\n}\n')

file.close()

#Testing stuff
#os.system('cat ' + output_file)
#os.system('cat ' + output2_file)

#For when this file puts things to the files in different directories and the script is in ~/epics/ioc/temp
os.system('make')






