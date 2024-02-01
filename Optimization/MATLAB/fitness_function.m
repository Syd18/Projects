function [f]=fitness_function(x)
[r,c]=size(x);
Z=zeros(r,1);
for i=1:r
x1=x(i,1);
x2=x(i,2);
z=(((x1^2)+x2-11)^2)+((x1+x2^2-7)^2);
g1=26-((x1-5)^2)-((x2)^2);
g2=20-(4*x1)-x2;
p1=10*((min(0,g1))^2); % penalty if constraint 1 is violated
p2=10*((min(0,g2))^2); % penalty if constraint 2 is violated
Z(i)=z+p1+p2; % penalized objective function value
end
f=Z;
end