function currentSubjectZScoreDistribution = extractZScoreDistribution(dataStructure)
    
    % This script goes through the data and picks out the z-score of each
    % face for this participant
    
    % Get the 3AFC trials
    AFC3_Indices = returnIndicesIntersect(dataStructure.trialType, '3AFC');
    
    % Get the genders for the 3AFC trials
    gender_3AFC = dataStructure.gender(AFC3_Indices);
    nTrialsPerGender = length(gender_3AFC)/2;
    
    % Get the face numbers of each of the faces
    face1_num = dataStructure.faceNumber1(AFC3_Indices);
    face2_num = dataStructure.faceNumber2(AFC3_Indices);
    face3_num = dataStructure.faceNumber3(AFC3_Indices);
    
    % Get the zscores of each of the faces
    face1_ZScore = dataStructure.zScore1(AFC3_Indices);
    face2_ZScore = dataStructure.zScore2(AFC3_Indices);
    face3_ZScore = dataStructure.zScore3(AFC3_Indices);
    
    % Sort the gender and sort everything else after it
    [sorted_gender, sortingIndex] = sort(gender_3AFC);
    face1_num = face1_num(sortingIndex);
    face2_num = face2_num(sortingIndex);
    face3_num = face3_num(sortingIndex);
    face1_ZScore = face1_ZScore(sortingIndex);
    face2_ZScore = face2_ZScore(sortingIndex);
    face3_ZScore = face3_ZScore(sortingIndex);
    
    % Split the arrays into their respective genders
    % - Female -
    face1_F_num = face1_num(1:nTrialsPerGender);
    face2_F_num = face2_num(1:nTrialsPerGender);
    face3_F_num = face3_num(1:nTrialsPerGender);
    face1_F_ZScore = face1_ZScore(1:nTrialsPerGender);
    face2_F_ZScore = face1_ZScore(1:nTrialsPerGender);
    face3_F_ZScore = face1_ZScore(1:nTrialsPerGender);
    % - Male -
    face1_M_num = face1_num(nTrialsPerGender+1:end);
    face2_M_num = face2_num(nTrialsPerGender+1:end);
    face3_M_num = face3_num(nTrialsPerGender+1:end);
    face1_M_ZScore = face1_ZScore(nTrialsPerGender+1:end);
    face2_M_ZScore = face1_ZScore(nTrialsPerGender+1:end);
    face3_M_ZScore = face1_ZScore(nTrialsPerGender+1:end);
    
    % Get the unique z-scores of each gender
    M_zScores = unique([face1_M_ZScore; face2_M_ZScore; face3_M_ZScore]);
    F_zScores = unique([face1_F_ZScore; face2_F_ZScore; face3_F_ZScore]);
    
    % Return it in a data structure
    currentSubjectZScoreDistribution.M_zScores = M_zScores;
    currentSubjectZScoreDistribution.F_zScores = F_zScores;
    
end % End of function