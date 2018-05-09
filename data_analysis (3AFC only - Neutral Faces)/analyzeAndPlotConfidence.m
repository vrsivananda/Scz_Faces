function analyzeAndPlotConfidence(AFC2_Confidence_All)

    % Parameters
    barColor = [0.7, 0.7, 0.7];
    minX = 0;
    maxX = 3;
    
    % Load in variables for easy handling
    highPE_Confidence = AFC2_Confidence_All(:,1);
    lowPE_Confidence = AFC2_Confidence_All(:,2);

    % Calculate the mean
    highPE_Confidence_mean = mean(highPE_Confidence);
    lowPE_Confidence_mean = mean(lowPE_Confidence);
    
    % Get the sample size
    highPE_sampleSize = length(highPE_Confidence_mean);
    lowPE_sampleSize = length(lowPE_Confidence_mean);
    
    % Calculate the sem
    highPE_Confidence_SEM = std(highPE_Confidence)/sqrt(highPE_sampleSize);
    lowPE_Confidence_SEM = std(lowPE_Confidence)/sqrt(lowPE_sampleSize);
    
    % Load in the plotting variables for easy handling
    y = [lowPE_Confidence_mean, highPE_Confidence_mean];
    
    % Plot the bar graph
    figure;
    bar(y,'FaceColor',barColor);
    hold on;
    errorbar([1,2],y,[lowPE_Confidence_SEM, highPE_Confidence_SEM],'.');
    
    % Format the graph
    set(gca, 'XTickLabel', {'LowPE' 'HighPE'});
    xlim([minX maxX]);
    ylim([0 100]);
    ylabel('Confidence Response');
    
    % Do the t-test:
    disp('Paired-samples t-test for confidence:')
    [h,p,ci,stats] = ttest(highPE_Confidence,lowPE_Confidence)
    
end % End of function