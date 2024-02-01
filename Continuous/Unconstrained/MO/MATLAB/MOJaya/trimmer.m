function[z4]=trimmer(lower_bound,upper_bound,temp_population)
[~,col]=size(temp_population);
for i=1:col
temp_population(temp_population(:,i)<lower_bound(i),i)=lower_bound(i);
temp_population(temp_population(:,i)>upper_bound(i),i)=upper_bound(i);
end
z4=temp_population;
end