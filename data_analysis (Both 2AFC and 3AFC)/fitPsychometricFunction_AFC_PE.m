function [paramsValues, percentChosenTarget, binCounter, binCenter, exitflag, pDev, converged] = ...
        fitPsychometricFunction_AFC_PE(dataStructure, bins, PF, AFC, PE)
    
    % ====== PARAMETERS BEGIN ======
    
    % The number of simulations to perform for goodness of fit test
    B = 1000;
    
    % Dynamic Binning
    dynamicBinning = 1;
    
    % The search grid
    searchGrid.alpha = -1:0.005:1; % Threshold (PSE ?)
    searchGrid.beta = 10.^(-1:0.25:10); % Slope
    searchGrid.gamma = 0; % Guess Rate
    searchGrid.lambda = 0; % Lapse Rate
    
    
    % ====== PARAMETERS END ======
    
    % Counter for 'distractor' choice
    distractorCounter = 0;
    
    % If static binning
    if(~dynamicBinning)
    
        % --- Static binning ---

        % Create the counters for each bin
        binCounter = zeros(1,length(bins)-1); % Total
        targetChosenBinCounter = zeros(1,length(bins)-1); % Chosen Target
    
    % Else dynamic binning
    else
    
        % --- Dynamic binning ---

        % Store for the zScoreDiff
        zScoreDiff_Array = [];
        targetChosen_Array = [];
    
    end
    
    
    
    % --- Filling in the bins ---
    
    % For loop that goes through the dataStructure and updates the
    % corresponding bin
    for i = 1:length(dataStructure.zScoreDiff)
        
        % Check if this is the trial that we want
        
        % If there are only 4 arguments (no PE)
        if(nargin == 4)
            
            % The trial we want is the one that corresponds to the AFC
            trialWeWant = strcmp(dataStructure.trialType{i},AFC);
            
        % Else if we have PE to consider
        elseif(nargin == 5)
            
            % The trial we want is the one that corresponds to the AFC and
            % the PE
            trialWeWant = strcmp(dataStructure.trialType{i},AFC) && ...
                          strcmp(dataStructure.PE{i},PE);
            
        end % End of if
        
        % If it is the trial that we want
        if(trialWeWant)
            
            % Get the current zScoreDiff
            currentZScoreDiff = dataStructure.zScoreDiff(i);
            
            % Check if it is a 3AFC Trial
            is_3AFC_trial = strcmp(AFC,'3AFC');
            
            % If it is a 3AFC trial, we need to check the order of
            % target/non-target and check if the subject chose the
            % distractor face
            if(is_3AFC_trial)
                
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
                
                % Check if the subject chose the distractor
                subjectChoseDistractor = strcmp(dataStructure.chosenFace(i), 'distractor');
                
            end % End of if AFC == '3AFC'
            
            % If the subject chose the distractor face
            if(is_3AFC_trial && subjectChoseDistractor)
                
                % Increment the counter and move on to the next relevant
                % trial
                distractorCounter = distractorCounter + 1;
            
            % Else we continue with the binning    
            else
            
                % Check if the subject chose the target
                subjectChoseTarget = strcmp(dataStructure.chosenFace(i),'target');

                % If static binning
                if(~dynamicBinning)

                    % ****************** Static Binning Start ******************

                    % For loop that goes through the bins and fills it in
                    for j = 1:length(binCounter)

                        % If it goes into the bin
                        if(currentZScoreDiff >= bins(j) && currentZScoreDiff < bins(j+1))

                            % Increment the bin counter
                            binCounter(j) = binCounter(j) + 1;

                            % Check if they chose the target face
                            if(subjectChoseTarget)

                                % Increment the target chosen counter
                                targetChosenBinCounter(j) = targetChosenBinCounter(j) + 1;

                            end % End of inner if

                            % Once we have filled in the bin, exit out of the for
                            % loop
                            break;

                        end % End of if currentZScoreDiff >= ...
                    end % End of for loop j

                    % ****************** Static Binning End ******************

                % Else dynamic binning
                else

                    % ################## Dynamic Binning Start ##################

                    % Fill in the array with the zScoreDiff
                    zScoreDiff_Array(length(zScoreDiff_Array)+1, 1) = currentZScoreDiff;

                    % Check if they chose the target face
                    if(subjectChoseTarget)

                        % Log it in as '1' in the array
                        targetChosen_Array(length(targetChosen_Array)+1, 1) = 1;

                    % Else they did not choose the target
                    else

                        % Log it in as '0' in the array
                        targetChosen_Array(length(targetChosen_Array)+1, 1) = 0;

                    end % End of if subjectChoseTarget

                    % ################## Dynamic Binning End ##################

                end % End of if ~dynamicBinning
            
            end % End of if subjectChoseDistractor
            
        end % End of if trialWeWant
    end % End of for loop i which goes through the dataStructure
    
    % [delete this]
    disp(['fitPF_AFC_PE distractorCounter: ' num2str(distractorCounter)]);
    
    % If static binning
    if(~dynamicBinning)
        
        % Calculate the percent chosen for target face per bin
        percentChosenTarget = targetChosenBinCounter./binCounter;
        
        % Create the x-axis for the bins
        for i = 1:length(bins)-1
            binCenter(i) = mean([bins(i), bins(i+1)]);
        end % End of for loop
    
    % Else dynamic binning
    else
        
        % Sort the zScoreDiffs
        [zScoreDiffs_sorted, sortingIndex] = sort(zScoreDiff_Array);

        % Sort the target chosen trials
        targetChosen_sorted = targetChosen_Array(sortingIndex);

        % ---- Bin the data dynamically into 4 bins ----(13 per bin if 52 trials)

        % The number per bin 
        nPerBin = length(zScoreDiffs_sorted)/4;
        
        % Get the index of the first positive number
        halfwayIndex = find(zScoreDiffs_sorted > 0, 1);
        
        % Cut that in half and floor to get the index of partition
        quarterPoint1 = floor(halfwayIndex/2);
        
        % Get the second half and cut that in half
        quarterPoint3 = floor(halfwayIndex + (floor(length(zScoreDiffs_sorted)-halfwayIndex)/2));

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
                currentIndices = (quarterPoint3+1):length(zScoreDiffs_sorted);
            end
            
            % Fill in the total trials per bin
            binCounter(i) = length(currentIndices);
            
            % Get the current indices of array to process
            %currentIndices = (((i-1)*nPerBin)+1) : (nPerBin*i);
            
            % Get the current array of zScoreDiffs for this bin
            current_ZScoreDiff_array = zScoreDiffs_sorted(currentIndices);
            
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
            binCenter(i) = mean(current_ZScoreDiff_array);
            
        end % End of for i = 1:4
    
    end % End of if ~dynamicBinning
    
    
    
    % ------ Curve fitting ------
    
    % Choose the initial values
    paramsValues = [1 1 0 0];
    % Choose which are the free parameters
    paramsFree = [1 1 0 0]; % Fix the guess rate and lapse rate
    
    % Fit the curve
    [paramsValues, LL, exitflag] = PAL_PFML_Fit(binCenter,...
        targetChosenBinCounter, binCounter, searchGrid, paramsFree, PF)
    
    % Test the goodness of fit
    [Dev, pDev, DevSim, converged] = PAL_PFML_GoodnessOfFit(binCenter, ...
        targetChosenBinCounter, binCounter, paramsValues, paramsFree, B, PF, ...
        'searchGrid', searchGrid);
    
    % Return the sum of the converged
    converged = sum(converged);
    
end % End of function