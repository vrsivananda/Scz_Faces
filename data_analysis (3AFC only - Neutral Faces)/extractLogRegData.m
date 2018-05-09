function currentSubjectLogRegData = extractLogRegData(dataStructure)
    
    % Get the indices of 3AFC trials where subjects chose the target
    AFC3_choseTarget_indices = returnIndicesIntersect(dataStructure.trialType,'3AFC', dataStructure.chosenFace, 'target');
    % Get the indices of 3AFC and where the subject chose the non-target
    AFC3_choseNonTarget_indices = returnIndicesIntersect(dataStructure.trialType,'3AFC', dataStructure.chosenFace, 'non-target');
    
    % Combine and sort them
    AFC3_choseTargetNonTarget_indices = sort([AFC3_choseTarget_indices; AFC3_choseNonTarget_indices]);
    
    % Get the binary array of whether the subject chose the target array
    choseTarget = ismember(dataStructure.chosenFace(AFC3_choseTargetNonTarget_indices),'target');
    
    % Index out the relevant arrays
    zTarget = dataStructure.targetZScore(AFC3_choseTargetNonTarget_indices);
    zNonTarget = dataStructure.nonTargetZScore(AFC3_choseTargetNonTarget_indices);
    zDistractor = dataStructure.distractorZScore(AFC3_choseTargetNonTarget_indices);
    zTarget_minus_zNonTarget = zTarget - zNonTarget;
    zNonTarget_minus_zDistractor = zNonTarget - zDistractor;
    
    % Place them in a data structure to be returned
    currentSubjectLogRegData.zTarget = zTarget;
    currentSubjectLogRegData.zNonTarget = zNonTarget;
    currentSubjectLogRegData.zDistractor = zDistractor;
    currentSubjectLogRegData.zNonTarget_minus_zDistractor = zNonTarget_minus_zDistractor;
    currentSubjectLogRegData.zTarget_minus_zNonTarget = zTarget_minus_zNonTarget;
    currentSubjectLogRegData.choseTarget = choseTarget;
    
    
    
end % End of function