function plotChosenDistractor(chosenDistractor_All, subjectOrPatient, saveFigure)    
    
    
    % ----------- Individual Plots -----------
    
    % Parameters
    yLimits = [0, 1];
    
    % New Figure
    figure;
    
    % Get the number of subjects
    nSubjects = size(chosenDistractor_All, 1);
    
    % For loop to go through each subject's data
    for i = 1:nSubjects
        
        % ---- Extract Data ----
        
        % Get the current subject's data structure
        current_percentChosenDistractor_HighPE = chosenDistractor_All(i,2);
        current_percentChosenDistractor_LowPE  = chosenDistractor_All(i,4);
        
        % ---- Make Plot ----
        
        % Calculate the X for the current subject
        current_X = i;
        
        % Vertical line
        %plot([current_X, current_X], yLimits, '-', 'Color', [0.5, 0.5, 0.5]);
        %hold on;
        
        % -Male-
        
        % Make the y-array
        current_Y_Array = [current_percentChosenDistractor_HighPE, current_percentChosenDistractor_LowPE];
        
        % Connect the dots
        hold on;
        plot([current_X, current_X], [current_percentChosenDistractor_HighPE, current_percentChosenDistractor_LowPE]);
        
        % High PE
        scatter(current_X, current_percentChosenDistractor_HighPE, 10, 'green', 'filled');
        hold on;
        % Low PE
        scatter(current_X, current_percentChosenDistractor_LowPE, 10, 'red', 'filled');
        hold on;
        
        % Connect the dots
        hold on;
        plot([current_X, current_X], [current_percentChosenDistractor_HighPE, current_percentChosenDistractor_LowPE]);
        
    end % End of for loop
    
    % Plot the horizontal line at 0.333
    plot([0, i+1], [1/3, 1/3], '-m');
    
    ylabel('% chose distractor');
    xlabel('subjects');
    ylim(yLimits);
    xticks(0:i+1);
    
    % --- Legend for scatter plot ---
    
    legend('same subject', 'High PE', 'Low PE');


    % ------ Saving ------

    % Only save the figure if we want to
    if(saveFigure)

        % Create the file name and path to save
        savingFileName = ['overall_percentChosenDistractor_' subjectOrPatient 's_.jpg'];
        savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);

    end
    
end % End of function