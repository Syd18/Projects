function [z2]=update_population(population,count)
[row,col]=size(population);
best=population(round(count-(count-1)*rand(1,1)),:);
worst=population(end,:);
for j=1:row
for i=1:col
rn=rand(1,2);
population(j,i)=population(j,i)+rn(1)*(best(i)-abs(population(j,i)))-rn(2)*(worst(i)-abs(population(j,i)));
end
end
z2=population;
end



