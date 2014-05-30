% This exact algorithm exhausts all possible states in a 15-trial, 4-armed bandit.

%%%%%%%%%%%%%%%%% 
% Initial setting
%%%%%%%%%%%%%%%%%

a0=2;b0=2; % parameters of the beta dist'n a priori

% number of possible states after 14th trial, 13th trial, ... 1st trial 
% (decision * outcome)

% for example, after the 1st trial, there are 4 decisions * 2 outcomes, 
% so the number of states of game is 8

% more specifically, consider the state of the game
% [s1 f1 s2 f2 s3 f3 s4 f4]
% where s1 is the number of successes obtained from arm 1, and f1 is the
% number of failures obtained from arm 1

ll=[116280,77520,50388,31824,19448,11440,6435,3432,1716,792,330,120,36,8]; 

% array 'ind' contains indices of states 
% calculating this look-up array in advance for computational efficiency 
% in data-fitting and forward-play analyses

% array 'U' contains values of states
% array 'C' contains set of choices with the best value

ind=zeros(116280,14); U=ind; C=cell(116280,14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcuting the value of states of the last decision trial (14th)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t=14; ii=0;
% notice that after trial t, # of successes and failures on all arms
% sum to t, i.e. s1+f1+s2+...+f4=t
for s1=0:t; 
    for s2=0:t-s1;
        for s3=0:t-s1-s2;
            for s4=0:t-s1-s2-s3;
                s=s1+s2+s3+s4;
                for f1=0:t-s;
                    for f2=0:t-s-f1;
                        for f3=0:t-s-f1-f2;
ii=ii+1;
f4=t-s-f1-f2-f3;                                                
p(1)=(a0+s1)/(a0+b0+s1+f1); % value of arm 1
p(2)=(a0+s2)/(a0+b0+s2+f2);
p(3)=(a0+s3)/(a0+b0+s3+f3);
p(4)=(a0+s4)/(a0+b0+s4+f4);
% all possible states will be lined up a row, along with a row of indices 
% of corresponding states [s1, f1, s2, f2, s3, f3, s4, f4]

ind(ii,t)=f3+f2*(t+1)+f1*(t+1)^2+s4*(t+1)^3+...
    s3*(t+1)^4+s2*(t+1)^5+s1*(t+1)^6; % count by t+1 (to avoid over-writing indices)

u=s+p;  % expected number of points earned from each arm                        
U(ii,t)=max(u); % best value
C{ii,t}=find(u==max(u)); % arms that have best value
                        end
                    end
                end
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recursively compute values for all other trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for it=1:13;
    t=14-it;ii=0;
    UU=U(1:ll(it),t+1);in=ind(1:ll(it),t+1);
    for s1=0:t;
        tic;
        for s2=0:t-s1;
            for s3=0:t-s1-s2;
                for s4=0:t-s1-s2-s3;
                    s=s1+s2+s3+s4;
                    for f1=0:t-s;
                        for f2=0:t-s-f1;
                            for f3=0:t-s-f1-f2;
ii=ii+1;
f4=t-s-f1-f2-f3;                                                
p(1)=(a0+s1)/(a0+b0+s1+f1);
p(2)=(a0+s2)/(a0+b0+s2+f2);
p(3)=(a0+s3)/(a0+b0+s3+f3);
p(4)=(a0+s4)/(a0+b0+s4+f4);
ind(ii,t)=f3+f2*(t+1)+f1*(t+1)^2+s4*(t+1)^3+s3*(t+1)^4+s2*(t+1)^5+s1*(t+1)^6;

% j1s: index for next state, if choosing arm 1 and getting a success 
% j1f: index for next state, if choosing arm 1 and getting a failure 
j1s=f3+f2*(t+2)+f1*(t+2)^2+s4*(t+2)^3+s3*(t+2)^4+s2*(t+2)^5+(s1+1)*(t+2)^6;
j1f=f3+f2*(t+2)+(f1+1)*(t+2)^2+s4*(t+2)^3+s3*(t+2)^4+s2*(t+2)^5+s1*(t+2)^6;
j2s=f3+f2*(t+2)+f1*(t+2)^2+s4*(t+2)^3+s3*(t+2)^4+(s2+1)*(t+2)^5+s1*(t+2)^6;
j2f=f3+(f2+1)*(t+2)+f1*(t+2)^2+s4*(t+2)^3+s3*(t+2)^4+s2*(t+2)^5+s1*(t+2)^6;
j3s=f3+f2*(t+2)+f1*(t+2)^2+s4*(t+2)^3+(s3+1)*(t+2)^4+s2*(t+2)^5+s1*(t+2)^6;
j3f=(f3+1)+f2*(t+2)+f1*(t+2)^2+s4*(t+2)^3+s3*(t+2)^4+s2*(t+2)^5+s1*(t+2)^6;
j4s=f3+f2*(t+2)+f1*(t+2)^2+(s4+1)*(t+2)^3+s3*(t+2)^4+s2*(t+2)^5+s1*(t+2)^6;
j4f=f3+f2*(t+2)+f1*(t+2)^2+s4*(t+2)^3+s3*(t+2)^4+s2*(t+2)^5+s1*(t+2)^6;

% expected values, considering possible outcomes for each arm
u(1)=p(1)*UU(in==j1s)+(1-p(1))*UU(in==j1f);  
u(2)=p(2)*UU(in==j2s)+(1-p(2))*UU(in==j2f); 
u(3)=p(3)*UU(in==j3s)+(1-p(3))*UU(in==j3f); 
u(4)=p(4)*UU(in==j4s)+(1-p(4))*UU(in==j4f); 
U(ii,t)=max(u);
C{ii,t}=find(u==max(u));
                            end
                        end
                    end
                end
            end
        end
        toc;
        display(['ii=' num2str(ii)]);
    end
end

save optimal22 U ind ll C