function plotAveragePF(paramsValues_AFC_PE_All, paramsValues_Norm_All, subjectOrPatient, saveFigure)
    
    % ========== PARAMETERS BEGIN ==========
    
    % The kind of average function to use
    useAverageParameters = 1;
    useBoundedline = 1;
    
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
    highNorm_Color = [222,   0, 222]./255; % Dark Purple
    lowNorm_Color =  [255, 150, 255]./255; % Light Purple
    
    % ========== PARAMETERS END ==========
    
    % The number of subjects
    nSubjects = size(paramsValues_AFC_PE_All,3);
    
    % Get the fine-grained x-axis values
    stimLevelsFine = xMin:(xMax-xMin)/1000:xMax;
    
    % Indices for easy understanding
    alphaIndex = 1;
    betaIndex = 2;
    gammaIndex = 3; % Guess rate
    lambdaIndex = 4; % Lapse rate
    
    % If we want to use the average parameters
    if(useAverageParameters)
    
        % =====================================================================
        % =====================  (1)  AVERAGE PARAMETERS  =====================
        % =====================================================================

        % ******************** AFC ********************

        % 3AFC
        AFC3_alpha_mean = mean(paramsValues_AFC_PE_All(1,alphaIndex,:));
        AFC3_beta_mean = mean(paramsValues_AFC_PE_All(1,betaIndex,:));
        AFC3_gamma_mean = mean(paramsValues_AFC_PE_All(1,gammaIndex,:));
        AFC3_lambda_mean = mean(paramsValues_AFC_PE_All(1,lambdaIndex,:));

        % Get the fit for the different conditions
        AFC3_fit =  PF([AFC3_alpha_mean, AFC3_beta_mean, AFC3_gamma_mean, AFC3_lambda_mean],stimLevelsFine);

        % New figure
        figure;

        % -- 3AFC --
        hold on;
        % Plot the curve
        h2 = plot(stimLevelsFine, AFC3_fit, 'Color', AFC3_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);

        % ------ Formatting ------

        % Format the axes
        set(gca,'fontsize', fontSize);
        axis([xMin xMax yMin yMax]);

        % Add in the legend
        legend([h2], { '3AFC'}, 'Location', 'SouthEast');


        % ------ Saving ------

        % Only save the figure if we want to
        if(saveFigure)

            % Create the file name and path to save
            savingFileName = ['overall_averageParameters_AFC_PF_' subjectOrPatient 's_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

            % Save the data
            saveas(gcf,savingFilePath);

        end

        % ******************** PE & AFC Plot ********************

        % 3AFC && highPE
        highPE_3AFC_alpha_mean  = mean(paramsValues_AFC_PE_All(2,alphaIndex,:));
        highPE_3AFC_beta_mean   = mean(paramsValues_AFC_PE_All(2,betaIndex,:));
        highPE_3AFC_gamma_mean  = mean(paramsValues_AFC_PE_All(2,gammaIndex,:));
        highPE_3AFC_lambda_mean = mean(paramsValues_AFC_PE_All(2,lambdaIndex,:));
        disp(['highPE beta:' num2str(highPE_3AFC_beta_mean)]);

        % 3AFC && lowPE
        lowPE_3AFC_alpha_mean  = mean(paramsValues_AFC_PE_All(3,alphaIndex,:));
        lowPE_3AFC_beta_mean   = mean(paramsValues_AFC_PE_All(3,betaIndex,:));
        lowPE_3AFC_gamma_mean  = mean(paramsValues_AFC_PE_All(3,gammaIndex,:));
        lowPE_3AFC_lambda_mean = mean(paramsValues_AFC_PE_All(3,lambdaIndex,:));
        disp(['lowPE beta:' num2str(lowPE_3AFC_beta_mean)]);


        % Get the fit for the different conditions
        highPE_3AFC_fit = PF([highPE_3AFC_alpha_mean, highPE_3AFC_beta_mean, highPE_3AFC_gamma_mean, highPE_3AFC_lambda_mean], stimLevelsFine);
        lowPE_3AFC_fit  = PF([ lowPE_3AFC_alpha_mean,  lowPE_3AFC_beta_mean,  lowPE_3AFC_gamma_mean,  lowPE_3AFC_lambda_mean], stimLevelsFine);

        % New figure
        figure;
        
        % -- highPE_3AFC --
        hold on;
        % Plot the curve
        h5 = plot(stimLevelsFine, highPE_3AFC_fit, 'Color', highPE_3AFC_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);

        % -- lowPE_3AFC --
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
            savingFileName = ['overall_averageParameters__PE&AFC_PF_' subjectOrPatient 's_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

            % Save the data
            saveas(gcf,savingFilePath);

        end


        % ******************** Norm Plot ********************

        % High Norm
        highNorm_alpha_mean  = mean(paramsValues_Norm_All(1,alphaIndex,:));
        highNorm_beta_mean   = mean(paramsValues_Norm_All(1,betaIndex,:));
        highNorm_gamma_mean  = mean(paramsValues_Norm_All(1,gammaIndex,:));
        highNorm_lambda_mean = mean(paramsValues_Norm_All(1,lambdaIndex,:));

        % Low Norm
        lowNorm_alpha_mean  = mean(paramsValues_Norm_All(2,alphaIndex,:));
        lowNorm_beta_mean   = mean(paramsValues_Norm_All(2,betaIndex,:));
        lowNorm_gamma_mean  = mean(paramsValues_Norm_All(2,gammaIndex,:));
        lowNorm_lambda_mean = mean(paramsValues_Norm_All(2,lambdaIndex,:));

         % Get the fit for the different conditions
        highNorm_fit =  PF([highNorm_alpha_mean, highNorm_beta_mean, highNorm_gamma_mean, highNorm_lambda_mean],stimLevelsFine);
        lowNorm_fit =  PF([lowNorm_alpha_mean, lowNorm_beta_mean, lowNorm_gamma_mean, lowNorm_lambda_mean],stimLevelsFine);

        % New figure
        figure;

        % -- HighNorm --
        hold on;
        % Plot the curve
        h1 = plot(stimLevelsFine, highNorm_fit, 'Color', highNorm_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);

        % -- LowNorm --
        hold on;
        % Plot the curve
        h2 = plot(stimLevelsFine, lowNorm_fit, 'Color', lowNorm_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);

        % ------ Formatting ------

        % Format the axes
        set(gca,'fontsize', fontSize);
        axis([xMin xMax yMin yMax]);

        % Add in the legend
        legend([h1 h2], {'HighNorm', 'LowNorm'}, 'Location', 'SouthEast');


        % ------ Saving ------

        % Only save the figure if we want to
        if(saveFigure)

            % Create the file name and path to save
            savingFileName = ['overall_averageParameters_Norm_PF_' subjectOrPatient 's_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

            % Save the data
            saveas(gcf,savingFilePath);

        end
        
    end % End of useAverageParameters
    
    % If we want to use the boundedline
    if(useBoundedline)
    
        % =====================================================================
        % ========================  (2)  BOUNDEDLINE  =========================
        % =====================================================================

        % ******************** AFC ********************

        % Declare the matrix of the y-values
        AFC3_y = nan(nSubjects,length(stimLevelsFine));

        % For loop that creates the y-values
        for i = 1:nSubjects
            AFC3_y(i,:) = PF([paramsValues_AFC_PE_All(1,1,i), paramsValues_AFC_PE_All(1,2,i), paramsValues_AFC_PE_All(1,3,i), paramsValues_AFC_PE_All(1,4,i)],stimLevelsFine);

        end % End of for loop

        % Plot the graph
        figure;
        h2 = boundedline(stimLevelsFine, mean(AFC3_y,1),std(AFC3_y,0,1)./sqrt(nSubjects),'alpha', 'cmap', AFC3_Color);

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
            savingFileName = ['overall_boundedline_AFC_PF_' subjectOrPatient 's_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

            % Save the data
            saveas(gcf,savingFilePath);

        end
        
        % ******************** AFC & PE ********************

        % Declare the matrix of the y-values
        highPE_3AFC_y = nan(nSubjects,length(stimLevelsFine));
        lowPE_3AFC_y = nan(nSubjects,length(stimLevelsFine));

        % For loop that creates the y-values
        for i = 1:nSubjects
            highPE_3AFC_y(i,:) = PF([paramsValues_AFC_PE_All(2,1,i), paramsValues_AFC_PE_All(2,2,i), paramsValues_AFC_PE_All(2,3,i), paramsValues_AFC_PE_All(2,4,i)],stimLevelsFine);
            lowPE_3AFC_y(i,:)  = PF([paramsValues_AFC_PE_All(3,1,i), paramsValues_AFC_PE_All(3,2,i), paramsValues_AFC_PE_All(3,3,i), paramsValues_AFC_PE_All(3,4,i)],stimLevelsFine);
        end % End of for loop

        % Plot the graph
        figure;
        h5 = boundedline(stimLevelsFine, mean(highPE_3AFC_y,1),std(highPE_3AFC_y,0,1)./sqrt(nSubjects),'alpha', 'cmap', highPE_3AFC_Color);
        hold on;
        h6 = boundedline(stimLevelsFine, mean(lowPE_3AFC_y,1),std(lowPE_3AFC_y,0,1)./sqrt(nSubjects),'alpha', 'cmap', lowPE_3AFC_Color);
        hold on;
        
        
        
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
            savingFileName = ['overall_boundedline__PE&AFC_PF_' subjectOrPatient 's_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

            % Save the data
            saveas(gcf,savingFilePath);

        end
        
        % ******************** Norm Plot ********************

        % Declare the matrix of the y-values
        highNorm_y = nan(nSubjects,length(stimLevelsFine));
        lowNorm_y = nan(nSubjects,length(stimLevelsFine));

        % For loop that creates the y-values
        for i = 1:nSubjects

            highNorm_y(i,:) = PF([paramsValues_Norm_All(1,1,i), paramsValues_Norm_All(1,2,i), paramsValues_Norm_All(1,3,i), paramsValues_Norm_All(1,4,i)],stimLevelsFine);
            lowNorm_y(i,:) = PF([paramsValues_Norm_All(2,1,i), paramsValues_Norm_All(2,2,i), paramsValues_Norm_All(2,3,i), paramsValues_Norm_All(2,4,i)],stimLevelsFine);

        end % End of for loop

        % Plot the graph
        figure;
        h1 = boundedline(stimLevelsFine, mean(highNorm_y,1),std(highNorm_y,0,1)./sqrt(nSubjects),'alpha', 'cmap', highNorm_Color);
        hold on;
        h2 = boundedline(stimLevelsFine, mean(lowNorm_y,1),std(lowNorm_y,0,1)./sqrt(nSubjects),'alpha', 'cmap', lowNorm_Color);

        % ------ Formatting ------

        % Format the axes
        set(gca,'fontsize', fontSize);
        axis([xMin xMax yMin yMax]);

        % Add in the legend
        legend([h1 h2], {'HighNorm', 'LowNorm'}, 'Location', 'SouthEast');


        % ------ Saving ------

        % Only save the figure if we want to
        if(saveFigure)

            % Create the file name and path to save
            savingFileName = ['overall_boundedline_Norm_PF_' subjectOrPatient 's_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/Overall_' subjectOrPatient 's/' savingFileName];

            % Save the data
            saveas(gcf,savingFilePath);

        end
        
    end % End of use boundedline
    
end % End of function