function currentSubject3DPlotData = extract3DPlotData(dataStructure, subjectNumber)
    
    % Number of bins for distractor
    nBins = 4;
    
    % Saving the figure
    saveFigure = 0; 
    
    % Variables for the axes of 3D plot
    X = [];
    Y = [];
    Z = [];
    
    % Get the indices of 3AFC trials where subjects chose the target
    AFC3_choseTarget_indices = returnIndicesIntersect(dataStructure.trialType,'3AFC', dataStructure.chosenFace, 'target');
    % Get the indices of 3AFC and where the subject chose the non-target
    AFC3_choseNonTarget_indices = returnIndicesIntersect(dataStructure.trialType,'3AFC', dataStructure.chosenFace, 'non-target');
    
    % Combine and sort them
    AFC3_choseTargetNonTarget_indices = sort([AFC3_choseTarget_indices; AFC3_choseNonTarget_indices]);

    % Get the z score of the faces of the valid trials
    zDistractors = dataStructure.distractorZScore(AFC3_choseTargetNonTarget_indices);
    zTarget = dataStructure.targetZScore(AFC3_choseTargetNonTarget_indices);
    zNonTarget = dataStructure.nonTargetZScore(AFC3_choseTargetNonTarget_indices);
    zTarget_minus_zScoreNonTarget = zTarget - zNonTarget;
    
    % Get the binary array of whether the subject chose the target array
    choseTarget = ismember(dataStructure.chosenFace(AFC3_choseTargetNonTarget_indices),'target'); 
    
    % Order the distractor and get everything to order with it
    [zDistractors, sortingIndex] = sort(zDistractors);
    zTarget = zTarget(sortingIndex);
    zNonTarget = zNonTarget(sortingIndex);
    zTarget_minus_zScoreNonTarget = zTarget_minus_zScoreNonTarget(sortingIndex);
    choseTarget = choseTarget(sortingIndex);
    
    % Split into 4 bins for distractors
    % For loop that fills in each bin
    for i = 1:nBins
        
        % Determine the start and end of the current bin indices
        currentIndicesStart = floor(((i-1)/nBins)*length(zDistractors)) + 1;
        currentIndicesEnd = floor((i/nBins)*length(zDistractors));
        
        % Define the current Indices
        currentIndices = currentIndicesStart:currentIndicesEnd;
        
        % --- Make the calculations ---
        
        % Fill in the distractorBinCenter
        distractorBinCenter(i,1) = mean(zDistractors(currentIndices));
        
        % Split the indices for the two zT-zNT
        zT_minus_zNT_indices1 = currentIndicesStart:floor(((currentIndicesEnd-currentIndicesStart)/2)+currentIndicesStart);
        zT_minus_zNT_indices2 = floor(((currentIndicesEnd-currentIndicesStart)/2)+currentIndicesStart):currentIndicesEnd;
        
        % Split the zT-zNT into two bins
        zT_minus_zNT_binCenter(i,1) = mean(zTarget_minus_zScoreNonTarget(zT_minus_zNT_indices1));
        zT_minus_zNT_binCenter(i,2) = mean(zTarget_minus_zScoreNonTarget(zT_minus_zNT_indices2));
        
        % Calculate the %ChosenTarget for each sub-bin
        averageTargetChosen(i,1) = sum(choseTarget(zT_minus_zNT_indices1))/length(choseTarget(zT_minus_zNT_indices1));
        averageTargetChosen(i,2) = sum(choseTarget(zT_minus_zNT_indices2))/length(choseTarget(zT_minus_zNT_indices2));
        
        % --- Fit into X, Y, and Z ---
        X = [X; zT_minus_zNT_binCenter(i,1); zT_minus_zNT_binCenter(i,2)];
        Y = [Y; distractorBinCenter(i,1); distractorBinCenter(i,1)];
        Z = [Z; averageTargetChosen(i,1); averageTargetChosen(i,2)];
        
    end % End of for loop
    
    % --- Enter data and return ---
    currentSubject3DPlotData.distractorBinCenter = distractorBinCenter;
    currentSubject3DPlotData.zT_minus_zNT_binCenter = zT_minus_zNT_binCenter;
    currentSubject3DPlotData.averageTargetChosen = averageTargetChosen;
    currentSubject3DPlotData.X = X;
    currentSubject3DPlotData.Y = Y;
    currentSubject3DPlotData.Z = Z;
    
    % --- Plot the data ---
    
    % Order them into vectors
    figure;
    scatter3(X,Y,Z);
    
    % Axis labels
    xlabel('zTarget-zNonTarget');
    ylabel('zDistractor');
    zlabel('% target chosen');
    
    % Axis limits
    xlim([0 4]);
    ylim([-3 3]);
    zlim([0 1]);
    
    % ------ Saving ------
    
    % Only save the figure if we want to
    if(saveFigure)
    
        % Create the file name and path to save
        savingFileName = ['subject_' num2str(subjectNumber) '_3DPlot.jpg'];
        savingFilePath = [pwd '/Figures/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);
    
    end
    
    
end % End of function