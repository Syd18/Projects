%%Jaya Algorithm (Constrained Continuous Problem)

%function JayaConstrainedContinuous()
clc
clear all
MaxRuns=10;
run=0;
while(run<MaxRuns)
tic
%Step 1: Parameters Initialization
population_size=25;
variables=30; % design variables
maximum_fun_eval=500000;
termination_criteria=floor(maximum_fun_eval/population_size);
lower_bound=-5*ones(1,variables);
upper_bound=5*ones(1,variables);
%Step 2: Initial Population Generation and their fitnesses
population=initial_population(lower_bound,upper_bound,population_size,variables);
fitness=fitness_function(population);

generation=0;

while(generation<termination_criteria)
    %Step 3.0: Identify best and worst solutions and modify solutions (population) based on those
    updated_population=update_population(population,fitness);
    %Step 3.1: Handling the lower and upper bound violation
    updated_population=trimmer(lower_bound,upper_bound,updated_population);
    %Step 3.2: Updating the fitness
    updated_fitness=fitness_function(updated_population);
    %Step 4: Greedy Selection Mechanism for replacing the worst solutions
    %in the updated population in comparison with old popultion
    [population,fitness]=greedy_selection(population,fitness,updated_population,updated_fitness);
    %disp('#### Generation Final Population ####');
    %disp([population]);
    %disp('#### Generation Final Fitness ####');
    %disp([fitness]);
    updated_population=[];
    updated_fitness=[];
    generation=generation+1;
    optimal_fitness(generation)=min(fitness);
end
%Run-wise Output
run=run+1;
Iteration=[1:termination_criteria];
runwise_fitness(:,run)=(optimal_fitness)';
% Create a scatter plot
plot(Iteration, runwise_fitness, '-',LineWidth=2);
%hold on
% Customize the plot (optional)
title('Convergence Curve');
xlabel('Iteration');
ylabel('Fitness Function');
legend(arrayfun(@(run) sprintf('Run %d', run), 1:termination_criteria, 'UniformOutput', false));
grid on;
[value,index]=min(optimal_fitness);
Function_Evaluation(run)=population_size*index;
run_best(run)=value;
mean_best_run(run)=mean(optimal_fitness);
FunctionEvaluationTime(run)=toc;
end

figure
scatter(Function_Evaluation,mean_best_run,300,'pentagram',MarkerFaceColor='red',MarkerEdgeColor='red')
title('Mean of Best Fitness vs FEs');
xlabel('FEs');
ylabel('Mean of Best Fitness');
grid on;

figure
scatter(Function_Evaluation,run_best,300,'hexagram',MarkerFaceColor='black',MarkerEdgeColor='black')
title('Run-Best Fitness vs FEs');
xlabel('FEs');
ylabel('Best Fitness');
grid on;

%Ultimate Output
MeanFunctionEvaluationTime=mean(FunctionEvaluationTime);
UltimateBest=min(run_best);
UltimateMeanBest=mean(run_best);
UltimateMedianBest=median(run_best);
UltimateWorstBest=max(run_best);
UltimateSTDBest=std(run_best);
mFes=mean(Function_Evaluation);
stdFes=std(Function_Evaluation);

fprintf('\n Ultimate Best=%g',UltimateBest);
fprintf('\n Ultimate Mean=%g',UltimateMeanBest);
fprintf('\n Ultimate Median=%g',UltimateMedianBest);
fprintf('\n Ultimate Worst=%g',UltimateWorstBest);
fprintf('\n Ultimate STD. DEV.=%g',UltimateSTDBest);
fprintf('\n Mean Function Evaluations=%f',mFes);
fprintf('\n Mean Function Evaluation Time=%f',MeanFunctionEvaluationTime)
%end
