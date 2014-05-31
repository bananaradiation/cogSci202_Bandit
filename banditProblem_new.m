%function [percentMatch] = banditProblem(alphaVec, betaVec, arms, trials, numGames, numModels)
    % environment order [plenty, neutral, scarce]
    %alphaVec = [4, 1, 2];
    %betaVec = [2, 1, 4]; 
    alphaVec = [4];
    betaVec = [2];
    %epsilonGdy = [.91, .95, .94];
    epsilonDec = [.62, .57, .56];
    tau = [5.1, 4.1, 2];
    gamma = [.87, .85, .72];
    numIterations = 10;
    numModels = 1;
    numGames = 1;
    trials = 8;
    arms = 2;
    
    numEnv = size(alphaVec,2);
    percentMatch = zeros(numEnv, numModels);
    decisionHeuristic = zeros(trials,1);
    for env = 1:numEnv
        for game = 1:numGames
            [decisionOpt, rewards, mu1, mu2] = optimalModel_new(trials,arms,alphaVec(env),betaVec(env));
            for model = 1:numModels                
                % infer via grid search or select param values from paper                
                if model == 1      
                    fprintf('Finding best value of epsilon for e-greedy\n');
                    avgBestEps = 0;
                    for (i = 1  : numIterations)
                        [bestEps, ~] = findBestEpsilonValue(trials,decisionOpt, [mu1 ; mu2]);
                        avgBestEps = avgBestEps + bestEps / numIterations;
                    end
                    fprintf('Best epsilon value found = %f, simulating e-greedy now..\n',avgBestEps);
                    % model 1 eps-greedy
                    for (i = 1 : numIterations)
                        decisionHeuristic = simulateEpsilonGreedy(trials, [mu1; mu2], avgBestEps);
                        percentMatch(env, model) = percentMatch(env, model) + compareDecisions(decisionOpt, decisionHeuristic);
                    end
                    percentMatch(env,model) = percentMatch(env,model) / numIterations;   % average over iterations
                end
                if model == 2
                    fprintf('Simulating e-decreasing..\n');
                    % model 2 eps-decreasing
                    for (i = 1 : numIterations)
                        decisionHeuristic = simulateEpsilonDecreasing(trials, [mu1; mu2], epsilonDec(env));
                        percentMatch(env, model) = percentMatch(env, model) + compareDecisions(decisionOpt, decisionHeuristic);
                    end
                    percentMatch(env,model) = percentMatch(env,model) / numIterations;  % average over iterations
                end
                if model == 3
                    fprintf('Simulating Full latent..\n');
                    % model 3 full-latent                    
                    for (i = 1 : numIterations)
                        decisionHeuristic = simulateFullLatentModel(trials, [mu1; mu2]);
                        percentMatch(env, model) = percentMatch(env, model) + compareDecisions(decisionOpt, decisionHeuristic);
                    end
                    percentMatch(env,model) = percentMatch(env,model) / numIterations; % average over iterations
                end
                if model == 4
                    fprintf('Simulating T-switch..\n');
                    % model 4 tau-switch                    
                    for (i = 1 : numIterations)
                        decisionHeuristic = simulateTauSwitchModel(trials, [mu1; mu2], tau(env));
                        percentMatch(env, model) = percentMatch(env, model) + compareDecisions(decisionOpt, decisionHeuristic);
                    end
                    percentMatch(env,model) = percentMatch(env,model) / numIterations; % average over iterations
                end
                if model == 5
                    fprintf('Simulating WSLS..\n');
                    % model 5 win-stay-lose-shift
                    % decisionHeuristic = simulateWinStayLoseShift(trials, [mu1; mu2], gamma(env));
                end
                %percentMatch(env, model) = percentMatch(env, model) + compareDecisions(decisionOpt, decisionHeuristic);
            end
            
        end

        percentMatch(env,:)=percentMatch(env,:)./numGames;
    end
    
    % plot 
    percentMatch

    %end