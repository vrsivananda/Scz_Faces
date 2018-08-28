function fitPF_attractivenessRatings(dataStructure, nValidSubjects, subjectOrPatient, saveFigure)
    
    % ====== PARAMETERS BEGIN ======
    
    % The number of simulations to perform for goodness of fit test
    B = 1000;
    
    % The search grid
    searchGrid.alpha = -1:0.005:1; % Threshold (PSE ?)
    searchGrid.beta = 10.^(-1:0.25:10); % Slope
    searchGrid.gamma = 0; % Guess Rate
    searchGrid.lambda = 0; % Lapse Rate
    
    % Getting the ratings for each face
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
    
    
    
    % Get the indices of trials where the subject did not choose the
    % target or non-target (no distractor)
    targetIndices =  returnIndicesIntersect(dataStructure.chosenFace, 'target');
    nonTargetIndices = returnIndicesIntersect(dataStructure.chosenFace, 'non-target');
    TNT_Indices = sort([targetIndices; nonTargetIndices]);
    
    % Get the respective data arrays
    chosenFace = dataStructure.chosenFace(TNT_Indices);
    rating_T_Face = dataStructure.chosenFace(TNT_Indices);
    rating_NT_Face = dataStructure.chosenFace(TNT_Indices);
    
    
    
    
end % End of function