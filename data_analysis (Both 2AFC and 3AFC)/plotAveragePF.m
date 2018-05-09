function plotAveragePF(paramsValues_All, paramsValues_Norm_All)
    
    % ========== PARAMETERS BEGIN ==========
    
    % The kind of average function to use
    useAverageParameters = 0;
    useBoundedline = 1;
    
    % Save the figure
    saveFigure = 1; % For all figures
    
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
    highNorm_Color = [222,   0, 222]./255; % Dark Purple
    lowNorm_Color =  [255, 150, 255]./255; % Light Purple
    
    % ========== PARAMETERS END ==========
    
    % The number of subjects
    nSubjects = size(paramsValues_All,3);
    
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

        % 2AFC
        AFC2_alpha_mean = mean(paramsValues_All(1,alphaIndex,:));
        AFC2_beta_mean = mean(paramsValues_All(1,betaIndex,:));
        AFC2_gamma_mean = mean(paramsValues_All(1,gammaIndex,:));
        AFC2_lambda_mean = mean(paramsValues_All(1,lambdaIndex,:));

        % 3AFC
        AFC3_alpha_mean = mean(paramsValues_All(2,alphaIndex,:));
        AFC3_beta_mean = mean(paramsValues_All(2,betaIndex,:));
        AFC3_gamma_mean = mean(paramsValues_All(2,gammaIndex,:));
        AFC3_lambda_mean = mean(paramsValues_All(2,lambdaIndex,:));

        % Get the fit for the different conditions
        AFC2_fit =  PF([AFC2_alpha_mean, AFC2_beta_mean, AFC2_gamma_mean, AFC2_lambda_mean],stimLevelsFine);
        AFC3_fit =  PF([AFC3_alpha_mean, AFC3_beta_mean, AFC3_gamma_mean, AFC3_lambda_mean],stimLevelsFine);

        % New figure
        figure;

        % -- 2AFC --
        hold on;
        % Plot the curve
        h1 = plot(stimLevelsFine, AFC2_fit, 'Color', AFC2_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);

        % -- 3AFC --
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
            savingFileName = ['average_AFC_PF_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/' savingFileName];

            % Save the data
            saveas(gcf,savingFilePath);

        end

        % ******************** PE & AFC Plot ********************

        % 2AFC && highPE
        highPE_2AFC_alpha_mean  = mean(paramsValues_All(3,alphaIndex,:));
        highPE_2AFC_beta_mean   = mean(paramsValues_All(3,betaIndex,:));
        highPE_2AFC_gamma_mean  = mean(paramsValues_All(3,gammaIndex,:));
        highPE_2AFC_lambda_mean = mean(paramsValues_All(3,lambdaIndex,:));

        % 2AFC && lowPE
        lowPE_2AFC_alpha_mean  = mean(paramsValues_All(4,alphaIndex,:));
        lowPE_2AFC_beta_mean   = mean(paramsValues_All(4,betaIndex,:));
        lowPE_2AFC_gamma_mean  = mean(paramsValues_All(4,gammaIndex,:));
        lowPE_2AFC_lambda_mean = mean(paramsValues_All(4,lambdaIndex,:));

        % 3AFC && highPE
        highPE_3AFC_alpha_mean  = mean(paramsValues_All(5,alphaIndex,:));
        highPE_3AFC_beta_mean   = mean(paramsValues_All(5,betaIndex,:));
        highPE_3AFC_gamma_mean  = mean(paramsValues_All(5,gammaIndex,:));
        highPE_3AFC_lambda_mean = mean(paramsValues_All(5,lambdaIndex,:));

        % 3AFC && lowPE
        lowPE_3AFC_alpha_mean  = mean(paramsValues_All(6,alphaIndex,:));
        lowPE_3AFC_beta_mean   = mean(paramsValues_All(6,betaIndex,:));
        lowPE_3AFC_gamma_mean  = mean(paramsValues_All(6,gammaIndex,:));
        lowPE_3AFC_lambda_mean = mean(paramsValues_All(6,lambdaIndex,:));


        % Get the fit for the different conditions
        highPE_2AFC_fit = PF([highPE_2AFC_alpha_mean, highPE_2AFC_beta_mean, highPE_2AFC_gamma_mean, highPE_2AFC_lambda_mean], stimLevelsFine);
        lowPE_2AFC_fit  = PF([ lowPE_2AFC_alpha_mean,  lowPE_2AFC_beta_mean,  lowPE_2AFC_gamma_mean,  lowPE_2AFC_lambda_mean], stimLevelsFine);
        highPE_3AFC_fit = PF([highPE_3AFC_alpha_mean, highPE_3AFC_beta_mean, highPE_3AFC_gamma_mean, highPE_3AFC_lambda_mean], stimLevelsFine);
        lowPE_3AFC_fit  = PF([ lowPE_3AFC_alpha_mean,  lowPE_3AFC_beta_mean,  lowPE_3AFC_gamma_mean,  lowPE_3AFC_lambda_mean], stimLevelsFine);

        % New figure
        figure;

        % -- highPE_2AFC --
        hold on;
        % Plot the curve
        h3 = plot(stimLevelsFine, highPE_2AFC_fit, 'Color', highPE_2AFC_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);

        % -- lowPE_2AFC --
        hold on;
        % Plot the curve
        h4 = plot(stimLevelsFine, lowPE_2AFC_fit, 'Color', lowPE_2AFC_Color, 'LineStyle', lineStyle, 'LineWidth', lineWidth);

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
        legend([h3 h4 h5 h6],{'highPE - 2AFC',' lowPE - 2AFC', 'highPE - 3AFC',' lowPE - 3AFC'}, 'Location', 'SouthEast');


        % ------ Saving ------

        % Only save the figure if we want to
        if(saveFigure)

            % Create the file name and path to save
            savingFileName = ['average__PE&AFC_PF_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/' savingFileName];

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
            savingFileName = ['average_Norm_PF_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/' savingFileName];

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
        AFC2_y = nan(nSubjects,length(stimLevelsFine));
        AFC3_y = nan(nSubjects,length(stimLevelsFine));

        % For loop that creates the y-values
        for i = 1:nSubjects

            AFC2_y(i,:) = PF([paramsValues_All(1,1,i), paramsValues_All(1,2,i), paramsValues_All(1,3,i), paramsValues_All(1,4,i)],stimLevelsFine);
            AFC3_y(i,:) = PF([paramsValues_All(2,1,i), paramsValues_All(2,2,i), paramsValues_All(2,3,i), paramsValues_All(2,4,i)],stimLevelsFine);

        end % End of for loop

        % Plot the graph
        figure;
        h1 = boundedline(stimLevelsFine, mean(AFC2_y,1),std(AFC2_y,0,1)./sqrt(nSubjects),'alpha', 'cmap', AFC2_Color);
        hold on;
        h2 = boundedline(stimLevelsFine, mean(AFC3_y,1),std(AFC3_y,0,1)./sqrt(nSubjects),'alpha', 'cmap', AFC3_Color);

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
            savingFileName = ['boundedline_AFC_PF_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/' savingFileName];

            % Save the data
            saveas(gcf,savingFilePath);

        end
        
        % ******************** AFC & PE ********************

        % Declare the matrix of the y-values
        highPE_2AFC_y = nan(nSubjects,length(stimLevelsFine));
        lowPE_2AFC_y = nan(nSubjects,length(stimLevelsFine));
        highPE_3AFC_y = nan(nSubjects,length(stimLevelsFine));
        lowPE_3AFC_y = nan(nSubjects,length(stimLevelsFine));

        % For loop that creates the y-values
        for i = 1:nSubjects

            highPE_2AFC_y(i,:) = PF([paramsValues_All(3,1,i), paramsValues_All(3,2,i), paramsValues_All(3,3,i), paramsValues_All(3,4,i)],stimLevelsFine);
            lowPE_2AFC_y(i,:) = PF([paramsValues_All(4,1,i), paramsValues_All(4,2,i), paramsValues_All(4,3,i), paramsValues_All(4,4,i)],stimLevelsFine);
            highPE_3AFC_y(i,:) = PF([paramsValues_All(5,1,i), paramsValues_All(5,2,i), paramsValues_All(5,3,i), paramsValues_All(5,4,i)],stimLevelsFine);
            lowPE_3AFC_y(i,:) = PF([paramsValues_All(6,1,i), paramsValues_All(6,2,i), paramsValues_All(6,3,i), paramsValues_All(6,4,i)],stimLevelsFine);

        end % End of for loop

        % Plot the graph
        figure;
        h3 = boundedline(stimLevelsFine, mean(highPE_2AFC_y,1),std(highPE_2AFC_y,0,1)./sqrt(nSubjects),'alpha', 'cmap', highPE_2AFC_Color);
        hold on;
        h4 = boundedline(stimLevelsFine, mean(lowPE_2AFC_y,1),std(lowPE_2AFC_y,0,1)./sqrt(nSubjects),'alpha', 'cmap', lowPE_2AFC_Color);
        hold on;
        h5 = boundedline(stimLevelsFine, mean(highPE_3AFC_y,1),std(highPE_3AFC_y,0,1)./sqrt(nSubjects),'alpha', 'cmap', highPE_3AFC_Color);
        hold on;
        h6 = boundedline(stimLevelsFine, mean(lowPE_3AFC_y,1),std(lowPE_3AFC_y,0,1)./sqrt(nSubjects),'alpha', 'cmap', lowPE_3AFC_Color);
        hold on;
        
        
        
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
            savingFileName = ['boundedline__PE&AFC_PF_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/' savingFileName];

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
            savingFileName = ['boundedline_Norm_PF_(n=' num2str(nSubjects) ').jpg'];
            savingFilePath = [pwd '/Figures/' savingFileName];

            % Save the data
            saveas(gcf,savingFilePath);

        end
        
    end % End of use boundedline
    
end % End of function