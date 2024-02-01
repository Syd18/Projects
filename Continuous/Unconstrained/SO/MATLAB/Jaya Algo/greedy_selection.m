function[population,fitness]=greedy_selection(population,fitness,updated_population,updated_fitness)
[row,~]=size(updated_population);
for i=1:row
    if(updated_fitness(i)<fitness(i))
        population(i,:)=updated_population(i,:);
        fitness(i)=updated_fitness(i);
    end
end