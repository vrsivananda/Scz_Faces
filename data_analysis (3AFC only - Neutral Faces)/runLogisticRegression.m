function runLogisticRegression(logReg_3AFC)
    
    % Get the number of subjects
    nSubjects = length(fieldnames(logReg_3AFC));
    
    % For loop for each subject
    for i = 1:nSubjects
        
        % Get the current subject
        currentSubject = logReg_3AFC.(['subject' num2str(i)]);
        
        % Get the predictor variables
        predictors = [currentSubject.zTarget, ...
                      currentSubject.zNonTarget, ...
                      currentSubject.zNonTarget_minus_zDistractor...
                      %currentSubject.zDistractor...
                      ];
        
        % Get the response variables
        responses = currentSubject.choseTarget;
        
        % Run the logistic regression
        B = glmfit(predictors,responses,'binomial');
        
        % Save it in the store
        coefficientStore(:,i) = B;
        
    end % End of for loop (i)
    
    % -------------- PLOTTING --------------
    
    % Parameters
    barColor = [0.7, 0.7, 0.7];
    minX = 0;
    maxX = 5;
    
    % Load in variables for easy handling
    X0 = coefficientStore(1,:);
    X1 = coefficientStore(2,:);
    X2 = coefficientStore(3,:);
    X3 = coefficientStore(4,:);

    % Calculate the mean
    X0_mean = mean(X0);
    X1_mean = mean(X1);
    X2_mean = mean(X2);
    X3_mean = mean(X3);
    
    % Calculate the sem
    X0_SEM = std(X0)/sqrt(nSubjects);
    X1_SEM = std(X1)/sqrt(nSubjects);
    X2_SEM = std(X2)/sqrt(nSubjects);
    X3_SEM = std(X3)/sqrt(nSubjects);
    
    % Load in the plotting variables for easy handling
    y = [X0_mean, X1_mean, X2_mean, X3_mean];
    
     % Plot the bar graph
    figure;
    bar(y,'FaceColor',barColor);
    hold on;
    errorbar([1,2,3,4],y,[X0_SEM, X1_SEM, X2_SEM, X3_SEM],'.');
    
    % Format the graph
    set(gca, 'XTickLabel', {'constant', 'zTarget', 'zNonTarget', 'zNonTarget-zDistractor'});
    xlim([minX maxX]);
    ylim([-5 5]);
    ylabel('Coefficient value');
    
    
    
end % End of function