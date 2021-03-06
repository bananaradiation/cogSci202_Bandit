function [L] = L_WinStayLooseShift(a_vec, data_A, data_R, alpha, beta, gamma, T, n)

% 
% a_vec is the possible action vector with length T
%
% data is the data matrix from the mat, which is 10 by 50 by 8 or 16
%
% data_A is the action data and data_R is the reward data
%
% alpha is a vector
%
% beta is a vector
%
% T is the trial numbers (8 or 16)
%
% n is the number of the subject 
%
% This function is to generate the likelihood given the data
% The search space should go through alpha, beta, and epsilon
% which are given in this simple function
%
% The L will be a matrix n by 50, n is the subject, 50 is the 50 games

L = zeros(n,50);

for i = 1:n;

  seq_A = squeeze(data_A(i,:,:));
  seq_R = squeeze(data_R(i,:,:));

  for games = 1:size(seq_A,1);
   
   % Initialize the mu, s, f, and LL

    mu_1 = alpha/(alpha+beta);
    mu_2 = alpha/(alpha+beta);
    s_1 = 0;
    s_2 = 0;
    f_1 = 0;
    f_2 = 0;
    LL = 1;

  if seq_A(games,1) == 0;

  LL = (mu_1^(seq_R(games,1)))*((1-mu_1)^(1-seq_R(games,1)));
  s_1 = s_1 + 1*seq_R(games,1);
  f_1 = f_1 + 1*(abs(1-seq_R(games,1)));

  else

  LL = (mu_2^(seq_R(games,1)))*((1-mu_2)^(1-seq_R(games,1)));
  s_2 = s_2 + 1*seq_R(games,1);
  f_2 = f_2 + 1*(abs(1-seq_R(games,1)));

  end;

  mu_1 = (alpha + s_1)/(1 + alpha + beta);
  mu_2 = (alpha + s_2)/(1 + alpha + beta);

  for trial = 2:T;

  % Components for the likelihood function of each trial 
  % List out the rules 

     stay = 1 - abs(seq_A(games, trial - 1) - a_vec(trial));
    
     if seq_R(games,trial-1) == 1;

     a = (gamma^(stay))*((1-gamma)^(1 - stay));

     else;

     a = ((1-gamma)^(stay))*(gamma^(1 - stay));

     end; 

     if seq_A(games,trial) == 0;

     r = (mu_1^(seq_R(games,trial)))*((1-mu_1)^(1-seq_R(games,trial)));
     s_1 = s_1 + 1*seq_R(games,trial);
     f_1 = f_1 + 1*(abs(1-seq_R(games,trial)));  

     else

     r = (mu_2^(seq_R(games,trial)))*((1-mu_2)^(1-seq_R(games,trial)));
     s_2 = s_2 + 1*seq_R(games,trial);
     f_2 = f_2 + 1*(abs(1-seq_R(games,trial)));
     end;


     LL = LL*a*r; 

     mu_1 = (alpha + s_1)/(s_1 + f_1 + alpha + beta);
     mu_2 = (alpha + s_2)/(s_2 + f_2  + alpha + beta);

     end;

  L(i,games) = LL;

  end;

end


 
