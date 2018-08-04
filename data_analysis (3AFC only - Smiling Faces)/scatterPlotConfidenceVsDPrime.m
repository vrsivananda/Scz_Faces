function scatterPlotConfidenceVsDPrime(dPrimes_All,AFC3_Confidence_All, subjectOrPatient, saveFigure)
    % --- Load in variables for easy handling ---
    
    % d'
    highPE_dPrimes = dPrimes_All(:,1);
    lowPE_dPrimes = dPrimes_All(:,2);
    
    % confidence
    highPE_Confidence = AFC3_Confidence_All(:,1);
    lowPE_Confidence = AFC3_Confidence_All(:,2);
    
    % --- Make the scatter plot ---
    
    % Make a new plot
    figure;
        
    % Number of subjects
    nSubjects = size(highPE_dPrimes,1);
    
    % For loop that loops through all the subjects
    for i = 1:nSubjects
        
         % ---- Make Plot ----
        
        % Connect the dots
        hold on;
        plot([highPE_dPrimes(i), lowPE_dPrimes(i)], [highPE_Confidence(i), lowPE_Confidence(i)], 'LineWidth', 2, 'Color', [0.5, 0.5, 0.5]);
        
        % High PE
        scatter(highPE_dPrimes(i), highPE_Confidence(i), 50, 'green', 'filled');
        hold on;
        
        % Low PE
        scatter(lowPE_dPrimes(i), lowPE_Confidence(i), 50, 'red', 'filled');
        hold on;
        
    end % End of for loop
    
    % --- Legend for scatter plot ---
    
    legend('Same Subject', 'High PE', 'Low PE');
    

    % --- Formatting ---
    xlabel('dPrime');
    ylabel('Confidence');
    
    xlim([-0.5 3.5]);
    ylim([0 100]);
    
    % ------ Saving ------
    
    % Only save the figure if we want to
    if(saveFigure)
    
        % Create the file name and path to save
        savingFileName = ['overall_ScatterPlot_ConfidenceVsDPrime_' subjectOrPatient 's_(n=' num2str(length(highPE_dPrimes)) ').jpg'];
        savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);
    
    end

end