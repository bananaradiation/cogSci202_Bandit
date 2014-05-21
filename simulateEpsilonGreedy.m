% runs the epsilon-greedy model for T number of trials and returns the a column vector of decisions taken by the model
function decisions = simulateEpsilonGreedy(T, arms, epsilon)
    s1 = 0;    % # successes from arm 1
    f1 = 0;    % # failures from arm 1
    s2 = 0;    % # successes from arm 2
    f2 = 0;    % # failures from arm 2
    for t = 1 : T
        % with probability epsilon, select randomly
        r = rand();
        if (r < 0.5
    end
end

function bestEps = findEpsilonValue(T,optimalDecisions, arms)
    bestMatchPercent = 0;
    bestEps = 0;
    
    % grid search over epsilon values
    for e = 0 : 0.001 : 1
        
        % for each value of epsilon, run epsilon-greedy model and get decisions
        eGreedyDecisions = simulateEpsilonGreedy(T, arms);
        
        % compare decisions with optimal decisions
        matchPercent = compareDecisions(eGreedyDecisions, optimalDecisions);
        if (matchPercent < bestPercent)
            bestPercent = matchPercent;
            bestEps = e;
        end
    end
end

% compares 2 column vectors representing decisions and returns a percentage of matches
function percentMatch = compareDecisions(decVector1, decVector2)
    sum(decVector1 == decVector2) / size(decVector1,1);
end
    

