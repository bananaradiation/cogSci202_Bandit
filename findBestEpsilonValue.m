% finds the best valeu of epsilon given the optimal decision data
function bestEps = findBestEpsilonValue(T,optimalDecisions, arms)
    bestMatchPercent = 0;
    bestEps = 0;
    
    % grid search over epsilon values
    for e = 0 : 0.001 : 1
        
        % for each value of epsilon, run epsilon-greedy model and get decisions
        eGreedyDecisions = simulateEpsilonGreedy(T, arms, e);
        
        % compare decisions with optimal decisions
        matchPercent = compareDecisions(eGreedyDecisions, optimalDecisions);
        if (matchPercent < bestMatchPercent)
            bestMatchPercent = matchPercent;
            bestEps = e;
        end
    end
end

