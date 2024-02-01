function [f]=fitness_function(population)
[row,column]=size(population);
for i=1:row
sum=0;
for j=1:column-1
sum=sum+(100*(population(i,j+1)-population(i,j)^2)^2+(1-population(i,j))^2);
end
z(i)=sum;
end
f=z';
end