function paramValues = fitPsychometricFunction_Norm(dataStructure, subjectNumber)
    
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
    HighNorm_Color = [222,   0, 222]./255; % Dark Purple
    LowNorm_Color =  [255, 150, 255]./255; % Light Purple
    
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
    
    % High Norm
    zScoreDiff_HighNorm_Array = [];
    targetChosen_HighNorm_Array = [];
    zScoreDistractor_HighNorm_Array = [];
    
    % Low Norm
    zScoreDiff_LowNorm_Array = [];
    targetChosen_LowNorm_Array = [];
    zScoreDistractor_LowNorm_Array = [];
    
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
            
            % Check if subject chose the distractor face for this trial
            subjectChoseDistractor = strcmp(dataStructure.chosenFace{i}, 'distractor');
            
            % If the subject chose the distractor
            if(subjectChoseDistractor)
                
                % Increment the counter
                distractorCounter = distractorCounter + 1;
                
            % Else they chose either the target or non-target and we move
            % on
            else
            
                % Get the current zScoreDiff
                currentZScoreDiff = dataStructure.zScoreDiff(i);

                % If the non-target came first, then we need to add a
                % negative sign to the zScoreDiff

                % If the first face is a non-target, or second face is
                % non-target AND first face is distractor
                % In the form: if( x || (y && z))
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

                % Else it is a low PE trial
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

                if(strcmp(currentTrialNorm, 'low'))

                    % Log it in as 1 or 0 in the array depending on whether the
                    % subject chose the target
                    targetChosen_LowNorm_Array(length(targetChosen_LowNorm_Array)+1, 1) = double(subjectChoseTarget);

                    % Fill in the array with the zScoreDiff
                    zScoreDiff_LowNorm_Array(length(zScoreDiff_LowNorm_Array)+1, 1) = currentZScoreDiff;

                    % Fill in the array with the zScore of the distractor
                    zScoreDistractor_LowNorm_Array(length(zScoreDistractor_LowNorm_Array)+1, 1) = currentDistractorZScore;


                elseif(strcmp(currentTrialNorm, 'high'))

                    % Log it in as 1 or 0 in the array depending on whether the
                    % subject chose the target
                    targetChosen_HighNorm_Array(length(targetChosen_HighNorm_Array)+1, 1) = double(subjectChoseTarget);

                    % Fill in the array with the zScoreDiff
                    zScoreDiff_HighNorm_Array(length(zScoreDiff_HighNorm_Array)+1, 1) = currentZScoreDiff;

                    % Fill in the array with the zScore of the distractor
                    zScoreDistractor_HighNorm_Array(length(zScoreDistractor_HighNorm_Array)+1, 1) = currentDistractorZScore;

                end % End of if currentTrialNorm == 'low'
                
            end % End of if subjectChoseDistractor
            
        end % End of if trialWeWant
    end % End of for loop i which goes through the dataStructure
    
    
    disp(['fitPF_NormEffect distractorCounter: ' num2str(distractorCounter)]); %[delete this]
    
    
    % ***********************   High Norm   ***********************
    
    % Sort the zScoreDiffs
    [zScoreDiffs_HighNorm_sorted, sortingIndex] = sort(zScoreDiff_HighNorm_Array);
    
    % Sort the target chosen trials
    targetChosen_HighNorm_sorted = targetChosen_HighNorm_Array(sortingIndex);
    
    % ---- Bin the data dynamically into 4 bins ----
    
    % Get the index of the first positive number
    halfwayIndex = find(zScoreDiffs_HighNorm_sorted > 0, 1);
    
    % Cut that in half and floor to get the index of partition
    quarterPoint1 = floor(halfwayIndex/2);
    
    % Get the second half and cut that in half
    quarterPoint3 = floor(halfwayIndex + (floor(length(zScoreDiffs_HighNorm_sorted)-halfwayIndex)/2));
    
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
            currentIndices = (quarterPoint3+1):length(zScoreDiffs_HighNorm_sorted);
        end
        
        % Fill in the total trials per bin
        HighNorm_binCounter(i) = length(currentIndices);
        
        % Get the current array of zScoreDiffs for this bin
        current_ZScoreDiff_array = zScoreDiffs_HighNorm_sorted(currentIndices);
        
        % Get the current array of targetChosen for this bin
        current_targetChosen_array = targetChosen_HighNorm_sorted(currentIndices);
        
        % Calculate the target chosenBinCounter
        % Count the ones or zeros depending if it is in the first two
        % bins or not
        if(i == 1 || i == 2)
            HighNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 0);
        else
            HighNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 1);
        end
        
        % Calculate the percentChosen and store it into the array
        HighNorm_percentChosenTarget(i) = HighNorm_targetChosenBinCounter(i)/HighNorm_binCounter(i);
        
        % Calculate the binCenters
        HighNorm_binCenter(i) = mean(current_ZScoreDiff_array);
        
    end % End of for i = 1:4
    
    
    
    % ------ Curve fitting ------

    
    % Fit the curve
    [HighNorm_paramsValues, HighNorm_LL, HighNorm_exitflag] = PAL_PFML_Fit(HighNorm_binCenter,...
        HighNorm_targetChosenBinCounter, HighNorm_binCounter, searchGrid, paramsFree, PF);
    
    % Test the goodness of fit
%     [HighNorm_Dev, HighNorm_pDev, HighNorm_DevSim, HighNorm_converged] = PAL_PFML_GoodnessOfFit(HighNorm_binCenter, ...
%         HighNorm_targetChosenBinCounter, HighNorm_binCounter, HighNorm_paramsValues, paramsFree, B, PF, ...
%         'searchGrid', searchGrid);
    
    % Return the sum of the converged
%     HighNorm_converged = sum(HighNorm_converged);
    
    
    
   % ***********************   Low Norm   ***********************
    
    % Sort the zScoreDiffs
    [zScoreDiffs_LowNorm_sorted, sortingIndex] = sort(zScoreDiff_LowNorm_Array);
    
    % Sort the target chosen trials
    targetChosen_LowNorm_sorted = targetChosen_LowNorm_Array(sortingIndex);
    
    % ---- Bin the data dynamically into 4 bins ---- (13 per bin if 52 trials)
    
    % Get the index of the first positive number
    halfwayIndex = find(zScoreDiffs_LowNorm_sorted > 0, 1);
    
    % Cut that in half and floor to get the index of partition
    quarterPoint1 = floor(halfwayIndex/2);
    
    % Get the second half and cut that in half
    quarterPoint3 = floor(halfwayIndex + (floor(length(zScoreDiffs_LowNorm_sorted)-halfwayIndex)/2));
    
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
            currentIndices = (quarterPoint3+1):length(zScoreDiffs_LowNorm_sorted);
        end
        
        % Fill in the total trials per bin
        LowNorm_binCounter(i) = length(currentIndices);
        
        % Get the current array of zScoreDiffs for this bin
        current_ZScoreDiff_array = zScoreDiffs_LowNorm_sorted(currentIndices);
        
        % Get the current array of targetChosen for this bin
        current_targetChosen_array = targetChosen_LowNorm_sorted(currentIndices);
        
        % Calculate the target chosenBinCounter
        % Count the ones or zeros depending if it is in the first two
        % bins or not
        if(i == 1 || i == 2)
            LowNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 0);
        else
            LowNorm_targetChosenBinCounter(i) = sum(current_targetChosen_array == 1);
        end
        
        % Calculate the percentChosen and store it into the array
        LowNorm_percentChosenTarget(i) = LowNorm_targetChosenBinCounter(i)/LowNorm_binCounter(i);
        
        % Calculate the binCenters
        LowNorm_binCenter(i) = mean(current_ZScoreDiff_array);
        
    end % End of for i = 1:4
    
    
    
    % ------ Curve fitting ------

    
    % Fit the curve
    [LowNorm_paramsValues, LowNorm_LL, LowNorm_exitflag] = PAL_PFML_Fit(LowNorm_binCenter,...
        LowNorm_targetChosenBinCounter, LowNorm_binCounter, searchGrid, paramsFree, PF);
    
    % Test the goodness of fit
%     [LowNorm_Dev, LowNorm_pDev, LowNorm_DevSim, LowNorm_converged] = PAL_PFML_GoodnessOfFit(LowNorm_binCenter, ...
%         LowNorm_targetChosenBinCounter, LowNorm_binCounter, LowNorm_paramsValues, paramsFree, B, PF, ...
%         'searchGrid', searchGrid);
    
    % Return the sum of the converged
%     LowNorm_converged = sum(LowNorm_converged);
    
   
   % ***********************  CURVE PLOTTING  ***********************
   
   
    % Get the fit for the different conditions
    HighNorm_fit =  PF(HighNorm_paramsValues,stimLevelsFine);
    LowNorm_fit =  PF(LowNorm_paramsValues,stimLevelsFine);
        
    % New figure
    figure;
    
    % -- HighNorm --
    hold on;
    % Plot the points
    plot(HighNorm_binCenter, HighNorm_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', HighNorm_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h1 = plot(stimLevelsFine, HighNorm_fit, 'Color', HighNorm_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
    % -- LowNorm --
    hold on;
    % Plot the points
    plot(LowNorm_binCenter, LowNorm_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', LowNorm_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h2 = plot(stimLevelsFine, LowNorm_fit, 'Color', LowNorm_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
    % ------ Formatting ------
    
    % Format the axes
    set(gca,'fontsize', fontSize);
    axis([xMin xMax yMin yMax]);
    
    % Add in the legend
    legend([h1 h2], {'HighNorm', 'LowNorm'}, 'Location', 'SouthEast');
    
    
    % ------ Saving ------
    
    % Only save the figure if we want to
    if(saveFigure)
    
        % Create the file name and path to save
        savingFileName = ['subject_' num2str(subjectNumber) '_Norm_PF.jpg'];
        savingFilePath = [pwd '/Figures/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);
    
    end
   
   % =================== OUTPUT ===================
   
   paramValues = [HighNorm_paramsValues;...
                  LowNorm_paramsValues];
    
    
end % End of function