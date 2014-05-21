% finds the best valeu of epsilon given the optimal decision data
function bestEps = findBestEpsilonValue(T,optimalDecisions, armDistributions)
    bestMatchPercent = 0;
    bestEps = 0;
    
    % grid search over epsilon values
    for e = 0 : 0.001 : 1
        
        % for each value of epsilon, run epsilon-greedy model and get decisions
        eGreedyDecisions = simulateEpsilonGreedy(T, armDistributions, e);
        
        % compare decisions with optimal decisions
        matchPercent = compareDecisions(eGreedyDecisions, optimalDecisions);
        if (matchPercent > bestMatchPercent)
            %fprintf('match percent updated for epsilon = %f to %f\n', e, matchPercent);
            bestMatchPercent = matchPercent;
            bestEps = e;
        end
    end
end

