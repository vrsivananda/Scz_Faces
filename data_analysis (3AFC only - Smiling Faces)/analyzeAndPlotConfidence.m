function analyzeAndPlotConfidence(AFC2_Confidence_All, subjectOrPatient, saveFigure)

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
    highPE_sampleSize = length(highPE_Confidence);
    lowPE_sampleSize = length(lowPE_Confidence);
    
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
    
    % ------ Saving ------
    
    % Only save the figure if we want to
    if(saveFigure)
    
        % Create the file name and path to save
        savingFileName = ['overall_confidence_' subjectOrPatient 's_(n=' num2str(highPE_sampleSize) ').jpg'];
        savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);
    
    end
    
    % ------ T-Test ------
    
    % Do the t-test:
    disp('Paired-samples t-test for confidence:')
    [h,p,ci,stats] = ttest(highPE_Confidence,lowPE_Confidence)
    
end % End of function