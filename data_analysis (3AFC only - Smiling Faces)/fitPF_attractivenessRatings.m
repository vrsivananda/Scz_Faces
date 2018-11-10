function paramsValues = fitPF_attractivenessRatings(dataStructure, nValidSubjects, PF, subjectOrPatient, saveFigure)
    
    % ====== PARAMETERS BEGIN ======
    
    % General
    marker = '.';
    markerSize = 20;
    lineStyle = '-';
    lineWidth = 2;
    fontSize = 12;
    
    % Axis Limits;
    xMin = -3.5;
    xMax = 3.5;
    yMin = 0;
    yMax = 1;
    
    % Get the fine-grained x-axis values
    stimLevelsFine = xMin:(xMax-xMin)/1000:xMax;
    
    % The number of simulations to perform for goodness of fit test
    B = 1000;
    
    % The search grid
    searchGrid.alpha = -1:0.005:1; % Threshold (PSE ?)
    searchGrid.beta = 10.^(-1:0.25:10); % Slope
    searchGrid.gamma = 0; % Guess Rate
    searchGrid.lambda = 0; % Lapse Rate
    
    % Get the genders, ratings, and faceNumbers for each face
    genders = dataStructure.gender(6:65);
    ratings = dataStructure.response(6:65);
    faceNumbers = dataStructure.faceNumber(6:65);
    
    % Sort them
    [faceNumbers sortIndex] = sort(faceNumbers);
    ratings = ratings(sortIndex);
    genders = genders(sortIndex);
    [genders sortIndex] = sort(genders);
    ratings = ratings(sortIndex);
    faceNumbers = faceNumbers(sortIndex);
    
    % Calculate the average
    averageRatings_F_M = (faceNumbers(1:2:60) + ratings(2:2:60))./2;
    averageRatings_F = averageRatings_F_M(1:15);
    averageRatings_M = averageRatings_F_M(16:30);
    
    % Get the indices of trials where the subject did not choose the
    % target or non-target (no distractor)
    targetIndices =  returnIndicesIntersect(dataStructure.chosenFace, 'target');
    nonTargetIndices = returnIndicesIntersect(dataStructure.chosenFace, 'non-target');
    TNT_Indices = sort([targetIndices; nonTargetIndices]);
    
    % Get the respective data arrays
    chosenFace = dataStructure.chosenFace(TNT_Indices);
    rating_T_Face = dataStructure.chosenFace(TNT_Indices);
    rating_NT_Face = dataStructure.chosenFace(TNT_Indices);
    
    % Define arrays
    targetChosen_Array = [];
    ratingDiff_Array = [];
    
    % Go through each trial
    for i = 1:length(dataStructure.rt)
        
        % Check if this is the trial we want
        if(strcmp(dataStructure.trialType{i}, '3AFC') && ...
                ~strcmp(dataStructure.chosenFace{i}, 'distractor'))
            
            % Get the Gender
            gender = dataStructure.gender{i};
            
            % Get the target facenumber
            if(strcmp(dataStructure.faceType1{i}, 'target'))
                faceNumber_T = dataStructure.faceNumber1(i);
            elseif(strcmp(dataStructure.faceType2{i}, 'target'))
                faceNumber_T = dataStructure.faceNumber2(i);
            elseif(strcmp(dataStructure.faceType3{i}, 'target'))
                faceNumber_T = dataStructure.faceNumber3(i);
            end
            
            % Get the non-target facenumber
            if(strcmp(dataStructure.faceType1{i}, 'non-target'))
                faceNumber_NT = dataStructure.faceNumber1(i);
            elseif(strcmp(dataStructure.faceType2{i}, 'non-target'))
                faceNumber_NT = dataStructure.faceNumber2(i);
            elseif(strcmp(dataStructure.faceType3{i}, 'non-target'))
                faceNumber_NT = dataStructure.faceNumber3(i);
            end
            
            % Get the face ratings
            if(strcmp(gender, 'M'))
                rating_T = averageRatings_M(faceNumber_T);
                rating_NT = averageRatings_M(faceNumber_NT);
            elseif(strcmp(gender, 'F'))
                rating_T = averageRatings_F(faceNumber_T);
                rating_NT = averageRatings_F(faceNumber_NT);
            end % End of if gender
            
            % Get the rating difference
            ratingDiff = rating_T - rating_NT;
            
            % If the non-target came first, then we need to add a
            % negative sign to the zScoreDiff
            
            % If the first face is a non-target, or second face is
            % non-target AND first face is distractor
            % In the form if( x || (y && z))
            if((strcmp(dataStructure.faceType1(i), 'non-target')) || ...
                    (strcmp(dataStructure.faceType1(i), 'distractor') && ...
                    strcmp(dataStructure.faceType2(i), 'non-target')))
                
                % Add a negative sign
                ratingDiff = -ratingDiff;
                
            end % End of if
            
            
            % Fill in the array with the zScoreDiff
            ratingDiff_Array(length(ratingDiff_Array)+1, 1) = ratingDiff;
            
            % Check if they chose the target face
            if(strcmp(dataStructure.chosenFace{i}, 'target'))
                % Log it in as '1' in the array
                targetChosen_Array(length(targetChosen_Array)+1, 1) = 1;
                % Else they did not choose the target
            else
                % Log it in as '0' in the array
                targetChosen_Array(length(targetChosen_Array)+1, 1) = 0;
            end % End of if chosenFace == target
            
        end % End of if this is trial we want
        
    end % End of function that goes through each trial (i)
    
    
    
    
    % Sort the zScoreDiffs
    [ratingDiffs_sorted, sortingIndex] = sort(ratingDiff_Array);
    
    % Sort the target chosen trials
    targetChosen_sorted = targetChosen_Array(sortingIndex);
    
    % ---- Bin the data dynamically into 4 bins ----
    % Split between left and right of 0, then split each of those
    % equally
    
    % The number per bin
    nPerBin = length(ratingDiffs_sorted)/4; % Unused
    
    % Get the index of the first positive number
    halfwayIndex = find(ratingDiffs_sorted > 0, 1);
    
    % Cut that in half and floor to get the index of partition
    quarterPoint1 = floor(halfwayIndex/2);
    
    % Get the second half and cut that in half
    quarterPoint3 = floor(halfwayIndex + (floor(length(ratingDiffs_sorted)-halfwayIndex)/2));
    
    % Bin them
    for i = 1:4
        
        % Get the indices of the relevant trials
        if(i == 1)
            currentIndices = 1:quarterPoint1;
        elseif(i == 2)
            currentIndices = (quarterPoint1+1):halfwayIndex-1;
        elseif(i == 3)
            currentIndices = halfwayIndex:quarterPoint3;
        elseif(i == 4)
            currentIndices = (quarterPoint3+1):length(ratingDiffs_sorted);
        end
        
        % Fill in the total trials per bin
        binCounter(i) = length(currentIndices);
        
        % Get the current indices of array to process
        %currentIndices = (((i-1)*nPerBin)+1) : (nPerBin*i);
        
        % Get the current array of zScoreDiffs for this bin
        current_ratingDiff_array = ratingDiffs_sorted(currentIndices);
        
        % Get the current array of targetChosen for this bin
        current_targetChosen_array = targetChosen_sorted(currentIndices);
        
        % Calculate the target chosenBinCounter
        % Count the ones or zeros depending if it is in the first two
        % bins or not
        if(i == 1 || i == 2)
            targetChosenBinCounter(i) = sum(current_targetChosen_array == 0);
        else
            targetChosenBinCounter(i) = sum(current_targetChosen_array == 1);
        end
        
        % Calculate the percentChosen and store it into the array
        percentChosenTarget(i) = targetChosenBinCounter(i)/binCounter(i);
        
        % Calculate the binCenters
        %binCenter(i) = mean([min(current_ZScoreDiff_array), max(current_ZScoreDiff_array)]);
        binCenter(i) = mean(current_ratingDiff_array);
        
    end % End of for i = 1:4
    
    % ------ Curve fitting ------
    
    % Choose the initial values
    paramsValues = [1 1 0 0];
    % Choose which are the free parameters
    paramsFree = [1 1 0 0]; % Fix the guess rate and lapse rate
    
    disp(binCenter);
    disp(targetChosenBinCounter);
    disp(targetChosenBinCounter);
    disp(searchGrid);
    disp(paramsFree);
    disp(PF);
    
    % Fit the curve
    [paramsValues, LL, exitflag] = PAL_PFML_Fit(binCenter,...
        targetChosenBinCounter, binCounter, searchGrid, paramsFree, PF);
    
    pDev = 0; converged = 0; % Dummy values to return if we are not testing goodness of fit
    
    
    % ------ Graph ------
    
    
    attractiveness_fit =  PF(paramsValues,stimLevelsFine);
    
    
    
    
    
end % End of function