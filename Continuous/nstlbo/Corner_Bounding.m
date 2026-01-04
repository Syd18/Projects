function[z]=Corner_Bounding(LB,UB,Population_New)
[~,col]=size(Population_New);
for i=1:col
Population_New(Population_New(:,i)<LB(i),i)=LB(i); %avoiding lower bound
Population_New(Population_New(:,i)>UB(i),i)=UB(i); %avoiding upper bound
end
z=Population_New; 
end