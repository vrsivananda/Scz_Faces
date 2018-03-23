function plotLinRegData(linReg, subjectColors)
    
    % --- Variables for group plots ---
    x_All = [];
    X_All = [];
    y_All = [];
    
    % ----------- Individual Plots -----------
    
    % New Figure
    figure;
    
    % Get the number of subjects
    nSubjects = length(fieldnames(linReg));
    
    % For loop to go through each subject's data
    for i = 1:nSubjects
        
        % ---- Extract Data ----
        
        % Get the current subject's data structure
        currentLinReg = linReg.(['subject' num2str(i)]);
        
        % Load in the variables
        x = currentLinReg.x;
        X = currentLinReg.X;
        y = currentLinReg.y;
        b = currentLinReg.b;
        yReg = currentLinReg.yReg;
        
        % Save the data for the group plot later
        x_All = [x_All; x];
        X_All = [X_All; X];
        y_All = [y_All; y];
        
        % ---- Make Plot ----
        
        % Get the color for the subject
        currentColor = subjectColors(i,:);
        
        % Make the scatter plot
        scatter(x, y, 'markerFaceColor', currentColor, 'markerEdgeColor', currentColor);
        hold on;
        
        % Plot the new y's (the regression line)
        plot(x, yReg, 'LineStyle', '-', 'Color', currentColor);
        hold on;
        
    end % End of for loop
    
    % --- Formatting ---
    
    % Axis limits
    xlim([-2.5, 1]);
    ylim([0, 1]);
    
    % Axis labels
    xlabel('zScore of Distractor Face');
    ylabel('% Chosen Target Face');
    
    % Add the legend
    legend('Binned Data','Regression Line','Location','SouthEast');
    
    % Hold off to stop plotting on the same graph
    hold on;
    
    
    % ----------- Group Plots -----------
    
    % Get the coefficient
    b_All = X_All\y_All;
    
    % Calculate the y's
    yReg_All = X_All * b_All;
    
    % Plot the regression line for all the dots
    plot(x_All, yReg_All, 'LineStyle', '-', 'Color', 'g', 'LineWidth', 2);
    
    
end % End of function