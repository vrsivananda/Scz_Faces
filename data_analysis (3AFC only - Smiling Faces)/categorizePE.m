function [dataStructure, nLowPE, nHighPE] = categorizePE(dataStructure, lowPECutoff, highPECutoff)
    
    % Counter for number of trials where all 3 faces 0 < z < 0.5
    hh = 0;
    hl = 0;
    l = 0;
    
    % Get the relevant arrays
    PEs = dataStructure.PE;
    targetZScores = dataStructure.targetZScore;
    nonTargetZScores = dataStructure.nonTargetZScore;
    distractorZScores = dataStructure.distractorZScore;
    
    % Get the 3AFC trials
    AFC3_trials = returnIndices(dataStructure.trialType, '3AFC');
    
    % For loop that goes through each trial
    for j = 1:length(AFC3_trials)
        
        % Index (trial number) for the loop
        i = AFC3_trials(j);
        
        % Load in the z-scores
        targetZScore = dataStructure.targetZScore(i);
        nonTargetZScore = dataStructure.nonTargetZScore(i);
        distractorZScore = dataStructure.distractorZScore(i);
        
        % Current configuration:
        % +-----+-------+-----+-----+-----+
        % | PE  |  Norm |  T  |  NT |  D  |
        % +-----+-------+-----+-----+-----+
        % |     |   H   |>0.5 | >0  | >0  |
        % |  H  +-------+-----+-----+-----+
        % |     |   L   |>0.5 | >0  | <0  |
        % +-----+-------+-----+-----+-----+
        % |     |   H   |<0.5 |<0.5 |<0.5 |
        % |  L  +-------+-----+-----+-----+
        % |     |   L   |<0.5 |<0.5 |<0.5 |
        % +-----+-------+-----+-----+-----+
        
        
        % Degubbing
        close all;
        if(    targetZScore <= lowPECutoff &&     targetZScore >= highPECutoff && ...
            nonTargetZScore <= lowPECutoff &&  nonTargetZScore >= highPECutoff && ...
           distractorZScore <= lowPECutoff && distractorZScore >= highPECutoff)
            disp(i);
        end
        
        if(targetZScore <= nonTargetZScore || targetZScore <= distractorZScore)
            disp(i);
        end

        
        % Set the PE based on the z-score
        % If all  faces are above the highPE cutoff, then they are highPE
        % (Trials with all 3 faces between the low and highPE cutoffs are considered highPE)
        % HighPE High Norm
          if(targetZScore >= lowPECutoff && nonTargetZScore >= highPECutoff && distractorZScore >= highPECutoff)
            dataStructure.PE{i} = 'high';
            dataStructure.PE{i+1} = 'high';
            hh = hh + 1;
          
          % HighPE Low Norm
          elseif(targetZScore >= lowPECutoff && nonTargetZScore >= highPECutoff && distractorZScore <= highPECutoff)
            dataStructure.PE{i} = 'high';
            dataStructure.PE{i+1} = 'high';
            hl = hl + 1;
          
          % Low PE both High and Low Norm
          elseif(targetZScore <= lowPECutoff && nonTargetZScore <= lowPECutoff && distractorZScore <= lowPECutoff)
            dataStructure.PE{i} = 'low';
            dataStructure.PE{i+1} = 'low';
            l = l + 1;
          
          % Else we have a problem
          else
            msgbox('Problem with determining PE.');
          end
        
    end % End of for loop
    
    
    nHighPE = length(returnIndices(dataStructure.PE, 'high'));
    nLowPE = length(returnIndices(dataStructure.PE, 'low'));
    
     disp(hh);
     disp(hl);
     disp(l);
    
end % End of function