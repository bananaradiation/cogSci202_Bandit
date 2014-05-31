function [L] = L_EpsilonGreedy(a_vec, data_A, data_R, alpha, beta, tau, T, n)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % data is the data matrix from the mat, which is 10 by 50 by (8 or 16)
  % 
  % data_A is the action data
  % data_R is the reward data
  %
  % alpha' and beta' are environment belief for each human, same for both arms
  % T is the trial numbers (8 or 16)
  % n is the number of the subject (10)
  %
  % This function is to generate the likelihood given the data
  % The search space should go through alpha, beta, and tau
  % which are given in this simple function
  %
  % The L will be a matrix n by 50, n is the subject, 50 is the 50 games
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  L = zeros(n,50);
  mu = zeros(2,1);

  for i = 1:n;

    seq_A = squeeze(data_A(i,:,:));
    seq_R = squeeze(data_R(i,:,:));

    for games = 1:size(seq_A,1);
     
    % Initialize the mu, s, f, and LL
    mu(1) = alpha/(alpha+beta);
    mu(2) = mu(1);
    s = zeros(2,1);
    f = zeros(2,1);
    LL = 1;

    if seq_A(games,1) == 0;
      arm = seq_A(games,1)+1;
      LL = (mu(arm)^(seq_R(games,1)))*((1-mu(arm))^(1-seq_R(games,1)));
      s(arm) = s(arm) + 1*seq_R(games,1);
      f(arm) = f(arm) + 1*(abs(1-seq_R(games,1)));
    end

    mu = (alpha + s)/(1 + alpha + beta);

    for trial = 2:T;
      % compare human decision with previous state..?
      % use in full latent model..
      % z = (seq_A(games, trial - 1) == seq_A(games, trial));
      
      gamma = rand();

      % determine state and situation based on s_1,s_2,f_1,f_2 from 
      % explore state for z = 0, exploit state for z = 1
      z = (i < tau);

      if (s(1) == s(2) && f(1) == f(2)) 
        % Same situation   
        theta = 0.5;
      elseif (s(1) >= s(2) && f(1) <= f(2))
        % Arm 1 Better
        theta = gamma;
      elseif (s(1) <= s(2) && f(1) >= f(2))
        % Arm 2 Better
        theta = 1 - gamma;
      else
        if (s(1) < s(2) && f(1) < f(2))
          % Arm 1 Search
          if (z == 0)
              theta = gamma;
          else
              theta = 1 - gamma;
          end
        else
          % Arm 1 Stand
          if (z == 1)
              theta = gamma;
          else
              theta = 1 - gamma;
          end                
        end
      end   

      % Two components for the likelihood function of each trial 
      % value for a comes from action and depends on key model parameter
      % value for r comes from rewards and depends on mu
      
     a = (theta^(1-a_vec(trial)))*((1-theta)^(a_vec(trial))); 
   
    if seq_A(games,trial) == 0;
      arm = a_vec(trial)+1;
      r = (mu(arm)^(seq_R(games,trial)))*((1-mu(arm))^(1-seq_R(games,trial)));
      s(arm) = s(arm) + 1*seq_R(games,trial);
      f(arm) = f(arm) + 1*(abs(1-seq_R(games,trial)));
    end 
     
     LL = LL*a*r; 
     mu = (alpha + s)/(1 + alpha + beta);

    end

    L(i,games) = LL;

  end

end


 
