function plot3DScatter(plot3D_All, subjectColors ,subjectOrPatient)
    
    % Save the figure
    saveFigure = 1;
    
    % Get the number of subjects
    nSubjects = length(fieldnames(plot3D_All));
    
    % One figure for all subjects
    figure;
    
    % For loop that goes through each subject
    for i = 1:nSubjects
        
        % Get the current subject
        currentSubject = plot3D_All.(['subject' num2str(i)]);
        
        % Get the color for the subject
        currentColor = subjectColors(i,:);
        
        % Print the scatter of the current subject
        scatter3(currentSubject.X,currentSubject.Y,currentSubject.Z,'MarkerEdgeColor',currentColor,'MarkerFaceColor',currentColor);
        hold on;
    
    end % End of for loop
    
    hold off;
    
    % Axis labels
    xlabel('zTarget-zNonTarget');
    ylabel('zDistractor');
    zlabel('% target chosen');
    
    % Axis limits
    xlim([0 4]);
    ylim([-3 3]);
    zlim([0 1]);
    
    % ------ Saving ------

    % Only save the figure if we want to
    if(saveFigure)

        % Create the file name and path to save
        savingFileName = ['overall_Scatter3DPlot_' subjectOrPatient 's_(n=' num2str(nSubjects) ').jpg'];
        savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);

    end
    
end %End of function