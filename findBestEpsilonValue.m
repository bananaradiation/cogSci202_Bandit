% finds the best valeu of epsilon given the optimal decision data
% function bestEps = findBestEpsilonValue(T,optimalDecisions, optimalRewards, armDistributions, alpha, beta)
%     
%     maxLikelihood = -99999;
%     bestEps = 0;
%     numTrials = 8;
%     
%     data_A = zeros(1,1,numTrials);
%     data_R = zeros(1,1,numTrials);
%     data_A(1,1,:) = optimalDecisions;
%     data_R(1,1,:) = optimalRewards;
%     alpha = alpha * ones(2,1);
%     beta = beta * ones(2,1);
%     
%     % grid search over epsilon values
%     for e = 0 : 0.001 : 1
%         
%         % for each value of epsilon, run epsilon-greedy model and get decisions
%         %eGreedyDecisions = simulateEpsilonGreedy(T, armDistributions, e);
%         L = L_EpsilonGreedy(data_A, data_R, alpha, beta, e, T, 1);  
%         L = L(1,1);
%         
%         if (maxLikelihood < L)
%             maxLikelihood = L;
%             bestEps = e;            
%         end      
%         
%     end
% end

% finds the best valeu of epsilon given the optimal decision data
function [bestEps, eGreedyDecisions] = findBestEpsilonValue(T,optimalDecisions, armDistributions)
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
    %fprintf('match percent = %f\n', bestMatchPercent);
end
