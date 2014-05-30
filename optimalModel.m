function [valueMatrix decisionMatrix] = optimalModel(T,arms,alpha,beta)

    mu1 = betarnd(alpha,beta);
    mu2 = betarnd(alpha,beta);
    deductionVector = [ [-1,0,0,0]; [0,-1,0,0]; [0,0,-1,0]; [0,0,0,-1]];

    valueMatrix = zeros(9,9,9,9);
    decisionMatrix = zeros(9,9,9,9);

    for t = T:-1:1
        [allStates, numStates] = enumStates(t,arms);
        for i=1:numStates
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
               arm1Value = ((s1+alpha)/(totalArm1)) * valueMatrix(s1+1,idxS2,idxF1,idxF2) + ((f1+beta)/(totalArm1)) * valueMatrix(idxS1,idxS2,f1+1,idxF2) + mu1;
               
               arm2Value = ((s2+alpha)/(totalArm2)) * valueMatrix(idxS1,s2+1,idxF1,idxF2) + ((f2+beta)/(totalArm2)) * valueMatrix(idxS1,idxS2,idxF1,f2+1) + mu2;
               
               [valueMatrix(idxS1,idxS2,idxF1,idxF2), decisionMatrix(idxS1,idxS2,idxF1,idxF2)] = max([arm1Value,arm2Value]); 
           end  
        end
    end
end

