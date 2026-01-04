function [f]=Objective_Function(x,dim)
[row,~]=size(x);
for i=1:row
%ZDT3    
f1 = x(i); %first objective function
x1=x(i,2:dim);
g=1+(9*sum(x1,2)/(dim-1));             
f2 = (1-(sqrt(x(i)/g)) - ((x(i)/g)*sin(10*pi*x(i)))); %second objective function
f(i,1)=f1; %1 st objective function vector
f(i,2)=f2;  %2 nd objective function vector




%%ZDT1
%f1 = x(i);
%x1=x(i,2:dim);
%g=1+(9*sum(x1,2)/(dim-1)); 
%f2 = g*(1-sqrt(x(i)/g));
%f(i,1)=f1; %1 st objective function vector
%f(i,2)=f2;  %2 nd objective function vector
end
end
