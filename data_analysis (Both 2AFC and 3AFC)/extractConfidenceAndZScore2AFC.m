function output = extractConfidenceAndZScore2AFC(dataStructure)

    % ---- Confidence ----

    % Get the indices of the trials of 2AFC Confidence trials
    AFC2Confidence_indices = returnIndices(dataStructure.trialType,'2AFC Confidence');

    % Get the indices of the high/low PE trials
    highPE_indices = returnIndices(dataStructure.PE,'high');
    lowPE_indices = returnIndices(dataStructure.PE,'low');

    % Intersect them to get the indices of 2AFC Confidence and high/low PE trials
    highPE_2AFCConfidence_indices = intersect(AFC2Confidence_indices,highPE_indices);
    lowPE_2AFCConfidence_indices = intersect(AFC2Confidence_indices,lowPE_indices);

    % Get the confidences of the high/low PE trials
    highPE_2AFC_confidence = dataStructure.response(highPE_2AFCConfidence_indices);
    lowPE_2AFC_confidence = dataStructure.response(lowPE_2AFCConfidence_indices);
    
    % Calculate the mean
    highPE_2AFC_Confidence_mean = mean(highPE_2AFC_confidence);
    lowPE_2AFC_Confidence_mean = mean(lowPE_2AFC_confidence);
    
    % Store the mean into our store
    %highPE_2AFC_Confidence_All(length(highPE_2AFC_Confidence_All)+1,1) = mean(highPE_2AFC_confidence);
    %lowPE_2AFC_Confidence_All(length(lowPE_2AFC_Confidence_All)+1,1) = mean(lowPE_2AFC_confidence);

    % ---- zScoreDiff ----

    % Get the indices of the trials of 2AFC  trials
    AFC2_indices = returnIndices(dataStructure.trialType,'2AFC');

    % Intersect them to get the indices of 2AFC and high/low PE trials
    highPE_2AFC_indices = intersect(AFC2_indices,highPE_indices);
    lowPE_2AFC_indices = intersect(AFC2_indices,lowPE_indices);

    % Get the difference in zScores
    highPE_2AFC_zScoreDiff = dataStructure.zScoreDiff(highPE_2AFC_indices);
    lowPE_2AFC_zScoreDiff = dataStructure.zScoreDiff(lowPE_2AFC_indices);
    
    % Calculate the mean
    highPE_2AFC_zScoreDiff_mean = mean(highPE_2AFC_zScoreDiff);
    lowPE_2AFC_zScoreDiff_mean = mean(lowPE_2AFC_zScoreDiff);
    
    % Store the mean into our store
    %highPE_2AFC_zScoreDiff_All(length(highPE_2AFC_zScoreDiff_All)+1,1)  = mean(highPE_2AFC_zScoreDiff);
    %lowPE_2AFC_zScoreDiff_All(length(lowPE_2AFC_zScoreDiff_All)+1,1)  = mean(lowPE_2AFC_zScoreDiff);
    
    % ---- Return ----
    
    output = [highPE_2AFC_Confidence_mean, lowPE_2AFC_Confidence_mean, highPE_2AFC_zScoreDiff_mean, lowPE_2AFC_zScoreDiff_mean];
    
end