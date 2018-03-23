function analyzAndPlotDPrimes(dPrimes_All)

    % Parameters
    barColor = [0.7, 0.7, 0.7];
    minX = 0;
    maxX = 3;
    
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
    ylim([0 2]);
    ylabel('d''');
    
    % Do the t-test:
    disp('Paired-samples t-test for d'':')
    [h,p,ci,stats] = ttest(highPE_dPrimes,lowPE_dPrimes)


end