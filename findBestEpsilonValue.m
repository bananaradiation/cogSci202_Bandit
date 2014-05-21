% finds the best valeu of epsilon given the optimal decision data
function bestEps = findBestEpsilonValue(T,optimalDecisions, arms)
    bestMatchPercent = 0;
    bestEps = 0;
    
    % grid search over epsilon values
    for e = 0 : 0.001 : 1
        
        % for each value of epsilon, run epsilon-greedy model and get decisions
        eGreedyDecisions = simulateEpsilonGreedy(T, arms, epsilon);
        
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
    % arms : column vector of 2 elements containing mu_1 and mu_2 (Bernoulli distributions of the 2 arms)

    numArms = size(arms,1);
    s = zeros(numArms, 1); % # successes from arms
    n = zeros(numArms, 1);  % # trials where arm 1 was chosen
    
    decisions = zeros(T,1);    
    
    for t = 1 : T
        r = rand(); 
        if (r < epsilon)
            % with probability epsilon, select randomly
            r = rand();
            if (r > 0.5)
                choice = 0;         % choose arm 1       
            else
                choice = 1;    % choose arm 2
            end
        else
            % with probability 1 - epsilon, exploit based on experience so far
            if ((s(1) / n(1)) > (s(2) / n(2)))                
                choice = 0;        % choose arm 1
            else                
                choice = 1;        % choose arm 2
            end
        end
        decisions(t) = choice;    % update decisions vector
        n(choice) = n(choice) + 1;        % update n vector
        reward = selectArm(arms(choice));    % sample reward from the mu of the arm
        s(choice) = s(choice) + reward;    % update success vector
    end
end
