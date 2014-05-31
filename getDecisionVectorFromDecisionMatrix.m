function [decisions, rewards] = getDecisionVectorFromDecisionMatrix(decisionMatrix, numTrials, armDistributions)
    decisions = zeros(numTrials, 1);
    rewards = zeros(numTrials, 1);
    s = zeros(2,1);
    f = zeros(2,1);
    
    % choose arm at first trial at random, sample reward and go to next state
    d = binornd(1,0.5) + 1;
    r = binornd(1,armDistributions(d));
    s(d) = s(d) + r;
    f(d) = f(d) + 1 - r;
    decisions(1) = d;
    rewards(1) = r;

    % for each trial, choose arm given by decision matrix, sample reward, go to next state
    for t = 2 : numTrials
        % replace 0's by 9
        v = [s(1) s(2) f(1) f(2)];
        v(v == 0) = 9;
        
        d = decisionMatrix(v(1),v(2),v(3),v(4));    % decision
        r = binornd(1, armDistributions(d));    % sample reward
        
        % update state
        s(d) = s(d) + r;
        f(d) = f(d) + 1 - r;
        decisions(t) = d;
        rewards(t) = r;
    end
end