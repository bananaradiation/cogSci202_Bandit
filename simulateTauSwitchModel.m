function [decisionVector] = simulateTauSwitchModel(numTrials,armDistributions, tau)
    numArms = size(armDistributions,1);
    s = zeros(numArms,1);
    f = zeros(numArms,1);
    decisionVector = zeros(numTrials,1);
    
    %gamma = pdf(makedist('Uniform'),[0:0.0001:1]);
    gamma = rand();
    
    for i = 1 : numTrials
        if(i<tau)
            z=0; %explore state
        else
            z=1; %exploit state
        end
            
        if (s(1) == s(2) && f(1) == f(2)) 
            state = 1;    % Same situation
            theta = 0.5;
        elseif (s(1) >= s(2) && f(1) <= f(2))
            state = 2;    % Arm 1 Better
            theta = gamma;
        elseif (s(1) <= s(2) && f(1) >= f(2))
            state = 3;    % Arm 2 Better
            theta = 1 - gamma;
        else
            if (s(1) < s(2) && f(1) < f(2))
                state = 4;     % Arm 1 Search
                if (z == 0)
                    theta = gamma;
                else
                    theta = 1 - gamma;
                end
            else
                state = 5;    % Arm 1 Stand
                if (z == 1)
                    theta = gamma;
                else
                    theta = 1 - gamma;
                end                
            end
        end        
        
        d = binornd(1,theta) + 1;
        decisionVector(i) = d;
        reward = binornd(1,armDistributions(d));
        s(d) = s(d) + reward;
        f(d) = f(d) + 1 - reward;        
        fprintf('State: %d, decision: %d, reward = %d\n',state, decisionVector(i), reward);
    end    
end