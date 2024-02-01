function[z]=trimmer(lower_bound,upper_bound,population)
[row,col]=size(population);
for i=1:col
population(population(:,i)<lower_bound(i),i)=lower_bound(i);
population(population(:,i)>upper_bound(i),i)=upper_bound(i);
end
z=population;
end