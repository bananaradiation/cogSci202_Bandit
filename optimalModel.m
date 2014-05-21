function [decisionMatrix] = optimalModel(T,arms,alpha,beta)
    
    deductionVector = [ [-1,0,0,0]; [0,-1,0,0]; [0,0,-1,0]; [0,0,0,-1]];
    
    valueMatrix = zeros(9,9,9,9);
    decisionMatrix = zeros(9,9,9,9);
    
    for t = T:-1:1
        [allStates, numStates] = enumStates(t,arms);
        for i=1:numStates
           for j=1:4
               newState = allStates(i,:) + deductionVector(j,:);
               s1 = newState(1);
               s2 = newState(2);
               f1 = newState(3);
               f2 = newState(4);
               totalArm1 = s1+f1+alpha+beta;
               totalArm2 = s2+f2+alpha+beta;
               arm1Value = ((s1+alpha)/(totalArm1)) * valueMatrix(s1+1,s2,f1,f2) + ((f1+beta)/(totalArm1)) * valueMatrix(s1,s2,f1+1,f2) + ((s1+alpha)/(totalArm1));
               
               arm2Value = ((s2+alpha)/(totalArm2)) * valueMatrix(s1,s2+1,f1,f2) + ((f2+beta)/(totalArm2)) * valueMatrix(s1,s2,f1,f2+1) + ((s2+alpha)/(totalArm2));
               
               [valueMatrix(s1,s2,f1,f2), decisionMatrix(s1,s2,f1,f2)] = max([arm1Value,arm2Value]);
           end  
        end
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

% compares 2 column vectors representing decisions and returns a percentage of matches
function percentMatch = compareDecisions(decVector1, decVector2)
    sum(decVector1 == decVector2) / size(decVector1,1);
end