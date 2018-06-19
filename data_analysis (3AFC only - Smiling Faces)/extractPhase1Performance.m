function currentPhase1Performance = extractPhase1Performance(dataStructure)
    
    % Extract the data and store them in an array
    faceNumbers = dataStructure.faceNumber(6:65);
    genders = dataStructure.gender(6:65);
    responses = dataStructure.response(6:65);
    
    % Sort the responses so that we can match the faces
    
    % Sort by faceNumber first
    [faceNumbers sortingIndex] = sort(faceNumbers);
    genders = genders(sortingIndex);
    responses = responses(sortingIndex);
    
    % Then sort by gender
    [genders sortingIndex] = sort(genders);
    faceNumbers = faceNumbers(sortingIndex);
    responses = responses(sortingIndex);
    
    % Index out the first and rating of each face
    firstRating = responses(1:2:60);
    secondRating = responses(2:2:60);
    
    % Take the difference between the ratings
    difference = abs(firstRating-secondRating);
    
    % Take the mean and sd of the differences
    differenceMean = mean(difference);
    differenceSD = std(difference);
    
    % Return the results
    currentPhase1Performance = [differenceMean, differenceSD];
    
end