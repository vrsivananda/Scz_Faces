function [difference_M, difference_F] = extractFaceRatings(dataStructure)
    
    % Odd and even indices
    odd_indices = 1:2:30;
    even_indices = 2:2:30;
    
    % ======= Male =======
    
    % Get the indices of phase1
    phase1_M_indices = returnIndicesIntersect(...
                        dataStructure.trial_type, 'image-slider-response', ...
                        dataStructure.gender, 'M');
    
    % Get the responses
    responses_M = dataStructure.response(phase1_M_indices);
    
    % Get the face numbers
    faceNumbers_M = dataStructure.faceNumber(phase1_M_indices);
    
    % Sort the face numbers and the responses
    [faceNumbers_M_sorted, sortingIndex_M] = sort(faceNumbers_M);
    responses_M_sorted = responses_M(sortingIndex_M);
    
    difference_M = abs(responses_M_sorted(odd_indices)-responses_M_sorted(even_indices))';
    
    % ======= Female =======
    
    % Get the indices of phase1
    phase1_F_indices = returnIndicesIntersect(...
                        dataStructure.trial_type, 'image-slider-response', ...
                        dataStructure.gender, 'F');
    
    % Get the responses
    responses_F = dataStructure.response(phase1_F_indices);
    
    % Get the face numbers
    faceNumbers_F = dataStructure.faceNumber(phase1_F_indices);
    
    % Sort the face numbers and the responses
    [faceNumbers_F_sorted, sortingIndex_F] = sort(faceNumbers_F);
    responses_F_sorted = responses_F(sortingIndex_F);
    
    difference_F = abs(responses_F_sorted(odd_indices)-responses_F_sorted(even_indices))';
    
end % End of function