function plotZScoreDistribution(zScore_Distribution_M, zScore_Distribution_F, subjectOrPatient, saveFigure)    
    
    
    % ----------- Individual Plots -----------
    
    % New Figure
    figure;
    
    % Get the number of subjects
    nSubjects = length(fieldnames(zScore_Distribution_M));
    
    % For loop to go through each subject's data
    for i = 1:nSubjects
        
        % ---- Extract Data ----
        
        % Get the current subject's data structure
        current_M_zScores = zScore_Distribution_M.(['subject' num2str(i)]);
        current_F_zScores = zScore_Distribution_F.(['subject' num2str(i)]);
        
        % ---- Make Plot ----
        
        % Calculate the Y for the current subject
        current_Y = i;
        
        % Horizontal line
        plot([-3, 3], [current_Y, current_Y], '-', 'Color', [0.5, 0.5, 0.5]);
        hold on;
        
        % -Male-
        
        % Make the y-array
        current_Y_Array = repmat(current_Y, length(current_M_zScores), 1);
        
        % Plot the circles
        plot(current_M_zScores, current_Y_Array, 'ob', 'MarkerFaceColor', 'b');
        hold on;
        
        % -Female-
        
        % Make the y-array
        current_Y_Array = repmat(current_Y, length(current_F_zScores), 1);
        
        % Plot the circles
        plot(current_F_zScores, current_Y_Array, 'or', 'MarkerFaceColor', 'r');
        hold on;
        
    end % End of for loop
    
    % Plot the vertical line at 0
    plot([0, 0], [0, i+1], '-m');
    ylim([0, i+1]);
    yticks(0:i+1);
    
    xlabel('z-score');
    ylabel('subject');


    % ------ Saving ------

    % Only save the figure if we want to
    if(saveFigure)

        % Create the file name and path to save
        savingFileName = ['overall_zScoreDistribution_' subjectOrPatient 's_.jpg'];
        savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);

    end
    
end % End of function