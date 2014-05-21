function [decisions,rewards] = getDecisionVector1(T,valueMatrix,decisionMatrix)
    decisions = zeros(T,1);    
    prevState = [0,0,0,0];
    nextStateVector = eye(4);
    for i=1:T
        maxValue = -9999;
        decisions(i) = 0;
        for j=1:4
            newState = prevState + nextStateVector(j,:);
            
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
               if(valueMatrix(idxS1,idxS2,idxF1,idxF2) > maxValue)
                   maxValue = valueMatrix(idxS1,idxS2,idxF1,idxF2);
                   if(j==1 || j==3)
                       decisions(i) = 1;
                   else
                       decisions(i) = 2;
                   end
                   if(j==1 || j==2)
                       rewards(i) = 1;
                   else
                       rewards(i) = 0;
                   end
               end
        end
    end
end
