
function [FinalOutput]=MOJayaUnconstrained()
run=0;
MaxRuns=1;

while(run<MaxRuns)

%Step 1: Parameters Initialization
population_size=100;
sch=[0 0];
lower_bound=[5 1.4 6 15]; 
upper_bound=[9 2.2 14 25];
variables=numel(lower_bound); %design variables
m=numel(sch);
generation=0;
FEs=0;
maxFEs=5000;

%Step 2: Initial Population Generation and their fitnesses
population=initial_population(lower_bound,upper_bound,population_size,variables);
population(:,variables+1:variables+m)=fitness_function(population);
extended_population=population;

%Step 3: Non dominate sorting of initial population
population=nondominatedsort(m,variables,extended_population,sch);
population=population(1:population_size,:);

while(FEs<=maxFEs)
a= population(:,variables+m+1)==1;
b=find(population(a,variables+m+2)==Inf);
count=numel(b);

%Step 4: Population Update, Trimming and their fitnesses
updated_population=update_population(population(:,1:variables),count);
updated_population=trimmer(lower_bound,upper_bound,updated_population);
updated_population(:,variables+1:variables+m)=fitness_function(updated_population);

combined_population=cat(1,population(:,1:variables+m),updated_population);

%Step 5: Non dominated solution evaluation
population=nondominatedsort(m,variables,combined_population,sch);
population=population(1:population_size,:);
FEs=FEs+population_size;
disp(FEs);

%Result
Pareto_Front=[population(:,variables+1) population(:,variables+2) population(:,variables+3)];
[Pareto_Front_Sorted,inx]=sortrows(Pareto_Front);
non_dominated_input=population(:,1:variables);
Non_Dominated_Solutions=non_dominated_input(inx,:);
FinalOutput=[Non_Dominated_Solutions Pareto_Front_Sorted];
plot(-population(:,variables+1),population(:,variables+2),'o');
grid on
xlabel('Z1');
ylabel('Z2');
generation=generation+1;
disp(generation);
figure(1);
end
run=run+1;
end
end

