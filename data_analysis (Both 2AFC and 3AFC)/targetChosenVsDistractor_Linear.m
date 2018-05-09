function output = targetChosenVsDistractor_Linear(dataStructure, PE)
    
    % ===== PARAMETERS BEGIN =====
    
    % Number of bins
    nBins = 8;
    
    % ===== PARAMETERS END =====
    
    % If there is only 1 argument (not differentiated by PE)
    if(nargin == 1)
        % Get the indices of the 3AFC trials
        relevant_AFC3_indices = returnIndices(dataStructure.trialType,'3AFC');
    % Else if there are 2 arguments (differentiated by PE)
    elseif(nargin == 2)
        % Get the indices of 3AFC and the relevant PE trials
        relevant_AFC3_indices = returnIndicesIntersect(dataStructure.trialType,'3AFC', ...
                                                       dataStructure.PE,PE);
    end % End of if nargin
    
    % Define the arrays to store data
    chosenTarget_array = [];
    distractorZScore_array = [];
    
    % Define counter to count distractors
    distractorCounter = 0;
    
    % Go through the trials and fill in our array
    for i = relevant_AFC3_indices'
        
        % If they chose the target
        if(strcmp(dataStructure.chosenFace(i), 'target'))
            
            % Fill in the array with a 1
            chosenTarget_array(length(chosenTarget_array)+1,1) = 1;
            % Log in the zScore for the distractor
            distractorZScore_array(length(distractorZScore_array)+1,1) = dataStructure.distractorZScore(i);
        
            % Else if they chose the non-target
        elseif(strcmp(dataStructure.chosenFace(i), 'non-target'))
            
            % Fill in the array with a 0
            chosenTarget_array(length(chosenTarget_array)+1,1) = 0;
            % Log in the zScore for the distractor
            distractorZScore_array(length(distractorZScore_array)+1,1) = dataStructure.distractorZScore(i);
        
            % Else if they chose the distractor
        elseif(strcmp(dataStructure.chosenFace(i), 'distractor'))
            
            % Increment the distractor counter
            distractorCounter = distractorCounter + 1;
        
        end % End of if chosenFace == 'target'

    end % End of for loop
    
    % Sort both the arrays
    [distractorZScore_sorted, sortingIndex] = sort(distractorZScore_array);
    chosenTarget_sorted = chosenTarget_array(sortingIndex);
    
    % For loop that fills in each bin
    for i = 1:nBins
        
        % Determine the start and end of the current bin indices
        currentIndicesStart = floor(((i-1)/nBins)*length(distractorZScore_sorted)) + 1;
        currentIndicesEnd = floor((i/nBins)*length(distractorZScore_sorted));
        
        % Define the current Indices
        currentIndices = currentIndicesStart:currentIndicesEnd;
        
        % Load in the current arrays for easy handling
        currentDistractorZScore_array = distractorZScore_sorted(currentIndices);
        currentChosenTarget_array = chosenTarget_sorted(currentIndices);
        
        % Fill in the binCenter
        binCenter(i,1) = mean(currentDistractorZScore_array);
        
        % Calculate the average percent chosen
        averageTargetChosen(i,1) = sum(currentChosenTarget_array)/length(currentChosenTarget_array);
        
    end % End of for loop
    
    % --- Fit a linear regression line ---
    
    % Choose a color
    currentColor = rand(1,3);
    
    % Load in the data for easy handling
    x = binCenter;
    y = averageTargetChosen;
    
    % Pad the x to get the coefficients
    X = [ones(length(x),1), x];
    
    % Get the coefficient
    b = X\y;
    
    % Calculate the y's
    yReg = X*b;
    
    output.x = x;
    output.X = X;
    output.y = y;
    output.b = b;
    output.yReg = yReg;
    output.pDistractor = distractorCounter/length(relevant_AFC3_indices);
    
%     
%     % Make the scatter plot
%     scatter(x, y, 'markerFaceColor', currentColor, 'markerEdgeColor', currentColor);
%     hold on;
%     % Plot the new y's (the regression line)
%     plot(x, yReg, 'LineStyle', '-', 'Color', currentColor);
%     
%     % --- Formatting ---
%     
%     % Axis limits
%     xlim([-2.5, 1]);
%     ylim([0, 1]);
%     
%     % Axis labels
%     xlabel('zScore of Distractor Face');
%     ylabel('% Chosen Target Face');
%     
%     % Add the legend
%     legend('Binned Data','Regression Line','Location','SouthEast');
    
end