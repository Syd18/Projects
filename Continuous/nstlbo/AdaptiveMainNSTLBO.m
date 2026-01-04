%% Non-Dominated Sorting Teaching Learning Based Optimization Algorithm (NSTLBO) 
%(Constrained Problems)

%% Aurthor: Syed Shahed 
% Written in 2021

clear all;
clc;
close all
run=0;
maxrun=1;
while (run<maxrun)
%%Step 1: Initialization

iter=0; %initial function evaluation
maxIt=300; %maximum function evaluation
Generation=0;
PopulationSize=2; %population size
%Dim=2; %dimension
Dim=6; %dimension

%SNR
%LB=ones(1,Dim).*-20; %lower bound
%UB=ones(1,Dim).*20; %upper bound

Objectives=2; %objectives

%BNH
%LB=[0 0];
%UB=[5 3];

%OSY
LB=[0 0 1 0 1 0];
UB=[10 10 5 6 5 10];

%LB=[0.125 0.1  0.1 0.125];
%UB=[5.0 10.0 10.0 5.0];

% Adaptive Mutation parameters
initialMutationRate = 0.5;
finalMutationRate = 0.1;
initialMutationStep = 0.3;
finalMutationStep = 0.1;

%% Initialize the population
for i=1:PopulationSize
    Population(i,:)=LB+(UB-LB).*rand(1,Dim); 
    %f(i,1:Objectives) = fit_function(Population(i,:));
    f(i,1:Objectives) = fitfunction(Population(i,:));
end
Population=[Population f]; 
%Stored_Pop=Population; %stored initial population
%Population(:,Dim+1:Dim+Objectives)=Objective_Function(Population,Dim); %fitness of initial population
Pop_Obj_Matrix=Population; %initial population and fitness matrix
Population=NonDominatedSorting(Objectives,Dim,Pop_Obj_Matrix); %non dominated sort population and fitness matrix
iter=0;
%%Step 2: Main Loop

while(iter<=maxIt)
% Update adaptive mutation parameters
mutationRate = initialMutationRate - iter * ((initialMutationRate - finalMutationRate) / maxIt);
mutationStep = initialMutationStep - iter * ((initialMutationStep - finalMutationStep) / maxIt);

TopRank= Population(:,Dim+Objectives+1)==1; %finding rank 1 solution
TopRank_CD=find(Population(TopRank,Dim+Objectives+2)==Inf); %finding rank 1 with infinity crowding distance
Count=numel(TopRank_CD); %rank 1 solution numbers

%%Step 2.1: Teacher Phase

Population_Temp=Population(:,1:Dim); %restored Population
[row,col]=size(Population_Temp);
Best=Population_Temp(round(Count-(Count-1)*rand(1,1)),:); %best rank 1 solution selected as teacher
rn=rand(1,1);
Normal_Mean=mean(Population_Temp(:,1:Dim));  %mean of population
TeachingFactor=randi([1 2],1,1); %teaching factor

for j=1:row
for i=1:col    
    NormalMean=Normal_Mean(i); %normal mean
     Diff_Mean=rn*(Best(i)-(TeachingFactor*NormalMean)); %difference of the mean
     Population_New(j,i)=Population_Temp(j,i)+Diff_Mean; %solutions of teacher phrase
end
end
New_Pop=Corner_Bounding(LB,UB,Population_New); %applying corner bounding strategy
%New_Pop(:,Dim+1:Dim+Objectives)=Objective_Function(New_Pop,Dim); %evaluating new fitness values
for i=1:PopulationSize 
    %ff(i,1:Objectives) = fit_function(New_Pop(i,:));
    ff(i,1:Objectives) = fitfunction(New_Pop(i,:));
end
New_Pop=[New_Pop ff];
Combined_Pop=cat(1,Population(:,1:Dim+Objectives),New_Pop); %combination of previous population and populations of teacher phrase
Population=NonDominatedSorting(Objectives,Dim,Combined_Pop); %non dominated sorting
Population=Population(1:PopulationSize,:); %taking relevant solutions as population


%%Step 2.2: Learner Phase

%%Step 2.2.1: Peer selection
for i=1:PopulationSize
 Peer=randi([1,PopulationSize],1,1); %random peer selection
while i==Peer
        Peer=randi([1,PopulationSize],1,1); %ensuring that current member wont be the partner
end
Fitness_Ranking=Population(i,Dim+Objectives+1:end); %fitness ranking
Selected_Rank=Fitness_Ranking(1,1); %selected rank for learner phrase
Peer_Rank=Population(Peer,Dim+Objectives+1); %peer rank for learner phrase
Selected_CD=Fitness_Ranking(1,2); %selected crowding distance for selected rank 
Peer_CD=Population(Peer,Dim+Objectives+2); %selected crowding distance for peer  

    if Selected_Rank<Peer_Rank 
    PopulationNew(i,:)=Population(i,1:Dim)+(rand(1,Dim).*(Population(i,1:Dim)-Population(Peer,1:Dim))); %updated population 
    elseif Selected_Rank==Peer_Rank && Selected_CD>Peer_CD %for non dominated solutions ,better CD (less crowded region) has better rank 
            PopulationNew(i,:)=Population(i,1:Dim)+(rand(1,Dim).*(Population(i,1:Dim)-Population(Peer,1:Dim))); %updated population 
    else
    PopulationNew(i,:)=Population(i,1:Dim)+(rand(1,Dim).*(Population(Peer,1:Dim)-Population(i,1:Dim))); %updated population 
    end
end
%PopulationNew(:,1:Dim)=Corner_Bounding(LB,UB,PopulationNew(:,1:Dim)); %corner bounding strategy applied to the updated population 
%PopulationNew(:,Dim+1:Dim+Objectives)=Objective_Function(PopulationNew(:,1:Dim),Dim); %evaluating new fitness for updated population 
dd=PopulationNew;
%% Adaptive Mutation
    for i = 1:PopulationSize
        if rand < mutationRate
            mutationVector = mutationStep * randn(1, Dim);
            PopulationNew(i, :) = PopulationNew(i, :) + mutationVector;
        end
    end
ee= PopulationNew;
PopulationNew(:,1:Dim)=Corner_Bounding(LB,UB,PopulationNew(:,1:Dim)); 
for i=1:PopulationSize 
    %fff(i,1:Objectives) = fit_function(PopulationNew(i,:));
    fff(i,1:Objectives) = fitfunction(PopulationNew(i,:));
end
PopulationNew=[PopulationNew fff];
PopulationNew=PopulationNew(:,1:Dim+Objectives); %stored new population
Combined_Pop=cat(1,Population(:,1:Dim+Objectives) ,PopulationNew(:,1:Dim+Objectives)); %combined population of teacher and learner phrase
Population=NonDominatedSorting(Objectives,Dim,Combined_Pop); %non dominated solutions
Population=Population(1:PopulationSize,:); %fitted solutions for next generation
Combined_Pop=[];
PopulationNew=[];
iter=iter+1; 
disp(iter);

%%Results
ParetoFront=[Population(:,Dim+1) Population(:,Dim+2) Population(:,Dim+3)]; %unsorted pareto fronts
[ParetoFrontSorted,inx]=sortrows(ParetoFront); %sorted pareto fronts and their locations
NonDominatedSol=Population(:,1:Dim); %unsorted non dominated solutions
SortedNonDominatedSolutions=NonDominatedSol(inx,:); %sorted non dominated solutions
FinalOutput=[SortedNonDominatedSolutions ParetoFrontSorted]; %final output

%% Plotting
%plot(Population(:,Dim+1),Population(:,Dim+2),'ro','MarkerSize',10,'LineWidth',2);
%grid on
%xlabel('Objective 1');
%ylabel('Objective 2');
%figure(1);
j=8;
%TrueParetoFront=load('P8.TXT');
%plot(TrueParetoFront(:,1),TrueParetoFront(:,2),'Color','g','LineWidth',4);
            %hold on
            plot(Population(:,Dim+1),Population(:,Dim+2),'ro','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','r',...
                'Marker','o',...
                'MarkerSize',10);
            legend('Obtained PF');
            %legend('True PF','Obtained PF');
            title(sprintf('NSTLBO FOR P%d PROBLEM',j));
            xlabel('obj_1');
            ylabel('obj_2');
            hold off

%TrueParetoFront=load('ZDT3.TXT');
%line(TrueParetoFront(:,1),TrueParetoFront(:,2),'Color','Black','LineStyle','-','LineWidth',2)
%title('ZDT3')
%xlabel('Objective 1')
%ylabel('Objective 2')
%box on
%fig=gcf;
%set(findall(fig,'-property','FontName'),'FontName','Garamond')
%set(findall(fig,'-property','FontAngle'),'FontAngle','italic')

%TrueParetoFront=load('P8.TXT');
%line(TrueParetoFront(:,1),TrueParetoFront(:,2),'Color','Blue','LineStyle','-','LineWidth',5)
%title('NSTLBO')
%xlabel('Objective 1')
%ylabel('Objective 2')
%box on
%fig=gcf;
%set(findall(fig,'-property','FontName'),'FontName','Garamond')
%set(findall(fig,'-property','FontAngle'),'FontAngle','italic')

disp(Generation);
Generation=Generation+1;

end
Population=[];
run=run+1;
end

%%Gratitude: Thanks Dr. Pradeep Jahangir for the beautiful non-dominated sorting code