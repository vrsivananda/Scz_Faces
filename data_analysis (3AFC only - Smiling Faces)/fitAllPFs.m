function [paramsValues, binCounter, exitFlags, pDevs, converged] = fitAllPFs(dataStructure, bins, subjectNumber ,subjectOrPatient)
    
    % ============ PARAMETERS BEGIN ============
    
    % Saving the figure
    saveFigure = 0; % For both plots
    
    % Choose the a psychometric function 
    PF = @PAL_CumulativeNormal;
    
    % General
    marker = '.';
    markerSize = 20;
    lineStyle = '-';
    lineWidth = 2;
    fontSize = 12;
    
    % Axis Limits;
    xMin = -3.5;
    xMax = 3.5;
    yMin = 0;
    yMax = 1;

    % Colors
    AFC3_Color = [  0,   0, 255]./255; % Blue
    highPE_3AFC_Color = [  0,   0, 255]./255; % Dark  Blue
    lowPE_3AFC_Color  = [  0, 191, 255]./255; % Light Blue
    
    % ============ PARAMETERS END ============
    
%     % Create the x-axis for the bins
%     for i = 1:length(bins)-1
%         binCenter(i) = mean([bins(i), bins(i+1)]);
%     end % End of for loop
    

    % ============================  FUNCTION FITTING  ============================

    % Fit the psychometric function to the data
    
    % -- AFC Only --
    [AFC3_paramsValues, AFC3_percentChosenTarget, AFC3_binCounter, AFC3_binCenter, AFC3_exitFlag, AFC3_pDev, AFC3_converged] = ...
        fitPsychometricFunction_AFC_PE(dataStructure, bins, PF, '3AFC');
    
    % -- PE and AFC --
	[highPE_3AFC_paramsValues, highPE_3AFC_percentChosenTarget, highPE_3AFC_binCounter, highPE_3AFC_binCenter, highPE_3AFC_exitFlag, highPE_3AFC_pDev, highPE_3AFC_converged] = ...
        fitPsychometricFunction_AFC_PE(dataStructure, bins, PF, '3AFC', 'high');
	[ lowPE_3AFC_paramsValues,  lowPE_3AFC_percentChosenTarget,  lowPE_3AFC_binCounter,  lowPE_3AFC_binCenter,  lowPE_3AFC_exitFlag,  lowPE_3AFC_pDev,  lowPE_3AFC_converged] = ...
        fitPsychometricFunction_AFC_PE(dataStructure, bins, PF, '3AFC', 'low');
    
    % Store the paramsValues
    paramsValues = [      AFC3_paramsValues; ...
                   highPE_3AFC_paramsValues; ...
                    lowPE_3AFC_paramsValues];
    
    % Store the binCounters
    binCounter = [       AFC3_binCounter; ...
                  highPE_3AFC_binCounter; ...
                   lowPE_3AFC_binCounter];
               
    % Store the exitFlags
    exitFlags = [        AFC3_exitFlag; ...
                  highPE_3AFC_exitFlag; ...
                   lowPE_3AFC_exitFlag];           
               
    % Store the pDevs
    pDevs =  [       AFC3_pDev; ...
              highPE_3AFC_pDev; ...
               lowPE_3AFC_pDev];
           
    % Store the converged-s
    converged = [       AFC3_converged, ...
                 highPE_3AFC_converged, ...
                  lowPE_3AFC_converged];
    
    
    % ============================  CURVE PLOTTING  ============================
    
    % Get the fine-grained x-axis values
    stimLevelsFine = xMin:(xMax-xMin)/1000:xMax;
    
    % ******************** AFC Plot ********************
    
    % Get the fit for the different conditions
    AFC3_fit =  PF(AFC3_paramsValues,stimLevelsFine);
        
    % New figure
    figure;
    
    % -- 3AFC --
    hold on;
    % Plot the points
    plot(AFC3_binCenter, AFC3_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', AFC3_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h2 = plot(stimLevelsFine, AFC3_fit, 'Color', AFC3_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
    % ------ Formatting ------
    
    % Format the axes
    set(gca,'fontsize', fontSize);
    axis([xMin xMax yMin yMax]);
    
    % Add in the legend
    legend([h2], {'3AFC'}, 'Location', 'SouthEast');
    
    
    % ------ Saving ------
    
    % Only save the figure if we want to
    if(saveFigure)
    
        % Create the file name and path to save
        savingFileName = [subjectOrPatient '_' num2str(subjectNumber) '_PF.jpg'];
        savingFilePath = [pwd '/Figures/Individual_' subjectOrPatient 's/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);
    
    end
    
    
    
    % ******************** PE & AFC Plot ********************
    
    % Get the fit for the different conditions
    highPE_3AFC_fit = PF(highPE_3AFC_paramsValues,stimLevelsFine);
    lowPE_3AFC_fit  = PF( lowPE_3AFC_paramsValues,stimLevelsFine);
    
    % New figure
    figure;
    
    % -- highPE_3AFC --
    hold on;
    % Plot the points
    plot(highPE_3AFC_binCenter, highPE_3AFC_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', highPE_3AFC_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h5 = plot(stimLevelsFine, highPE_3AFC_fit, 'Color', highPE_3AFC_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
    % -- lowPE_3AFC --
    hold on;
    % Plot the points
    plot(lowPE_3AFC_binCenter, lowPE_3AFC_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', lowPE_3AFC_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h6 = plot(stimLevelsFine, lowPE_3AFC_fit, 'Color', lowPE_3AFC_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
    % ------ Formatting ------
    
    % Format the axes
    set(gca,'fontsize', fontSize);
    axis([xMin xMax yMin yMax]);
    
    % Add in the legend
    legend([h5 h6],{'highPE - 3AFC',' lowPE - 3AFC'}, 'Location', 'SouthEast');
    
    
    % ------ Saving ------
    
    % Only save the figure if we want to
    if(saveFigure)
    
        % Create the file name and path to save
        savingFileName = [subjectOrPatient '_' num2str(subjectNumber) '_PE_PF.jpg'];
        savingFilePath = [pwd '/Figures/Individual_' subjectOrPatient 's/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);
    
    end
    
    
end % End of fitAllPFs 