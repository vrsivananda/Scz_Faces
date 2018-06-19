function analyzeAndPlotDPrimes(dPrimes_All ,subjectOrPatient)
    
    % Saving the figure
    saveFigure = 1; 

    % Parameters
    barColor = [0.7, 0.7, 0.7];
    minX = 0;
    maxX = 3;
    minY = 0;
    maxY = 2.5;
    
    % Load in variables for easy handling
    highPE_dPrimes = dPrimes_All(:,1);
    lowPE_dPrimes = dPrimes_All(:,2);

    % Calculate the mean
    highPE_dPrime_mean = mean(highPE_dPrimes);
    lowPE_dPrime_mean = mean(lowPE_dPrimes);
    
    % Get the sample size
    highPE_sampleSize = length(highPE_dPrimes);
    lowPE_sampleSize = length(lowPE_dPrimes);
    
    % Calculate the sem
    highPE_dPrime_SEM = std(highPE_dPrimes)/sqrt(highPE_sampleSize);
    lowPE_dPrime_SEM = std(lowPE_dPrimes)/sqrt(lowPE_sampleSize);
    
    % Load in the plotting variables for easy handling
    y = [lowPE_dPrime_mean, highPE_dPrime_mean];
    
     % Plot the bar graph
    figure;
    bar(y,'FaceColor',barColor);
    hold on;
    errorbar([1,2],y,[lowPE_dPrime_SEM, highPE_dPrime_SEM],'.');
    
    % Format the graph
    set(gca, 'XTickLabel', {'LowPE' 'HighPE'});
    xlim([minX maxX]);
    ylim([minY maxY]);
    ylabel('d''');
    
    % ------ Saving ------
    
    % Only save the figure if we want to
    if(saveFigure)
    
        % Create the file name and path to save
        savingFileName = ['overall_dPrime_' subjectOrPatient 's_(n=' num2str(highPE_sampleSize) ').jpg'];
        savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);
    
    end
    
    % ------ T-Test ------
    
    % Do the t-test:
    disp('Paired-samples t-test for d'':')
    [h,p,ci,stats] = ttest(highPE_dPrimes,lowPE_dPrimes)


end