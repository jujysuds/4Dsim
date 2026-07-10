%secinput_processor.m, Jude D., 6/29/2026

function [beamline, comments, extraparams] = matlab_input(filename)
    fid = fopen(filename);
    tline = 0;
    stringArray = {};
    
    while 1
        tline = fgetl(fid);
        if(tline == -1)
            break;   
        end
        stringArray = [stringArray; tline];
    end
    
    file = stringArray;
    fclose(fid);

    %The below two loops find the positions of full line comments and the
    %first non comment line in the input file, respectively
    commentless = [1:length(file)]';
    count = 0; %removing a cell from commentPos changes indices, count fixes
    for k = 1:length(file)
        if(startsWith(file{k},'%'))
            commentless(k - count) = [];
            count = count + 1;
        end
    end

    realstart = 1;
    for k = 1:length(file)
        testline = file{k};
        if(~contains(testline,'%'))
            realline = split(testline);
            realline = realline(strlength(realline) > 0);
            beamcomps = find_comp(realline) - 1;
            break;
        end
    end

    reallength = length(commentless);
    beamline = zeros(reallength,beamcomps);
    comments = strings(reallength,1);
    extraparams = {};
    
    %Ignores all comments by using commentless indices
    for k=1:length(commentless)

        if(contains(file{commentless(k)}, '%'))

            tempstr = file{commentless(k)};
            tempstr = tempstr(1:strfind(tempstr, '%') - 1);

        else
            tempstr = file{commentless(k)};
        end

        %Now we take each line, tempstr, and tokenize as usual
        object = split(tempstr);
        object = object(strlength(object) > 0);
        numextras = length(object) - beamcomps - 1;

        for j = 1: beamcomps
            beamline(k,j) = str2double(object{j});
        end

        %If we have extra parameters, add them to array 
        extraparams{end+1,1} = [];
        if(numextras > 0)
    	    for n = 1:numextras
                extraparams{k,1} = [extraparams{k,1}, str2double(object{beamcomps + 1 + n})];
            
            end
        else
            extraparams{k,1}  = [0,0];
        end
        
        comments(k) = object{find_comp(object)};

    end


%full function end
end
