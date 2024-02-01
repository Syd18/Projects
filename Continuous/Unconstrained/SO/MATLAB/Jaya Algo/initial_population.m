function [population]=initial_population(lower_bound,upper_bound,population_size,variables)
population=zeros(population_size,variables);

%Initial Population
for i=1:variables
population(:,i)=lower_bound(i)+(upper_bound(i)-lower_bound(i))*rand(population_size,1);
end
end