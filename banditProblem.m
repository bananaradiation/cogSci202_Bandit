function [percentMatch] = banditProblem(alphaVec, betaVec, arms, trials, numGames, numModels)
    % environment order [plenty, neutral, scarce]
    % alphaVec = [4, 1, 2]
    % betaVec = [2, 1, 4]
    
    epsilonGdy = [.91, .95, .94];
    epsilonDec = [.62, .57, .56];
    tau = [5.1, 4.1, 2];
    gamma = [.87, .85, .72];
    
    numEnv = size(alphaVec,2);
    percentMatch = zeros(numEnv, numModels);
    decisionHeuristic = zeros(trials,1);
    for env = 1:numEnv
        for game = 1:numGames
            [decisionOpt, rewards, mu1, mu2] = optimalModel(trials,arms,alphaVec(env),betaVec(env));
            for model = 1:numModels
                
                % infer via grid search or select param values from paper
                
                if model == 1                
                    % model 1 eps-greedy
                    decisionHeuristic = simulateEpsilonGreedy(trials, [mu1; mu2], epsilonGdy(env));
                end
                if model == 2
                    % model 2 eps-decreasing
                    decisionHeuristic = simulateEpsilonDecreasing(trials, [mu1; mu2], epsilonDec(env));
                end
                if model == 3
                    % model 3 full-latent
                    decisionHeuristic = simulateFullLatentModel(trials, [mu1; mu2]);
                end
                if model == 4
                    % model 4 tau-switch
                    decisionHeuristic = simulateTauSwitchModel(trials, [mu1; mu2], tau(env));
                end
                if model == 5
                    % model 5 win-stay-lose-shift
                    % decisionHeuristic = simulateWinStayLoseShift(trials, [mu1; mu2], gamma(env));
                end
                percentMatch(env, model) = percentMatch(env, model) + compareDecisions(decisionOpt, decisionHeuristic)
            end
            
        end

        percentMatch(env,:)=percentMatch(env,:)./numGames;
    end
    
    % plot 

end