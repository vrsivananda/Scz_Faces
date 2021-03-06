function plotPhase1Phase2Performance(phase1Phase2Performance_All, minPercentCorrect, subjectOrPatient, saveFigure)
    
    % Extract the data
    phase1_Mean = phase1Phase2Performance_All(:,1);
    phase1_SD = phase1Phase2Performance_All(:,2);
    phase2_pCorrect_LowPE = phase1Phase2Performance_All(:,3);
    phase2_pCorrect_HighPE = phase1Phase2Performance_All(:,4);
    
    % Parameters
    minX = min(phase1_Mean) - 1;
    maxX = max(phase1_Mean) + 1;
    
    
    % Number of subjects
    nSubjects = size(phase1Phase2Performance_All,1);
    
    figure;
    
    % Draw a horizontal line to signify the cutoff
    plot([minX, maxX], [minPercentCorrect, minPercentCorrect], 'LineWidth', 2);
    hold on;
    
    % Draw a horizontal line to signify the chance
    plot([minX, maxX], [0.33, 0.33], 'LineWidth', 1, 'LineStyle', '--', 'Color', 'r');
    hold on;
    
    % For loop that loops through all the subjects
    for i = 1:nSubjects
        
         % ---- Make Plot ----
        
        % Connect the dots
        hold on;
        plot([phase1_Mean(i), phase1_Mean(i)], [phase2_pCorrect_HighPE(i), phase2_pCorrect_LowPE(i)], 'LineWidth', 2, 'Color', [0.5, 0.5, 0.5]);
        
        % High PE
        scatter(phase1_Mean(i), phase2_pCorrect_HighPE(i), 50, 'green', 'filled');
        hold on;
        
        % Low PE
        scatter(phase1_Mean(i), phase2_pCorrect_LowPE(i), 50, 'red', 'filled');
        hold on;
        
    end % End of for loop
    
    % Other features
    xlim([minX, maxX]);
    ylim([0, 1]);
    xlabel('mean difference between face ratings');
    ylabel('percent correct in phase 2');    
    lgd = legend('Threshold','Chance','Same subject', 'High PE', 'Low PE');
    lgd.Location = 'southeast';


    % ------ Saving ------

    % Only save the figure if we want to
    if(saveFigure)

        % Create the file name and path to save
        savingFileName = ['overall_phase1Phase2Performance' subjectOrPatient 's_.jpg'];
        savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);

    end
    
end