function [updated_population]=update_population(population,fitness)
[row,col]=size(population);
[~,minindex]=min(fitness); %Best fitness index
Best=population(minindex,:); %Best solution
[~,maxindex]=max(fitness); %Worst fitness index
worst=population(maxindex,:); %Worst solution
updated_population=zeros(row,col); 
for i=1:row
for j=1:col
r=rand(1,2);
updated_population(i,j)=population(i,j)+r(1)*(Best(j)-abs(population(i,j)))-r(2)*(worst(j)-abs(population(i,j)));
end
end
end