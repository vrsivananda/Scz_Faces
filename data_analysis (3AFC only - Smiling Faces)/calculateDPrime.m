function output = calculateDPrime(dataStructure)
    
    % -------- High PE --------
    
    % Get the indices where PE = high, 3AFC, button_pressed  = 0, Target
    % first
    nHits_HighPE = length(returnIndicesIntersect(...
                            dataStructure.PE,'high',...
                            dataStructure.trialType,'3AFC',...
                            dataStructure.button_pressed, 0,...
                            dataStructure.faceType1, 'target'));
                       
    % Get the indices where PE = high, 3AFC, button_pressed  = 0,
    % Non-target first
    nFAs_HighPE = length(returnIndicesIntersect(...
                            dataStructure.PE, 'high',...
                            dataStructure.trialType, '3AFC',...
                            dataStructure.button_pressed, 0,...
                            dataStructure.faceType1, 'non-target'));
    
    % Total number of <Target, Non-target> trials
    nTN_HighPE = length(returnIndicesIntersect(...
                            dataStructure.PE, 'high',...
                            dataStructure.trialType, '3AFC',...
                            dataStructure.faceType1, 'target'));
                        
    % Total number of <Non-target, Target> trials
    nNT_HighPE = length(returnIndicesIntersect(...
                            dataStructure.PE, 'high',...
                            dataStructure.trialType, '3AFC',...
                            dataStructure.faceType1, 'non-target'));
    
    % Hit Rate for High PE
    hitRate_HighPE = nHits_HighPE/nTN_HighPE;
    FARate_HighPE = nFAs_HighPE/nNT_HighPE;
    
    % Correct the rates if necessary
    hitRate_HighPE = rateCorrection(hitRate_HighPE, nTN_HighPE);
    FARate_HighPE = rateCorrection(FARate_HighPE, nNT_HighPE);
    
    % Calculate z-score of high PE Hits and FAs
    hits_HighPE_zScore = norminv(hitRate_HighPE);
    FAs_HighPE_zScore = norminv(FARate_HighPE);
    
    % Calculate d'
    dPrime_HighPE = hits_HighPE_zScore - FAs_HighPE_zScore;
    
    % -------- Low PE --------
    
    % Get the indices where PE = low, 3AFC, button_pressed  = 0, Target
    % first
    nHits_LowPE = length(returnIndicesIntersect(...
                            dataStructure.PE,'low',...
                            dataStructure.trialType,'3AFC',...
                            dataStructure.button_pressed, 0,...
                            dataStructure.faceType1, 'target'));
                       
    % Get the indices where PE = low, 3AFC, button_pressed  = 0,
    % Non-target first
    nFAs_LowPE = length(returnIndicesIntersect(...
                            dataStructure.PE, 'low',...
                            dataStructure.trialType, '3AFC',...
                            dataStructure.button_pressed, 0,...
                            dataStructure.faceType1, 'non-target'));
    
    % Total number of <Target, Non-target> trials
    nTN_LowPE = length(returnIndicesIntersect(...
                            dataStructure.PE, 'low',...
                            dataStructure.trialType, '3AFC',...
                            dataStructure.faceType1, 'target'));
                        
    % Total number of <Non-target, Target> trials
    nNT_LowPE = length(returnIndicesIntersect(...
                            dataStructure.PE, 'low',...
                            dataStructure.trialType, '3AFC',...
                            dataStructure.faceType1, 'non-target'));
    
    % Hit Rate for Low PE
    hitRate_LowPE = nHits_LowPE/nTN_LowPE;
    FARate_LowPE = nFAs_LowPE/nNT_LowPE;
    
    % Correct the rates if necessary
    hitRate_LowPE = rateCorrection(hitRate_LowPE, nTN_LowPE);
    FARate_LowPE = rateCorrection(FARate_LowPE, nNT_LowPE);
    
    % Calculate z-score of high PE Hits and FAs
    hits_LowPE_zScore = norminv(hitRate_LowPE);
    FAs_LowPE_zScore = norminv(FARate_LowPE);
    
    % Calculate d'
    dPrime_LowPE = hits_LowPE_zScore - FAs_LowPE_zScore;
    
    % ------ Return -----
    
    output = [dPrime_HighPE, dPrime_LowPE];
    
end