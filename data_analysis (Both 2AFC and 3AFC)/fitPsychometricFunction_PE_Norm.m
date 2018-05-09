function [paramValues, chosenFaces] = fitPsychometricFunction_PE_Norm(dataStructure, subjectNumber)
    
    % ====== PARAMETERS BEGIN ======
    
    % Saving the figure
    saveFigure = 0; 
    
    % Choose the a psychometric function 
    PF = @PAL_CumulativeNormal;
    
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
    
    % Colors
    highPE_highNorm_Color = [139,  69,  19]./255; % Dark Brown
    highPE_lowNorm_Color  = [205, 133,  63]./255; % Light Brown
    lowPE_highNorm_Color  = [ 50,  50,  50]./255; % Dark Gray
    lowPE_lowNorm_Color   = [150, 150, 150]./255; % Light Gray
    
    % The number of simulations to perform for goodness of fit test
    B = 1000;
    
    % The search grid
    searchGrid.alpha = -1:0.005:1; % Threshold (PSE ?)
    searchGrid.beta = 10.^(-1:0.25:10); % Slope
    searchGrid.gamma = 0; % Guess Rate
    searchGrid.lambda = 0; % Lapse Rate
    
    % Choose which are the free parameters
    paramsFree = [1 1 0 0]; % [threshold, slope, guess rate, lapse rate]
    
    
    % ====== PARAMETERS END ======
    
    % --- Variables to store data ---
    
    % -- HighPE --
    
    % High Norm
    zScoreDiff_highPE_highNorm_Array = [];
    targetChosen_highPE_highNorm_Array = [];
    zScoreDistractor_highPE_highNorm_Array = [];
    confidence_highPE_highNorm_Array = [];
    
    targetCounter_highPE_highNorm = 0;
    nontargetCounter_highPE_highNorm = 0;
    distractorCounter_highPE_highNorm = 0;
    
    % Low Norm
    zScoreDiff_highPE_lowNorm_Array = [];
    targetChosen_highPE_lowNorm_Array = [];
    zScoreDistractor_highPE_lowNorm_Array = [];
    confidence_highPE_lowNorm_Array = [];
    
    targetCounter_highPE_lowNorm = 0;
    nontargetCounter_highPE_lowNorm = 0;
    distractorCounter_highPE_lowNorm = 0;
    
    % -- LowPE --
    
    % High Norm
    zScoreDiff_lowPE_highNorm_Array = [];
    targetChosen_lowPE_highNorm_Array = [];
    zScoreDistractor_lowPE_highNorm_Array = [];
    confidence_lowPE_highNorm_Array = [];
    
    targetCounter_lowPE_highNorm = 0;
    nontargetCounter_lowPE_highNorm = 0;
    distractorCounter_lowPE_highNorm = 0;
    
    % Low Norm
    zScoreDiff_lowPE_lowNorm_Array = [];
    targetChosen_lowPE_lowNorm_Array = [];
    zScoreDistractor_lowPE_lowNorm_Array = [];
    confidence_lowPE_lowNorm_Array = [];
    
    targetCounter_lowPE_lowNorm = 0;
    nontargetCounter_lowPE_lowNorm = 0;
    distractorCounter_lowPE_lowNorm = 0;
    
    % Counter for 'distractor' choice
    distractorCounter = 0;
    
    % --- Finding the mean of the low PE distractor faces --
    
    % Get the indices of the lowPE 3AFC trials
    lowPE_3AFC_indices = returnIndicesIntersect(dataStructure.trialType, '3AFC', ...
                                                dataStructure.PE, 'low');
    
    % Get the zScores of distractor faces of those trials
    lowPE_3AFC_distractorZScores = dataStructure.distractorZScore(lowPE_3AFC_indices);
    
    % Get the mean of the lowPE 3AFC distractor face z-scores
    mean_lowPE_3AFC_distractorZScores = mean(lowPE_3AFC_distractorZScores);
    
    % --- Filling in the bins ---
    
    % For loop that goes through the dataStructure and updates the
    % corresponding bin
    for i = 1:length(dataStructure.zScoreDiff)
        
        % Check if this is the trial that we want
        
        % The trial we want is the one that corresponds to the AFC
        trialWeWant = strcmp(dataStructure.trialType{i}, '3AFC');
        
        % If it is the trial that we want
        if(trialWeWant)
            
            % Get the chosen face
            chosenFace = dataStructure.chosenFace{i}; % This will be used below also
            
            % Check if subject chose the distractor face for this trial
            subjectChoseDistractor = strcmp(chosenFace, 'distractor');
            
            % If the subject chose the distractor
            if(subjectChoseDistractor)
                
                % Increment the counter
                distractorCounter = distractorCounter + 1;
                
            end
            
            % Get the current zScoreDiff
            currentZScoreDiff = dataStructure.zScoreDiff(i);

            % If the non-target came first, then we need to add a
            % negative sign to the zScoreDiff

            % If the first face is a non-target, or second face is
            % non-target AND first face is distractor
            % In the form if( x || (y && z))
            if((strcmp(dataStructure.faceType1(i), 'non-target')) || ...
                    (strcmp(dataStructure.faceType1(i), 'distractor') && ...
                    strcmp(dataStructure.faceType2(i), 'non-target')))

                % Add a negative sign
                currentZScoreDiff = -currentZScoreDiff;

            end % End of if faceTypeX == '...'

            % Check if the subject chose the target
            subjectChoseTarget = strcmp(dataStructure.chosenFace(i),'target');

            % Get the current distractorZScore
            currentDistractorZScore = dataStructure.distractorZScore(i);

            % Get the current PE
            currentTrialPE = dataStructure.PE{i};

            % --- Check if this is high norm or low norm trial ---

            if(strcmp(currentTrialPE, 'high'))

                % If it is a high trial, then just check if the distractor
                % face has a -ve zScore
                if(currentDistractorZScore < 0)
                    % If the distractor has a -ve ZScore, then it is a low
                    % norm trial
                    currentTrialNorm = 'low';
                else
                    % Else it has a +ve zScore and it is a high norm trial
                    currentTrialNorm = 'high';
                end

            % Else if it is a low PE trial
            elseif(strcmp(currentTrialPE, 'low'))

                % Then check if the distractorZScore is lower than the
                % mean -ve faces of low PE trials
                if(currentDistractorZScore < mean_lowPE_3AFC_distractorZScores)
                    % Then it is low norm
                    currentTrialNorm = 'low';
                else
                    % Else it is higher and has high norm
                    currentTrialNorm = 'high';
                end

            end % End of if PE == 'high'

            % --- Store the variables into the relevant Norm array ---

            % If it is a HighPE trial
            if(strcmp(currentTrialPE, 'high'))

                if(strcmp(currentTrialNorm, 'low'))

                    % If the subject chose the target or non-target
                    if(~subjectChoseDistractor)

                        % Log it in as 1 or 0 in the array depending on whether the
                        % subject chose the target
                        targetChosen_highPE_lowNorm_Array(length(targetChosen_highPE_lowNorm_Array)+1, 1) = double(subjectChoseTarget);

                        % Fill in the array with the zScoreDiff
                        zScoreDiff_highPE_lowNorm_Array(length(zScoreDiff_highPE_lowNorm_Array)+1, 1) = currentZScoreDiff;

                        % Fill in the array with the zScore of the distractor
                        zScoreDistractor_highPE_lowNorm_Array(length(zScoreDistractor_highPE_lowNorm_Array)+1, 1) = currentDistractorZScore;
                        
                        % Fill in the array with the confidence
                        confidence_highPE_lowNorm_Array(length(confidence_highPE_lowNorm_Array)+1, 1) = dataStructure.response(i+1);

                    end 

                    % Update the counter based on which face was chosen
                    if(strcmp(chosenFace,'target'))    
                        targetCounter_highPE_lowNorm = targetCounter_highPE_lowNorm + 1;
                    elseif(strcmp(chosenFace,'non-target'))
                        nontargetCounter_highPE_lowNorm = nontargetCounter_highPE_lowNorm + 1;
                    elseif(strcmp(chosenFace,'distractor'))
                        distractorCounter_highPE_lowNorm = distractorCounter_highPE_lowNorm + 1;
                    end

                elseif(strcmp(currentTrialNorm, 'high'))

                    % If the subject chose the target or non-target
                    if(~subjectChoseDistractor)

                        % Log it in as 1 or 0 in the array depending on whether the
                        % subject chose the target
                        targetChosen_highPE_highNorm_Array(length(targetChosen_highPE_highNorm_Array)+1, 1) = double(subjectChoseTarget);

                        % Fill in the array with the zScoreDiff
                        zScoreDiff_highPE_highNorm_Array(length(zScoreDiff_highPE_highNorm_Array)+1, 1) = currentZScoreDiff;

                        % Fill in the array with the zScore of the distractor
                        zScoreDistractor_highPE_highNorm_Array(length(zScoreDistractor_highPE_highNorm_Array)+1, 1) = currentDistractorZScore;
                        
                        % Fill in the array with the confidence
                        confidence_highPE_highNorm_Array(length(confidence_highPE_highNorm_Array)+1, 1) = dataStructure.response(i+1);

                    end

                    % Update the counter based on which face was chosen
                    if(strcmp(chosenFace,'target'))    
                        targetCounter_highPE_highNorm = targetCounter_highPE_highNorm + 1;
                    elseif(strcmp(chosenFace,'non-target'))
                        nontargetCounter_highPE_highNorm = nontargetCounter_highPE_highNorm + 1;
                    elseif(strcmp(chosenFace,'distractor'))
                        distractorCounter_highPE_highNorm = distractorCounter_highPE_highNorm + 1;
                    end

                end % End of if currentTrialNorm == 'low'

            % Else if it is a low PE trial
            elseif(strcmp(currentTrialPE, 'low'))

                if(strcmp(currentTrialNorm, 'low'))

                    % If the subject chose the target or non-target
                    if(~subjectChoseDistractor)

                        % Log it in as 1 or 0 in the array depending on whether the
                        % subject chose the target
                        targetChosen_lowPE_lowNorm_Array(length(targetChosen_lowPE_lowNorm_Array)+1, 1) = double(subjectChoseTarget);

                        % Fill in the array with the zScoreDiff
                        zScoreDiff_lowPE_lowNorm_Array(length(zScoreDiff_lowPE_lowNorm_Array)+1, 1) = currentZScoreDiff;

                        % Fill in the array with the zScore of the distractor
                        zScoreDistractor_lowPE_lowNorm_Array(length(zScoreDistractor_lowPE_lowNorm_Array)+1, 1) = currentDistractorZScore;
                        
                        % Fill in the array with the confidence
                        confidence_lowPE_lowNorm_Array(length(confidence_lowPE_lowNorm_Array)+1, 1) = dataStructure.response(i+1);

                    end

                    % Update the counter based on which face was chosen
                    if(strcmp(chosenFace,'target'))    
                        targetCounter_lowPE_lowNorm = targetCounter_lowPE_lowNorm + 1;
                    elseif(strcmp(chosenFace,'non-target'))
                        nontargetCounter_lowPE_lowNorm = nontargetCounter_lowPE_lowNorm + 1;
                    elseif(strcmp(chosenFace,'distractor'))
                        distractorCounter_lowPE_lowNorm = distractorCounter_lowPE_lowNorm + 1;
                    end

                elseif(strcmp(currentTrialNorm, 'high'))

                    % If the subject chose the target or non-target
                    if(~subjectChoseDistractor)

                        % Log it in as 1 or 0 in the array depending on whether the
                        % subject chose the target
                        targetChosen_lowPE_highNorm_Array(length(targetChosen_lowPE_highNorm_Array)+1, 1) = double(subjectChoseTarget);

                        % Fill in the array with the zScoreDiff
                        zScoreDiff_lowPE_highNorm_Array(length(zScoreDiff_lowPE_highNorm_Array)+1, 1) = currentZScoreDiff;

                        % Fill in the array with the zScore of the distractor
                        zScoreDistractor_lowPE_highNorm_Array(length(zScoreDistractor_lowPE_highNorm_Array)+1, 1) = currentDistractorZScore;
                        
                        % Fill in the array with the confidence
                        confidence_lowPE_highNorm_Array(length(confidence_lowPE_highNorm_Array)+1, 1) = dataStructure.response(i+1);

                    end

                    % Update the counter based on which face was chosen
                    if(strcmp(chosenFace,'target'))    
                        targetCounter_lowPE_highNorm = targetCounter_lowPE_highNorm + 1;
                    elseif(strcmp(chosenFace,'non-target'))
                        nontargetCounter_lowPE_highNorm = nontargetCounter_lowPE_highNorm + 1;
                    elseif(strcmp(chosenFace,'distractor'))
                        distractorCounter_lowPE_highNorm = distractorCounter_lowPE_highNorm + 1;
                    end

                end % End of if currentTrialNorm == 'low'

            end % End of if currentTrialPE == 'high'
            
        end % End of if trialWeWant
    end % End of for loop i which goes through the dataStructure
    
    
    disp(['fitPF_NormEffect distractorCounter: ' num2str(distractorCounter)]); %[delete this]
    
    % =====================================================================
    % ============================   High PE   ============================
    % =====================================================================
    
    % ***********************   High Norm   ***********************
    
    % Sort the zScoreDiffs
    [zScoreDiffs_highPE_highNorm_sorted, sortingIndex] = sort(zScoreDiff_highPE_highNorm_Array);
    
    % Sort the target chosen trials
    targetChosen_highPE_highNorm_sorted = targetChosen_highPE_highNorm_Array(sortingIndex);
    
    % ---- Bin the data dynamically into 4 bins ----
    
    % Get the index of the first positive number
    halfwayIndex = find(zScoreDiffs_highPE_highNorm_sorted > 0, 1);
    
    % Cut that in half and floor to get the index of partition
    quarterPoint1 = floor(halfwayIndex/2);
    
    % Get the second half and cut that in half
    quarterPoint3 = floor(halfwayIndex + (floor(length(zScoreDiffs_highPE_highNorm_sorted)-halfwayIndex)/2));
    
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
            currentIndices = (quarterPoint3+1):length(zScoreDiffs_highPE_highNorm_sorted);
        end
        
        % Fill in the total trials per bin
        highPE_highNorm_binCounter(i) = length(currentIndices);
        
        % Get the current array of zScoreDiffs for this bin
        current_ZScoreDiff_array = zScoreDiffs_highPE_highNorm_sorted(currentIndices);
        
        % Get the current array of targetChosen for this bin
        current_targetChosen_array = targetChosen_highPE_highNorm_sorted(currentIndices);
        
        % Calculate the target chosenBinCounter
        % Count the ones or zeros depending if it is in the first two
        % bins or not
        if(i == 1 || i == 2)
            highPE_highNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 0);
        else
            highPE_highNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 1);
        end
        
        % Calculate the percentChosen and store it into the array
        highPE_highNorm_percentChosenTarget(i) = highPE_highNorm_targetChosenBinCounter(i)/highPE_highNorm_binCounter(i);
        
        % Calculate the binCenters
        highPE_highNorm_binCenter(i) = mean(current_ZScoreDiff_array);
        
    end % End of for i = 1:4
    
    
    
    % ------ Curve fitting ------

    
    % Fit the curve
    [highPE_highNorm_paramsValues, highPE_highNorm_LL, highPE_highNorm_exitflag] = PAL_PFML_Fit(highPE_highNorm_binCenter,...
        highPE_highNorm_targetChosenBinCounter, highPE_highNorm_binCounter, searchGrid, paramsFree, PF);
    
    % Test the goodness of fit
%      [highPE_highNorm_Dev, highPE_highNorm_pDev, highPE_highNorm_DevSim, highPE_highNorm_converged] = PAL_PFML_GoodnessOfFit(highPE_highNorm_binCenter, ...
%          highPE_highNorm_targetChosenBinCounter, highPE_highNorm_binCounter, highPE_highNorm_paramsValues, paramsFree, B, PF, ...
%          'searchGrid', searchGrid);
    
    % Return the sum of the converged
%      highPE_highNorm_converged = sum(highPE_highNorm_converged);
    
    
    
   % ***********************   Low Norm   ***********************
    
    % Sort the zScoreDiffs
    [zScoreDiffs_highPE_lowNorm_sorted, sortingIndex] = sort(zScoreDiff_highPE_lowNorm_Array);
    
    % Sort the target chosen trials
    targetChosen_highPE_lowNorm_sorted = targetChosen_highPE_lowNorm_Array(sortingIndex);
    
    % ---- Bin the data dynamically into 4 bins ---- (13 per bin if 52 trials)
    
    % Get the index of the first positive number
    halfwayIndex = find(zScoreDiffs_highPE_lowNorm_sorted > 0, 1);
    
    % Cut that in half and floor to get the index of partition
    quarterPoint1 = floor(halfwayIndex/2);
    
    % Get the second half and cut that in half
    quarterPoint3 = floor(halfwayIndex + (floor(length(zScoreDiffs_highPE_lowNorm_sorted)-halfwayIndex)/2));
    
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
            currentIndices = (quarterPoint3+1):length(zScoreDiffs_highPE_lowNorm_sorted);
        end
        
        % Fill in the total trials per bin
        highPE_lowNorm_binCounter(i) = length(currentIndices);
        
        % Get the current array of zScoreDiffs for this bin
        current_ZScoreDiff_array = zScoreDiffs_highPE_lowNorm_sorted(currentIndices);
        
        % Get the current array of targetChosen for this bin
        current_targetChosen_array = targetChosen_highPE_lowNorm_sorted(currentIndices);
        
        % Calculate the target chosenBinCounter
        % Count the ones or zeros depending if it is in the first two
        % bins or not
        if(i == 1 || i == 2)
            highPE_lowNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 0);
        else
            highPE_lowNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 1);
        end
        
        % Calculate the percentChosen and store it into the array
        highPE_lowNorm_percentChosenTarget(i) = highPE_lowNorm_targetChosenBinCounter(i)/highPE_lowNorm_binCounter(i);
        
        % Calculate the binCenters
        highPE_lowNorm_binCenter(i) = mean(current_ZScoreDiff_array);
        
    end % End of for i = 1:4
    
    
    
    % ------ Curve fitting ------

    
    % Fit the curve
    [highPE_lowNorm_paramsValues, highPE_lowNorm_LL, highPE_lowNorm_exitflag] = PAL_PFML_Fit(highPE_lowNorm_binCenter,...
        highPE_lowNorm_targetChosenBinCounter, highPE_lowNorm_binCounter, searchGrid, paramsFree, PF);
    
    % Test the goodness of fit
%     [highPE_lowNorm_Dev, highPE_lowNorm_pDev, highPE_lowNorm_DevSim, highPE_lowNorm_converged] = PAL_PFML_GoodnessOfFit(highPE_lowNorm_binCenter, ...
%         highPE_lowNorm_targetChosenBinCounter, highPE_lowNorm_binCounter, highPE_lowNorm_paramsValues, paramsFree, B, PF, ...
%         'searchGrid', searchGrid);
    
    % Return the sum of the converged
%     highPE_lowNorm_converged = sum(highPE_lowNorm_converged);
    
    
    
    % =====================================================================
    % ============================   Low PE   =============================
    % =====================================================================
    
    % ***********************   High Norm   ***********************
    
    % Sort the zScoreDiffs
    [zScoreDiffs_lowPE_highNorm_sorted, sortingIndex] = sort(zScoreDiff_lowPE_highNorm_Array);
    
    % Sort the target chosen trials
    targetChosen_lowPE_highNorm_sorted = targetChosen_lowPE_highNorm_Array(sortingIndex);
    
    % ---- Bin the data dynamically into 4 bins ----
    
    % Get the index of the first positive number
    halfwayIndex = find(zScoreDiffs_lowPE_highNorm_sorted > 0, 1);
    
    % Cut that in half and floor to get the index of partition
    quarterPoint1 = floor(halfwayIndex/2);
    
    % Get the second half and cut that in half
    quarterPoint3 = floor(halfwayIndex + (floor(length(zScoreDiffs_lowPE_highNorm_sorted)-halfwayIndex)/2));
    
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
            currentIndices = (quarterPoint3+1):length(zScoreDiffs_lowPE_highNorm_sorted);
        end
        
        % Fill in the total trials per bin
        lowPE_highNorm_binCounter(i) = length(currentIndices);
        
        % Get the current array of zScoreDiffs for this bin
        current_ZScoreDiff_array = zScoreDiffs_lowPE_highNorm_sorted(currentIndices);
        
        % Get the current array of targetChosen for this bin
        current_targetChosen_array = targetChosen_lowPE_highNorm_sorted(currentIndices);
        
        % Calculate the target chosenBinCounter
        % Count the ones or zeros depending if it is in the first two
        % bins or not
        if(i == 1 || i == 2)
            lowPE_highNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 0);
        else
            lowPE_highNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 1);
        end
        
        % Calculate the percentChosen and store it into the array
        lowPE_highNorm_percentChosenTarget(i) = lowPE_highNorm_targetChosenBinCounter(i)/lowPE_highNorm_binCounter(i);
        
        % Calculate the binCenters
        lowPE_highNorm_binCenter(i) = mean(current_ZScoreDiff_array);
        
    end % End of for i = 1:4
    
    
    
    % ------ Curve fitting ------

    
    % Fit the curve
    [lowPE_highNorm_paramsValues, lowPE_highNorm_LL, lowPE_highNorm_exitflag] = PAL_PFML_Fit(lowPE_highNorm_binCenter,...
        lowPE_highNorm_targetChosenBinCounter, lowPE_highNorm_binCounter, searchGrid, paramsFree, PF);
    
    % Test the goodness of fit
%      [lowPE_highNorm_Dev, lowPE_highNorm_pDev, lowPE_highNorm_DevSim, lowPE_highNorm_converged] = PAL_PFML_GoodnessOfFit(lowPE_highNorm_binCenter, ...
%          lowPE_highNorm_targetChosenBinCounter, lowPE_highNorm_binCounter, lowPE_highNorm_paramsValues, paramsFree, B, PF, ...
%          'searchGrid', searchGrid);
    
    % Return the sum of the converged
%      lowPE_highNorm_converged = sum(lowPE_highNorm_converged);
    
    
    
   % ***********************   Low Norm   ***********************
    
    % Sort the zScoreDiffs
    [zScoreDiffs_lowPE_lowNorm_sorted, sortingIndex] = sort(zScoreDiff_lowPE_lowNorm_Array);
    
    % Sort the target chosen trials
    targetChosen_lowPE_lowNorm_sorted = targetChosen_lowPE_lowNorm_Array(sortingIndex);
    
    % ---- Bin the data dynamically into 4 bins ---- (13 per bin if 52 trials)
    
    % Get the index of the first positive number
    halfwayIndex = find(zScoreDiffs_lowPE_lowNorm_sorted > 0, 1);
    
    % Cut that in half and floor to get the index of partition
    quarterPoint1 = floor(halfwayIndex/2);
    
    % Get the second half and cut that in half
    quarterPoint3 = floor(halfwayIndex + (floor(length(zScoreDiffs_lowPE_lowNorm_sorted)-halfwayIndex)/2));
    
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
            currentIndices = (quarterPoint3+1):length(zScoreDiffs_lowPE_lowNorm_sorted);
        end
        
        % Fill in the total trials per bin
        lowPE_lowNorm_binCounter(i) = length(currentIndices);
        
        % Get the current array of zScoreDiffs for this bin
        current_ZScoreDiff_array = zScoreDiffs_lowPE_lowNorm_sorted(currentIndices);
        
        % Get the current array of targetChosen for this bin
        current_targetChosen_array = targetChosen_lowPE_lowNorm_sorted(currentIndices);
        
        % Calculate the target chosenBinCounter
        % Count the ones or zeros depending if it is in the first two
        % bins or not
        if(i == 1 || i == 2)
            lowPE_lowNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 0);
        else
            lowPE_lowNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 1);
        end
        
        % Calculate the percentChosen and store it into the array
        lowPE_lowNorm_percentChosenTarget(i) = lowPE_lowNorm_targetChosenBinCounter(i)/lowPE_lowNorm_binCounter(i);
        
        % Calculate the binCenters
        lowPE_lowNorm_binCenter(i) = mean(current_ZScoreDiff_array);
        
    end % End of for i = 1:4
    
    
    
    % ------ Curve fitting ------

    
    % Fit the curve
    [lowPE_lowNorm_paramsValues, lowPE_lowNorm_LL, lowPE_lowNorm_exitflag] = PAL_PFML_Fit(lowPE_lowNorm_binCenter,...
        lowPE_lowNorm_targetChosenBinCounter, lowPE_lowNorm_binCounter, searchGrid, paramsFree, PF);
    
    % Test the goodness of fit
%     [lowPE_lowNorm_Dev, lowPE_lowNorm_pDev, lowPE_lowNorm_DevSim, lowPE_lowNorm_converged] = PAL_PFML_GoodnessOfFit(lowPE_lowNorm_binCenter, ...
%         lowPE_lowNorm_targetChosenBinCounter, lowPE_lowNorm_binCounter, lowPE_lowNorm_paramsValues, paramsFree, B, PF, ...
%         'searchGrid', searchGrid);
    
    % Return the sum of the converged
%     lowPE_lowNorm_converged = sum(lowPE_lowNorm_converged);
   
   
    % =====================================================================
    % =========================  CURVE PLOTTING  ==========================
    % =====================================================================
    
   
   
    % Get the fit for the different conditions
    highPE_highNorm_fit =  PF(highPE_highNorm_paramsValues,stimLevelsFine);
    highPE_lowNorm_fit =  PF(highPE_lowNorm_paramsValues,stimLevelsFine);
    lowPE_highNorm_fit =  PF(lowPE_highNorm_paramsValues,stimLevelsFine);
    lowPE_lowNorm_fit =  PF(lowPE_lowNorm_paramsValues,stimLevelsFine);
        
    % New figure
    figure;
    
    % -- highPE && HighNorm --
    hold on;
    % Plot the points
    plot(highPE_highNorm_binCenter, highPE_highNorm_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', highPE_highNorm_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h1 = plot(stimLevelsFine, highPE_highNorm_fit, 'Color', highPE_highNorm_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
    % -- highPE && LowNorm --
    hold on;
    % Plot the points
    plot(highPE_lowNorm_binCenter, highPE_lowNorm_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', highPE_lowNorm_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h2 = plot(stimLevelsFine, highPE_lowNorm_fit, 'Color', highPE_lowNorm_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
    % -- lowPE && HighNorm --
    hold on;
    % Plot the points
    plot(lowPE_highNorm_binCenter, lowPE_highNorm_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', lowPE_highNorm_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h3 = plot(stimLevelsFine, lowPE_highNorm_fit, 'Color', lowPE_highNorm_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
    % -- lowPE && LowNorm --
    hold on;
    % Plot the points
    plot(lowPE_lowNorm_binCenter, lowPE_lowNorm_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', lowPE_lowNorm_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h4 = plot(stimLevelsFine, lowPE_lowNorm_fit, 'Color', lowPE_lowNorm_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
    % ------ Formatting ------
    
    % Format the axes
    set(gca,'fontsize', fontSize);
    axis([xMin xMax yMin yMax]);
    
    % Add in the legend
    legend([h1 h2 h3 h4], {'highPE - highNorm', 'highPE - lowNorm', 'lowPE - highNorm', 'lowPE - lowNorm'}, 'Location', 'SouthEast');
    
    
    % ------ Saving ------
    
    % Only save the figure if we want to
    if(saveFigure)
    
        % Create the file name and path to save
        savingFileName = ['subject_' num2str(subjectNumber) '_PE_Norm_PF.jpg'];
        savingFilePath = [pwd '/Figures/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);
    
    end
   
   % =================== OUTPUT ===================
   
   paramValues = [highPE_highNorm_paramsValues;...
                  highPE_lowNorm_paramsValues;...
                  lowPE_highNorm_paramsValues;...
                  lowPE_lowNorm_paramsValues];
              
   chosenFaces = [targetCounter_highPE_highNorm, nontargetCounter_highPE_highNorm, distractorCounter_highPE_highNorm, mean(confidence_highPE_highNorm_Array); ...
                  targetCounter_highPE_lowNorm , nontargetCounter_highPE_lowNorm , distractorCounter_highPE_lowNorm , mean(confidence_highPE_lowNorm_Array) ; ...
                  targetCounter_lowPE_highNorm , nontargetCounter_lowPE_highNorm , distractorCounter_lowPE_highNorm , mean(confidence_lowPE_highNorm_Array) ; ...
                  targetCounter_lowPE_lowNorm  , nontargetCounter_lowPE_lowNorm  , distractorCounter_lowPE_lowNorm  , mean(confidence_lowPE_lowNorm_Array)   ];
    
    
end % End of function