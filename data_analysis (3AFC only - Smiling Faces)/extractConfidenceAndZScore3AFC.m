function output = extractConfidenceAndZScore3AFC(dataStructure)

    % ---- Confidence ----

    % Get the indices of the trials of 3AFC Confidence trials
    AFC3Confidence_indices = returnIndices(dataStructure.trialType,'3AFC Confidence');

    % Get the indices of the high/low PE trials
    highPE_indices = returnIndices(dataStructure.PE,'high');
    lowPE_indices = returnIndices(dataStructure.PE,'low');

    % Intersect them to get the indices of 3AFC Confidence and high/low PE trials
    highPE_3AFCConfidence_indices = intersect(AFC3Confidence_indices,highPE_indices);
    lowPE_3AFCConfidence_indices = intersect(AFC3Confidence_indices,lowPE_indices);

    % Get the confidences of the high/low PE trials
    highPE_3AFC_confidence = dataStructure.response(highPE_3AFCConfidence_indices);
    lowPE_3AFC_confidence = dataStructure.response(lowPE_3AFCConfidence_indices);
    
    % Calculate the mean
    highPE_3AFC_Confidence_mean = mean(highPE_3AFC_confidence);
    lowPE_3AFC_Confidence_mean = mean(lowPE_3AFC_confidence);

    % ---- zScoreDiff ----

    % Get the indices of the trials of 3AFC  trials
    AFC3_indices = returnIndices(dataStructure.trialType,'3AFC');

    % Intersect them to get the indices of 3AFC and high/low PE trials
    highPE_3AFC_indices = intersect(AFC3_indices,highPE_indices);
    lowPE_3AFC_indices = intersect(AFC3_indices,lowPE_indices);

    % Get the difference in zScores
    highPE_3AFC_zScoreDiff = dataStructure.zScoreDiff(highPE_3AFC_indices);
    lowPE_3AFC_zScoreDiff = dataStructure.zScoreDiff(lowPE_3AFC_indices);
    
    % Calculate the mean
    highPE_3AFC_zScoreDiff_mean = mean(highPE_3AFC_zScoreDiff);
    lowPE_3AFC_zScoreDiff_mean = mean(lowPE_3AFC_zScoreDiff);
    
    % ---- Return ----
    
    output = [highPE_3AFC_Confidence_mean, lowPE_3AFC_Confidence_mean, highPE_3AFC_zScoreDiff_mean, lowPE_3AFC_zScoreDiff_mean];
    
end