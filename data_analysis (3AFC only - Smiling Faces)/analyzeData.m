% This script goes through the data, subject-by-subject, and analyzes them. 

clear;
close all;

% ----- PARAMETERS -----

% Save ALL the figures
saveFigure = 1;

% Create the bins
bins = [0, 0.1, 0.2, 0.4, 0.8, 1.6, 3.5];

% minimum percent correct before we toss
minPercentCorrect = 0.45;

% PE cutoffs
highPECutoff = 0;
lowPECutoff = 0.5;

% ----- Start reading the file -----

% Create a path to the text file with all the subjects
subjectOrPatient = 'subject'; %
path=[subjectOrPatient 's_Round1.txt'];
% Make an ID for the subject list file
subjectListFileId=fopen(path);
% Read in the number from the subject list
numberOfSubjects = fscanf(subjectListFileId,'%d');

% ----- Create stores and counters to store the discarded data -----

nDiscardedCompletedOnlyPhase1 = 0;
discardedSubjects_CompletedOnlyPhase1 = {};

nDiscardedIncompleteData = 0;
discardedSubjects_IncompleteData = {};

nDiscardedResponse100 = 0;
discardedSubjects_response100 = {};

nDiscardedLessThanXPercent = 0;
discardedSubjects_XPercent = {};

% For valid subjects
nValidSubjects = 0;

% ----- Create stores to store the variables -----
AFC3_Confidence_All = [];
highPE_3AFC_zScoreDiff_All = [];
lowPE_3AFC_zScoreDiff_All = [];

dPrimes_All = [];
chosenDistractor_All = [];

phase1Phase2Performance_All = [];


% For loop that loops through all the subjects
for i = 1:numberOfSubjects
    
    % Read the subject ID from the file, stop after each line
    subjectId = fscanf(subjectListFileId,'%s',[1 1]);
    % Print out the subject ID
    fprintf('subject: %s\n',subjectId);
    
    % Import the data
    Alldata = load([pwd '/Data/structure_data_' subjectId '.mat']);
    % Data structure that contains all the data for this subject
    dataStructure = Alldata.data;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% Your data extraction here %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % GATEKEEPER #1: Make sure that they went beyond phase 1
    if(length(dataStructure.workerId) == 66)
        
        % Increment the counter
        nDiscardedCompletedOnlyPhase1 = nDiscardedCompletedOnlyPhase1 + 1;
        
        % Store the subject ID into the cell array
        discardedSubjects_CompletedOnlyPhase1{size(discardedSubjects_CompletedOnlyPhase1,1) + 1} = subjectId;
    
    % Else we move to gatekeeper #2
    else
        
        % GATEKEEPER #2: Make sure that all trials are present
        if(length(dataStructure.workerId) < 489)

            % Increment the counter
            nDiscardedIncompleteData = nDiscardedIncompleteData + 1;

            % Store the subject ID into the cell array
            discardedSubjects_IncompleteData{size(discardedSubjects_IncompleteData,1) + 1} = subjectId;

        % Else we move to gatekeeper #3  
        else
            
            % Process the PE conditions of the data structure based on how
            % we want to categorize the trials
            [dataStructure, nLowPE, nHighPE] = categorizePE(dataStructure, lowPECutoff, highPECutoff);
            
            nLowPE_array(i) = nLowPE;
            nHighPE_array(i) = nHighPE;
            
            % Extract the info for plotting the phase1 performance
            currentPhase1Performance = extractPhase1Performance(dataStructure);
            % ^ In the form: [differenceMean, differenceSD]

            % Check how many trials the subject answered 100 as their response

            % Low PE
            nResponse100_3AFCConfidence_lowPE = length(...
                                     returnIndicesIntersect(...
                                         dataStructure.response, 100, ...
                                         dataStructure.trialType, '3AFC Confidence', ...
                                         dataStructure.PE, 'low'));
            % High PE
            nResponse100_3AFCConfidence_highPE = length(...
                                     returnIndicesIntersect(...
                                         dataStructure.response, 100, ...
                                         dataStructure.trialType, '3AFC Confidence', ...
                                         dataStructure.PE, 'high'));

            % Number of trials for each PE
            nTrialsPerPE = length(...
                             returnIndicesIntersect(...
                                 dataStructure.trialType, '3AFC Confidence', ...
                                 dataStructure.PE, 'high'));
            
            % GATEKEEPER #3: Make sure that the subjects did not respond
            % with all 100s in any of the conditions
            if(nResponse100_3AFCConfidence_lowPE  == nTrialsPerPE || ...
               nResponse100_3AFCConfidence_highPE == nTrialsPerPE )

                % Increment the counter
                nDiscardedResponse100 = nDiscardedResponse100 + 1;

                % Store the subject ID into the cell array
                discardedSubjects_response100{size(discardedSubjects_response100,1) + 1} = subjectId;


            % Else we move to gatekeeper #4
            else

                % Get the amount correct for each condition
                nCorrect_3AFC_lowPE = length(...
                                        returnIndicesIntersect(...
                                            dataStructure.trialType, '3AFC', ...
                                            dataStructure.PE, 'low', ...
                                            dataStructure.correct, '1'));
                nCorrect_3AFC_highPE = length(...
                                        returnIndicesIntersect(...
                                            dataStructure.trialType, '3AFC', ...
                                            dataStructure.PE, 'high', ...
                                            dataStructure.correct, '1'));

                % Divide by number of trials to get the percentage
                pCorrect_3AFC_lowPE = nCorrect_3AFC_lowPE/length(...
                                        returnIndicesIntersect(...
                                            dataStructure.trialType, '3AFC', ...
                                            dataStructure.PE, 'low'));

                pCorrect_3AFC_highPE = nCorrect_3AFC_highPE/length(...
                                        returnIndicesIntersect(...
                                            dataStructure.trialType, '3AFC', ...
                                            dataStructure.PE, 'high'));
                
                % Load in the performance for second phase
                currentPhase2Performance = [pCorrect_3AFC_lowPE, pCorrect_3AFC_highPE];
                
                % Store the performance for first and second phases
                phase1Phase2Performance_All(size(phase1Phase2Performance_All,1)+1,:) = [currentPhase1Performance, currentPhase2Performance];

                % Gatekeeper #4: Make sure the subjects get any of those 
                % below a certain percent correct
                if (pCorrect_3AFC_lowPE  < minPercentCorrect || ...
                    pCorrect_3AFC_highPE < minPercentCorrect)

                    % Increment the counter
                    nDiscardedLessThanXPercent = nDiscardedLessThanXPercent + 1;

                    % Store the subject ID into the cell array
                    discardedSubjects_XPercent{size(discardedSubjects_XPercent,1) + 1} = subjectId;

                % Else we continue with the analysis
                else

                    % Increment the number of valid subjects
                    nValidSubjects = nValidSubjects + 1;

                    % ---- Extract/analyze the data for this participant ----

                    % Extract the face rating differences
                    [currentDifference_M, currentDifference_F] = extractFaceRatings(dataStructure);

                    % Calculate the confidence and ZScore averages
                    confidenceAndZScore = extractConfidenceAndZScore3AFC(dataStructure);
                    % ^ In the form:
                    % [ highPE_3AFC_Confidence_mean, 
                    %    lowPE_3AFC_Confidence_mean, 
                    %   highPE_3AFC_zScoreDiff_mean, 
                    %    lowPE_3AFC_zScoreDiff_mean ]; (4 columns in one row)

                    % Calculate the d'for this participant
                    currentDPrime = calculateDPrime(dataStructure);
                    % ^ In the form: [dPrime_HighPE, dPrime_LowPE]
                    
                    % Calculate the number of trials where the subject
                    % chose the distractor
                    currentChosenDistractor = calculateChosenDistractor(dataStructure);
                    % ^ In the form: 
                    % [nChoseDistractor_HighPE, percentChoseDistractor_HighPE, nChoseDistractor_LowPE,  percentChoseDistractor_LowPE;]

                    % Percent chosen target vs distractor
                    current_linRegData_3AFC = targetChosenVsDistractor_Linear(dataStructure);
                    current_linRegData_3AFC_HighPE = targetChosenVsDistractor_Linear(dataStructure, 'high');
                    current_linRegData_3AFC_LowPE = targetChosenVsDistractor_Linear(dataStructure, 'low');
                    % ^ Each of these is a data structure with fields:
                    % x, X, y, b, yReg

                    % Fit the psychometric functions
                    [currentParamsValues_AFC_PE, currentBinCounter_AFC_PE, currentExitFlags_AFC_PE, currentPDevs_AFC_PE, currentConverged_AFC_PE]...
                        = fitAllPFs(dataStructure, bins, nValidSubjects, subjectOrPatient, saveFigure);
                    % ^ currentParamsValues in the form:
                    % [       AFC3_paramsValues;
                    %  highPE_3AFC_paramsValues;
                    %   lowPE_3AFC_paramsValues];

                    % Fit the psychometric function for Norm
                    currentParamsValues_Norm = fitPsychometricFunction_Norm(dataStructure, nValidSubjects, subjectOrPatient, saveFigure);

                    % Fit the psychometric function for Norm and PE
                    [currentParamValues_PE_Norm, currentChosenFaces_PE_Norm]= fitPsychometricFunction_PE_Norm(dataStructure, nValidSubjects, subjectOrPatient, saveFigure);

                    % Extract data for logistic regression
                    currentSubjectLogRegData = extractLogRegData(dataStructure);

                    % Extract data for the 3d plot
                    currentSubject3DPlotData = extract3DPlotData(dataStructure, nValidSubjects, subjectOrPatient);
                    
                    % Extract z-score distribution data
                    currentSubjectZScoreDistribution = extractZScoreDistribution(dataStructure);
                    % ^ Data Structure with 2 fields: 
                    % (1) M_zScores and
                    % (2) F_zScores
                    
                    % ---- Store the data ----

                    % Rating Difference
                    ratingDifference(nValidSubjects,:,1) = currentDifference_M;
                    ratingDifference(nValidSubjects,:,2) = currentDifference_F;
                    
                    % dPrime
                    dPrimes_All(size(dPrimes_All,1)+1,:) = currentDPrime;
                    
                    % choseDistractor
                    chosenDistractor_All(size(chosenDistractor_All,1)+1,:) = currentChosenDistractor;
                    
                    % AFC_Confidence
                    AFC3_Confidence_All(size(AFC3_Confidence_All,1)+1,:) = [confidenceAndZScore(1),confidenceAndZScore(2)];
                    
                    % zScoreDiff_All
                    highPE_3AFC_zScoreDiff_All(length(highPE_3AFC_zScoreDiff_All)+1,1) = confidenceAndZScore(2);
                    lowPE_3AFC_zScoreDiff_All(length(lowPE_3AFC_zScoreDiff_All)+1,1)  = confidenceAndZScore(3);

                    % PE and AFC
                    paramsValues_AFC_PE_All(:,:,nValidSubjects) = currentParamsValues_AFC_PE;
                    binCounter_AFC_PE_All(:,:,nValidSubjects) = currentBinCounter_AFC_PE;
                    exitFlags_AFC_PE_All(:,nValidSubjects) = currentExitFlags_AFC_PE;
                    pDevs_AFC_PE_All(:,nValidSubjects) = currentPDevs_AFC_PE;
                    converged_AFC_PE_All(:,nValidSubjects) = currentConverged_AFC_PE;

                    % Normc
                    paramsValues_Norm_All(:,:,nValidSubjects) = currentParamsValues_Norm;

                    % PE & Norm
                    paramsValues_PE_Norm_All(:,:,nValidSubjects) = currentParamValues_PE_Norm;
                    chosenFaces_PE_Norm_All(:,:,nValidSubjects) = currentChosenFaces_PE_Norm;

                    % LinReg Data
                    currentSubject = ['subject' num2str(nValidSubjects)];
                    linReg_3AFC_All.(currentSubject) = current_linRegData_3AFC;
                    linReg_3AFC_HighPE_All.(currentSubject) = current_linRegData_3AFC_HighPE;
                    linReg_3AFC_LowPE_All.(currentSubject) = current_linRegData_3AFC_LowPE;

                    % LogReg Data
                    logReg_3AFC.(currentSubject) = currentSubjectLogRegData;

                    % 3D Plot data
                    plot3D_All.(currentSubject) = currentSubject3DPlotData;
                    
                    % z-Score distribution data
                    zScore_Distribution_M.(currentSubject) = currentSubjectZScoreDistribution.M_zScores;
                    zScore_Distribution_F.(currentSubject) = currentSubjectZScoreDistribution.F_zScores;

                end % End of Gatekeeper #4

            end % End of Gatekeeper #3

        end % End of Gatekeeper #2
    
    end % End of Gatekeeper #1
    
end % End of for loop that loops through each subject

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Your analysis here %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;

% ----- Make Subject Colors -----

% Seed the Random Number Generator for subject Colors
rng(4);

% Make the colors
subjectColors = rand(nValidSubjects,3);

% ----- Plots and Analyses -----

% Analyze the d's
analyzeAndPlotDPrimes(dPrimes_All, subjectOrPatient, saveFigure);

% Plot the % chosenDistractors
plotChosenDistractor(chosenDistractor_All, subjectOrPatient, saveFigure);

% Analyze the confidences
analyzeAndPlotConfidence(AFC3_Confidence_All, subjectOrPatient, saveFigure);

% Plot the scatter plot of confidence vs d'
scatterPlotConfidenceVsDPrime(dPrimes_All,AFC3_Confidence_All, subjectOrPatient, saveFigure);

% Analyze PE and Norm
analyze_PE_Norm(chosenFaces_PE_Norm_All, subjectOrPatient, saveFigure);

% Plot the data
plotLinRegData(linReg_3AFC_All, 'BothPE',subjectColors, subjectOrPatient, saveFigure);
plotLinRegData(linReg_3AFC_HighPE_All, 'HighPE', subjectColors, subjectOrPatient, saveFigure);
plotLinRegData(linReg_3AFC_LowPE_All, 'LowPE', subjectColors, subjectOrPatient, saveFigure);

% Run the logisitc regression
runLogisticRegression(logReg_3AFC, subjectOrPatient, saveFigure);

% Plot the average psychometric function
plotAveragePF(paramsValues_AFC_PE_All, paramsValues_Norm_All, subjectOrPatient, saveFigure);

% Plot the 3D Scatter Plot
plot3DScatter(plot3D_All, subjectColors, subjectOrPatient, saveFigure);

% Plot the phase1 performance vs phase2 performance
plotPhase1Phase2Performance(phase1Phase2Performance_All, minPercentCorrect, subjectOrPatient, saveFigure);

% Plot the distribution of z-scores
plotZScoreDistribution(zScore_Distribution_M, zScore_Distribution_F, subjectOrPatient, saveFigure);



