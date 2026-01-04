%% Holistic Swarm Optimization (HSO)

% Based on:
% "Holistic Swarm Optimization: A Novel Metaphor-less Algorithm Guided by Whole Population Information
% for Addressing Exploration-Exploitation Dilemma" 
% DOI: https://doi.org/10.1016/j.cma.2025.118208
clc;
clear;

%% Algorithm Parameters
nPop = 3;         % Population size
maxIt = 3;     % Maximum number of iterations
alpha = 3;         % Scaling factor for position updates

% Simulated Annealing parameters
initialTemp = 10000;
coolingRate = 0.995;

% Adaptive Mutation parameters
initialMutationRate = 0.5;
finalMutationRate = 0.1;
initialMutationStep = 0.3;
finalMutationStep = 0.1;

%% Problem Definition
nVar = 6;              % Number of decision variables
nObj=2;
iter=0;
%OSY
varMin=[0 0 1 0 1 0]; % Lower bound
varMax=[10 10 5 6 5 10]; % Upper bound
         
%% Initialization
for i=1:nPop
    positions(i,:)=varMin+(varMax-varMin).*rand(1,nVar); 
end
positionsNew = positions;

%% Main Loop
while iter < maxIt
    temp = initialTemp * (coolingRate ^ iter);

    % Update adaptive mutation parameters
    mutationRate = initialMutationRate - iter * ((initialMutationRate - finalMutationRate) / maxIt);
    mutationStep = initialMutationStep - iter * ((initialMutationStep - finalMutationStep) / maxIt);
    % Ensure positions remain within bounds
    positionsNew = max(min(positionsNew, varMax), varMin);
    for i = 1:nPop
        fitnessNew(i,1:nObj) = fitfunction(positionsNew(i,:));
    end
        combined_posfit = [positionsNew fitnessNew];
        pos_fitness_rank=NonDominatedSorting(nObj,nVar,combined_posfit); 

    % Sort and archive best solution
    [fitness, idx] = sort(fitness);
    positions = positions(idx, :);

    %% Coefficient Calculation (simplified, without sign)
    fitnessVector = fitness(:);
    differences = rms(fitnessVector) - fitnessVector;
    updateCoef = differences / sum(abs(differences));

    %% Position Update
    for i = 1:nPop
        for j = 1:nVar
            randWeights = rand(nPop, 1);
            displacement = alpha * sum(randWeights .* updateCoef .* (positions(:, j) - positions(i, j)));
            positionsNew(i, j) = positions(i, j) + displacement;
        end
    end

    %% Adaptive Mutation
    for i = 1:nPop
        if rand < mutationRate
            mutationVector = mutationStep * randn(1, nVar);
            positionsNew(i, :) = positionsNew(i, :) + mutationVector;
        end
    end
    positionsNew = max(min(positionsNew, varMax), varMin);
    iter = iter + 1;
    bestCosts(iter) = bestSol_cost;

    fprintf('Iter = %d, Best Cost = %.10f\n', iter, bestSol_cost);
end

%% Convergence Plot
figure;
semilogy(1:iter, bestCosts, 'LineWidth', 1.5);
xlabel('Iteration');
ylabel('Best Cost');
title('Convergence Curve of HSO');
grid on;


