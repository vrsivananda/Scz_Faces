function [paramsValues, binCounter, exitFlags, pDevs, converged] = fitAllPFs(dataStructure, bins, subjectNumber)
    
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
    AFC2_Color = [255,   0,   0]./255; % Red
    AFC3_Color = [  0,   0, 255]./255; % Blue
    highPE_2AFC_Color = [255,   0,   0]./255; % Dark  Red
    lowPE_2AFC_Color  = [255, 182, 193]./255; % Light Red
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
    [AFC2_paramsValues, AFC2_percentChosenTarget, AFC2_binCounter, AFC2_binCenter, AFC2_exitFlag, AFC2_pDev, AFC2_converged] = ...
        fitPsychometricFunction_AFC_PE(dataStructure, bins, PF, '2AFC');
    [AFC3_paramsValues, AFC3_percentChosenTarget, AFC3_binCounter, AFC3_binCenter, AFC3_exitFlag, AFC3_pDev, AFC3_converged] = ...
        fitPsychometricFunction_AFC_PE(dataStructure, bins, PF, '3AFC');
    
    % -- PE and AFC --
	[highPE_2AFC_paramsValues, highPE_2AFC_percentChosenTarget, highPE_2AFC_binCounter, highPE_2AFC_binCenter, highPE_2AFC_exitFlag, highPE_2AFC_pDev, highPE_2AFC_converged] = ...
        fitPsychometricFunction_AFC_PE(dataStructure, bins, PF, '2AFC', 'high');
	[ lowPE_2AFC_paramsValues,  lowPE_2AFC_percentChosenTarget,  lowPE_2AFC_binCounter,  lowPE_2AFC_binCenter,  lowPE_2AFC_exitFlag,  lowPE_2AFC_pDev,  lowPE_2AFC_converged] = ...
        fitPsychometricFunction_AFC_PE(dataStructure, bins, PF, '2AFC', 'low');
	[highPE_3AFC_paramsValues, highPE_3AFC_percentChosenTarget, highPE_3AFC_binCounter, highPE_3AFC_binCenter, highPE_3AFC_exitFlag, highPE_3AFC_pDev, highPE_3AFC_converged] = ...
        fitPsychometricFunction_AFC_PE(dataStructure, bins, PF, '3AFC', 'high');
	[ lowPE_3AFC_paramsValues,  lowPE_3AFC_percentChosenTarget,  lowPE_3AFC_binCounter,  lowPE_3AFC_binCenter,  lowPE_3AFC_exitFlag,  lowPE_3AFC_pDev,  lowPE_3AFC_converged] = ...
        fitPsychometricFunction_AFC_PE(dataStructure, bins, PF, '3AFC', 'low');
    
    % Store the paramsValues
    paramsValues = [      AFC2_paramsValues; ...
                          AFC3_paramsValues; ...
                   highPE_2AFC_paramsValues; ...
                    lowPE_2AFC_paramsValues; ...
                   highPE_3AFC_paramsValues; ...
                    lowPE_3AFC_paramsValues];
    
    % Store the binCounters
    binCounter = [       AFC2_binCounter; ...
                         AFC3_binCounter; ...
                  highPE_2AFC_binCounter; ...
                   lowPE_2AFC_binCounter; ...
                  highPE_3AFC_binCounter; ...
                   lowPE_3AFC_binCounter];
               
    % Store the exitFlags
    exitFlags = [        AFC2_exitFlag; ...
                         AFC3_exitFlag; ...
                  highPE_2AFC_exitFlag; ...
                   lowPE_2AFC_exitFlag; ...
                  highPE_3AFC_exitFlag; ...
                   lowPE_3AFC_exitFlag];           
               
    % Store the pDevs
    pDevs =  [       AFC2_pDev; ...
                     AFC3_pDev; ...
              highPE_2AFC_pDev; ...
               lowPE_2AFC_pDev; ...
              highPE_3AFC_pDev; ...
               lowPE_3AFC_pDev];
           
    % Store the converged-s
    converged = [       AFC2_converged, ...
                        AFC3_converged, ...
                 highPE_2AFC_converged, ...
                  lowPE_2AFC_converged, ...
                 highPE_3AFC_converged, ...
                  lowPE_3AFC_converged];
    
    
    % ============================  CURVE PLOTTING  ============================
    
    % Get the fine-grained x-axis values
    stimLevelsFine = xMin:(xMax-xMin)/1000:xMax;
    
    % ******************** AFC Plot ********************
    
    % Get the fit for the different conditions
    AFC2_fit =  PF(AFC2_paramsValues,stimLevelsFine);
    AFC3_fit =  PF(AFC3_paramsValues,stimLevelsFine);
        
    % New figure
    figure;
    
    % -- 2AFC --
    hold on;
    % Plot the points
    plot(AFC2_binCenter, AFC2_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', AFC2_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h1 = plot(stimLevelsFine, AFC2_fit, 'Color', AFC2_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
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
    legend([h1 h2], {'2AFC', '3AFC'}, 'Location', 'SouthEast');
    
    
    % ------ Saving ------
    
    % Only save the figure if we want to
    if(saveFigure)
    
        % Create the file name and path to save
        savingFileName = ['subject_' num2str(subjectNumber) '_AFC_PF.jpg'];
        savingFilePath = [pwd '/Figures/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);
    
    end
    
    
    
    % ******************** PE & AFC Plot ********************
    
    % Get the fit for the different conditions
    highPE_2AFC_fit = PF(highPE_2AFC_paramsValues,stimLevelsFine);
    lowPE_2AFC_fit  = PF( lowPE_2AFC_paramsValues,stimLevelsFine);
    highPE_3AFC_fit = PF(highPE_3AFC_paramsValues,stimLevelsFine);
    lowPE_3AFC_fit  = PF( lowPE_3AFC_paramsValues,stimLevelsFine);
    
    % New figure
    figure;
    
    % -- highPE_2AFC --
    hold on;
    % Plot the points
    plot(highPE_2AFC_binCenter, highPE_2AFC_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', highPE_2AFC_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h3 = plot(stimLevelsFine, highPE_2AFC_fit, 'Color', highPE_2AFC_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
    % -- lowPE_2AFC --
    hold on;
    % Plot the points
    plot(lowPE_2AFC_binCenter, lowPE_2AFC_percentChosenTarget, ...
        'Marker', marker, 'MarkerSize', markerSize, 'MarkerEdgeColor', lowPE_2AFC_Color, 'Color', 'none');
    hold on;
    % Plot the curve
    h4 = plot(stimLevelsFine, lowPE_2AFC_fit, 'Color', lowPE_2AFC_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    
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
    legend([h3 h4 h5 h6],{'highPE - 2AFC',' lowPE - 2AFC', 'highPE - 3AFC',' lowPE - 3AFC'}, 'Location', 'SouthEast');
    
    
    % ------ Saving ------
    
    % Only save the figure if we want to
    if(saveFigure)
    
        % Create the file name and path to save
        savingFileName = ['subject_' num2str(subjectNumber) '_PE&AFC_PF.jpg'];
        savingFilePath = [pwd '/Figures/' savingFileName];

        % Save the data
        saveas(gcf,savingFilePath);
    
    end
    
    
end % End of fitAllPFs 