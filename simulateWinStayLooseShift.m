function decisions = simulateWinStayLooseShift(T, armDistributions, gamma)
    % arms : column vector of 2 elements containing mu_1 and mu_2 (Bernoulli distributions of the 2 arms)

    numArms = size(armDistributions,1);
    s = zeros(numArms, 1); % # successes from arms
    n = zeros(numArms, 1);  % # trials where arm 1 was chosen
    
    decisions = zeros(T,1);    
    
    for t = 1 : T
        if t == 1
          choice = binornd(1,0.5);
          decisions(t) = choice;
          continue;
        else
          g = rand();
        end;
        reward = selectArm(armDistributions(choice + 1));    % sample reward from the mu of the arm
        
        if reward == 1 && g > gamma;
          choice = choice;
        elseif reward == 1 && g <= gamma;
          choice = abs(choice - 1);
        elseif reward == 0 && g > gamma;
          choice = abs(choice - 1);  
        else 
          choice = choice;
        end;
        
        decisions(t) = choice;    % update decisions vector
        
    end
    
    decisions = decisions + 1;
    
end