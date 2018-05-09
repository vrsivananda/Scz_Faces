function scatterPlotConfidenceVsDPrime(dPrimes_All,AFC2_Confidence_All)

    % --- Load in variables for easy handling ---
    
    % d'
    highPE_dPrimes = dPrimes_All(:,1);
    lowPE_dPrimes = dPrimes_All(:,2);
    
    % confidence
    highPE_Confidence = AFC2_Confidence_All(:,1);
    lowPE_Confidence = AFC2_Confidence_All(:,2);
    
    % --- Make the scatter plot ---
    
    % Make a new plot
    figure;
    % High PE
    scatter(highPE_dPrimes, highPE_Confidence, 'filled');
    
    % Plot on the same plot
    hold on;
    % Low PE
    scatter(lowPE_dPrimes, lowPE_Confidence, 'filled');
    
    % --- Legend for scatter plot ---
    
    legend('High PE', 'Low PE');
    
    % --- Connect the dots ---
    
    % For loop that goes through everyone
    for i = 1:size(dPrimes_All,1)
        
        hold on;
        plot([highPE_dPrimes(i), lowPE_dPrimes(i)], [highPE_Confidence(i), lowPE_Confidence(i)]);
        
    end
    
    % --- Formatting ---
    xlabel('dPrime');
    ylabel('Confidence');
    
    xlim([-0.5 2.5]);
    ylim([0 100]);

end