function [decisions,rewards, mu1, mu2] = optimalModel_new(T,arms,alpha,beta)

    % draw mu's
    mu1 = betarnd(alpha,beta);
    mu2 = betarnd(alpha,beta);
    deductionVector = [ [-1,0,0,0]; [0,-1,0,0]; [0,0,-1,0]; [0,0,0,-1]];

    p = zeros(2,1);
    valueMatrix = zeros(9,9,9,9);
    
    % separate initialization for last trial
    [allStates, numEndStates] = enumStates(T,arms);    
    for i = 1 : numEndStates
        state = allStates(i,:);                
        s1 = state(1); s2 = state(2); f1 = state(3); f2 = state(4);
        p(1) = (s1 + alpha) / (s1 + f1 + alpha + beta);
        p(2) = (s2 + alpha) / (s2 + f2 + alpha + beta);
        u = s1 + s2 + p;
        state(state == 0) = 9;
        idxS1 = state(1); idxS2 = state(2); idxF1 = state(3); idxF2 = state(4);
        valueMatrix(idxS1,idxS2,idxF1,idxF2) = max(u);
        %fprintf('Se');
    end

    % recursive formulation for remaining states
    for t = T:-1:2
        [allStates, numStates] = enumStates(t,arms);
        for i=1:numStates
%             fprintf('At state : %d,%d,%d,%d',allStates(i,1),allStates(i,2),allStates(i,3),allStates(i,4));
            %allStates(i)
            for j=1:4
               if allStates(i,j) == 0
                   continue;
               end
               newState = allStates(i,:) + deductionVector(j,:);
               s1 = newState(1);
               s2 = newState(2);
               f1 = newState(3);
               f2 = newState(4);

               vector = [s1,s2,f1,f2];
               vector(vector==0) = 9;
               idxS1 = vector(:,1);
               idxS2 = vector(:,2);
               idxF1 = vector(:,3);
               idxF2 = vector(:,4);             

               totalArm1 = s1+f1+alpha+beta;
               totalArm2 = s2+f2+alpha+beta;
               %sample Reward From Mu    
               arm1Reward = binornd(1, mu1);
               arm2Reward = binornd(1, mu2);
               arm1CurrentReward = 0;
               arm2CurrentReward = 0 ;

               %if(arm1Reward == 1)
               %arm1CurrentReward = (s1+alpha)/(totalArm1);
               %end
               %if(arm2Reward == 1)
               %arm2CurrentReward = (s2+alpha)/(totalArm2);
               %end


               arm1Value = ((s1+alpha)/(totalArm1)) * valueMatrix(s1+1,idxS2,idxF1,idxF2) + ((f1+beta)/(totalArm1)) * valueMatrix(idxS1,idxS2,f1+1,idxF2) + arm1CurrentReward;

               arm2Value = ((s2+alpha)/(totalArm2)) * valueMatrix(idxS1,s2+1,idxF1,idxF2) + ((f2+beta)/(totalArm2)) * valueMatrix(idxS1,idxS2,idxF1,f2+1) + arm2CurrentReward;

               oldValue = valueMatrix(idxS1,idxS2,idxF1,idxF2);
               [valueMatrix(idxS1,idxS2,idxF1,idxF2), decisionMatrix(idxS1,idxS2,idxF1,idxF2)] = max([arm1Value,arm2Value]); 
               if (valueMatrix(idxS1,idxS2,idxF1,idxF2) ~= oldValue && oldValue ~= 0)
                   error('ERROR : Value overwritten !!!');
               end
               %max([arm1Value,arm2Value])
               
%                fprintf('Setting value function of state : %d,%d,%d,%d to value = %f\n',idxS1,idxS2,idxF1,idxF2, valueMatrix(idxS1,idxS2,idxF1,idxF2));
               
            end  
        end
    end
%     [decisions,rewards] = getDecisionVector1(T,valueMatrix);
    [decisions, rewards] = getDecisionVectorFromDecisionMatrix(decisionMatrix, T, [mu1,mu2]');
end
