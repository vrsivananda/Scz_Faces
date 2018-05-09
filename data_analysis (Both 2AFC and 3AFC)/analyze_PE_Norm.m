function analyze_PE_Norm(chosenFaces_PE_Norm_All)
    
    % chosenFaces_PE_Norm_All in the form:
    % [targetCounter_highPE_highNorm, nontargetCounter_highPE_highNorm, distractorCounter_highPE_highNorm, mean(confidence_highPE_highNorm_Array); ...
    %  targetCounter_highPE_lowNorm , nontargetCounter_highPE_lowNorm , distractorCounter_highPE_lowNorm , mean(confidence_highPE_lowNorm_Array) ; ...
    %  targetCounter_lowPE_highNorm , nontargetCounter_lowPE_highNorm , distractorCounter_lowPE_highNorm , mean(confidence_lowPE_highNorm_Array) ; ...
    %  targetCounter_lowPE_lowNorm  , nontargetCounter_lowPE_lowNorm  , distractorCounter_lowPE_lowNorm  , mean(confidence_lowPE_lowNorm_Array)   ]
    % ^ Subjects in the 3rd dimension
    
    % Parameters
    barColor = [0.7, 0.7, 0.7];
    minX = 0;
    maxX = 5;
    
    % =================== % time chose Target ===================
    
    % Total Target and Non-targets
    total_T_NT = chosenFaces_PE_Norm_All(:,1,:) + chosenFaces_PE_Norm_All(:,2,:);
    
    % Total percentage chose Target
    percentChosenTarget = chosenFaces_PE_Norm_All(:,1,:)./total_T_NT;
    
    % ---- highPE: lowNorm vs highNorm ----
    
    % Extract the arrays
    highPE_highNorm_percentChosenTarget = percentChosenTarget(1,1,:).*100;
    highPE_lowNorm_percentChosenTarget = percentChosenTarget(2,1,:).*100;
    
    % t-test for HPE: lowNorm vs highNorm
    [H,P,CI,STATS] = ttest(highPE_highNorm_percentChosenTarget, highPE_lowNorm_percentChosenTarget)
    
    
    % ---- lowPE: lowNorm vs highNorm ----
    
    % Extract the arrays
    lowPE_highNorm_percentChosenTarget = percentChosenTarget(3,1,:).*100;
    lowPE_lowNorm_percentChosenTarget = percentChosenTarget(4,1,:).*100;
    
    % t-test for HPE: lowNorm vs highNorm
    [H,P,CI,STATS] = ttest(lowPE_highNorm_percentChosenTarget, lowPE_lowNorm_percentChosenTarget)
    
    % -------- Plot the graph --------
    
    % Calculate the means
    highPE_highNorm_percentChosenTarget_mean = mean(highPE_highNorm_percentChosenTarget);
    highPE_lowNorm_percentChosenTarget_mean = mean(highPE_lowNorm_percentChosenTarget);
    lowPE_highNorm_percentChosenTarget_mean = mean(lowPE_highNorm_percentChosenTarget);
    lowPE_lowNorm_percentChosenTarget_mean = mean(lowPE_lowNorm_percentChosenTarget);
    
    % Calculate the standard error
    highPE_highNorm_percentChosenTarget_sem = std(highPE_highNorm_percentChosenTarget)/sqrt(length(highPE_highNorm_percentChosenTarget));
    highPE_lowNorm_percentChosenTarget_sem = std(highPE_lowNorm_percentChosenTarget)/sqrt(length(highPE_lowNorm_percentChosenTarget));
    lowPE_highNorm_percentChosenTarget_sem = std(lowPE_highNorm_percentChosenTarget)/sqrt(length(lowPE_highNorm_percentChosenTarget));
    lowPE_lowNorm_percentChosenTarget_sem = std(lowPE_lowNorm_percentChosenTarget)/sqrt(length(lowPE_lowNorm_percentChosenTarget));
    
    % Load in the plotting variables for easy handling
    y = [highPE_highNorm_percentChosenTarget_mean, highPE_lowNorm_percentChosenTarget_mean, lowPE_highNorm_percentChosenTarget_mean, lowPE_lowNorm_percentChosenTarget_mean];
    sem = [highPE_highNorm_percentChosenTarget_sem, highPE_lowNorm_percentChosenTarget_sem, lowPE_highNorm_percentChosenTarget_sem, lowPE_lowNorm_percentChosenTarget_sem];
    
    % Plot the bar graph
    figure;
    bar(y,'FaceColor',barColor);
    hold on;
    errorbar([1,2,3,4],y,sem,'.');
    
    % Format the graph
    set(gca, 'XTickLabel', {'highPE\newlinehighNorm', 'highPE\newlinelowNorm', 'lowPE\newlinehighNorm', 'lowPE\newlinelowNorm'});
    xlim([minX maxX]);
    ylim([0 100]);
    ylabel('% Chose Target');
    
    
     % =================== % confidence ===================
    
    % ---- highPE: lowNorm vs highNorm ----
    
    % Extract the arrays
    highPE_highNorm_confidence = chosenFaces_PE_Norm_All(1,4,:);
    highPE_lowNorm_confidence = chosenFaces_PE_Norm_All(2,4,:);
    
    % t-test for HPE: lowNorm vs highNorm
    disp('t-test for highPE_highNorm_confidence vs highPE_lowNorm_confidence:');
    [H,P,CI,STATS] = ttest(highPE_highNorm_confidence, highPE_lowNorm_confidence)
    
    
    % ---- lowPE: lowNorm vs highNorm ----
    
    % Extract the arrays
    lowPE_highNorm_confidence = chosenFaces_PE_Norm_All(3,4,:);
    lowPE_lowNorm_confidence = chosenFaces_PE_Norm_All(4,4,:);
    
    % t-test for HPE: lowNorm vs highNorm
    disp('t-test for lowPE_highNorm_confidence vs lowPE_confidence:');
    [H,P,CI,STATS] = ttest(lowPE_highNorm_confidence, lowPE_lowNorm_confidence)
    
    % -------- Plot the graph --------
    
    % Calculate the means
    highPE_highNorm_confidence_mean = mean(highPE_highNorm_confidence);
    highPE_lowNorm_confidence_mean = mean(highPE_lowNorm_confidence);
    lowPE_highNorm_confidence_mean = mean(lowPE_highNorm_confidence);
    lowPE_lowNorm_confidence_mean = mean(lowPE_lowNorm_confidence);
    
    % Calculate the standard error
    highPE_highNorm_confidence_sem = std(highPE_highNorm_confidence)/sqrt(length(highPE_highNorm_confidence));
    highPE_lowNorm_confidence_sem = std(highPE_lowNorm_confidence)/sqrt(length(highPE_lowNorm_confidence));
    lowPE_highNorm_confidence_sem = std(lowPE_highNorm_confidence)/sqrt(length(lowPE_highNorm_confidence));
    lowPE_lowNorm_confidence_sem = std(lowPE_lowNorm_confidence)/sqrt(length(lowPE_lowNorm_confidence));
    
    % Load in the plotting variables for easy handling
    y = [highPE_highNorm_confidence_mean, highPE_lowNorm_confidence_mean, lowPE_highNorm_confidence_mean, lowPE_lowNorm_confidence_mean];
    sem = [highPE_highNorm_confidence_sem, highPE_lowNorm_confidence_sem, lowPE_highNorm_confidence_sem, lowPE_lowNorm_confidence_sem];
    
    % Plot the bar graph
    figure;
    bar(y,'FaceColor',barColor);
    hold on;
    errorbar([1,2,3,4],y,sem,'.');
    
    % Format the graph
    set(gca, 'XTickLabel', {'highPE\newlinehighNorm', 'highPE\newlinelowNorm', 'lowPE\newlinehighNorm', 'lowPE\newlinelowNorm'});
    xlim([minX maxX]);
    ylim([0 100]);
    ylabel('Confidence');
    
    
end % End of function