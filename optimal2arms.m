% This exact algorithm exhausts all possible states in a 15-trial, 4-armed bandit.

%%%%%%%%%%%%%%%%% 
% Initial setting
%%%%%%%%%%%%%%%%%

a0=2;b0=8; % parameters of the beta dist'n a priori

% number of possible states after 14th trial, 13th trial, ... 1st trial 
% (decision * outcome)

% for example, after the 1st trial, there are 4 decisions * 2 outcomes, 
% so the number of states of game is 8

% more specifically, consider the state of the game
% [s1 f1 s2 f2 s3 f3 s4 f4]
% where s1 is the number of successes obtained from arm 1, and f1 is the
% number of failures obtained from arm 1

ll=[165,120,84,56,35,20,10,4];

% array 'ind' contains indices of states 
% calculating this look-up array in advance for computational efficiency 
% in data-fitting and forward-play analyses

% array 'U' contains values of states
% array 'C' contains set of choices with the best value

ind=zeros(165,8); U=ind; C=cell(165,8);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcuting the value of states of the last decision trial (14th)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t=8; ii=0;
% notice that after trial t, # of successes and failures on all arms
% sum to t, i.e. s1+f1+s2+...+f4=t
for s1=0:t; 
    for s2=0:t-s1;
        s=s1+s2;
        for f1=0:t-s;
                    
ii=ii+1;
f2=t-s-f1; 
p(1)=(a0+s1)/(a0+b0+s1+f1); % value of arm 1
p(2)=(a0+s2)/(a0+b0+s2+f2);
% all possible states will be lined up a row, along with a row of indices 
% of corresponding states [s1, f1, s2, f2, s3, f3, s4, f4]

<<<<<<< Updated upstream
ind(ii,t)=f1+s2*(t+1)+s1*(t+1)^2;
% count by t+1 (to avoid over-writing indices)
=======
ind(ii,t)=f1+s2*(t+1)+s1*(t+1)^2; % count by t+1 (to avoid over-writing indices)
>>>>>>> Stashed changes

u=s+p;  % expected number of points earned from each arm                        
U(ii,t)=max(u); % best value
C{ii,t}=find(u==max(u)); % arms that have best value
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recursively compute values for all other trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for it=1:7;
    t=8-it;ii=0;
    UU=U(1:ll(it),t+1);
    in=ind(1:ll(it),t+1);
    for s1=0:t;
        tic;
        for s2=0:t-s1;
            s=s1+s2;
            for f1=0:t-s;
ii=ii+1;
f2=t-s-f1;                                       
p(1)=(a0+s1)/(a0+b0+s1+f1);
p(2)=(a0+s2)/(a0+b0+s2+f2);
ind(ii,t)=f1+s2*(t+1)+s1*(t+1)^2;

% j1s: index for next state, if choosing arm 1 and getting a success 
% j1f: index for next state, if choosing arm 1 and getting a failure 
j1s=f1+s2*(t+2)+(s1+1)*(t+2)^2;
j1f=(f1+1)+s2*(t+2)+s1*(t+2)^2;
j2s=f1+(s2+1)*(t+2)+s1*(t+2)^2;
j2f=f1+(s2+1)*(t+2)+s1*(t+2)^2;


% expected values, considering possible outcomes for each arm
UU(in==j1s)
UU(in==j1f)
u(1)=p(1)*UU(in==j1s)+(1-p(1))*UU(in==j1f);  
u(2)=p(2)*UU(in==j2s)+(1-p(2))*UU(in==j2f); 
U(ii,t)=max(u);
C{ii,t}=find(u==max(u));
            end
        end
        toc;
        display(['ii=' num2str(ii)]);
    end
end

save optimal22 U ind ll C