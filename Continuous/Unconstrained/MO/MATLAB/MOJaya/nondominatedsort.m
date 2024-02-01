function [z1]= nondominatedsort(m,variables,population,sch)
[pop,col]=size(population);
x=population(:,1:variables)
func=population(:,variables+1:variables+m);
f=func;
srn=[1:pop];
tempf=f;
[p,c]=size(f);
l=1;
rank=1;
score=[];
tscore=zeros(1,2);
nd=[];
todel=[];
index=[];
t=[];
V=variables;
M=m;
[N,~] = size(population);
front = 1;
F(front).f = [];
individual = [];
for i = 1 : N
% Number of individuals that dominate this individual
individual(i).n = 0;
% Individuals which this individual dominate
individual(i).pk = [];
for j = 1 : N
dom_less = 0;
dom_equal = 0;
dom_more = 0;
for k = 1 : M
if (population(i,V + k) < population(j,V + k))
dom_less = dom_less + 1;
elseif (population(i,V + k) == population(j,V + k))
dom_equal = dom_equal + 1;
else
dom_more = dom_more + 1;
end
end
if dom_less == 0 & dom_equal ~= M
individual(i).n = individual(i).n + 1;
elseif dom_more == 0 & dom_equal ~= M
individual(i).pk = [individual(i).pk j];
end
end
if individual(i).n == 0
population(i,M + V + 1) = 1;
F(front).f = [F(front).f i];
end
end
% Find the subsequent fronts
while ~isempty(F(front).f)
Q = [];
for i = 1 : length(F(front).f)
if ~isempty(individual(F(front).f(i)).pk)
for j = 1 : length(individual(F(front).f(i)).pk)
individual(individual(F(front).f(i)).pk(j)).n = ...
individual(individual(F(front).f(i)).pk(j)).n - 1;
if individual(individual(F(front).f(i)).pk(j)).n == 0
population(individual(F(front).f(i)).pk(j),M + V + 1) = ...
front + 1;
Q = [Q individual(F(front).f(i)).pk(j)];
end
end
end
end
front = front + 1;
F(front).f = Q;
end
[temp,index_of_fronts] = sort(population(:,M + V + 1));
for i = 1 : length(index_of_fronts)
sorted_based_on_front(i,:) = population(index_of_fronts(i),:);
end
x=sorted_based_on_front;
[k,I,J] = unique(x, 'rows', 'first');
hasDuplicates = size(k,1) < size(x,1);
ixDupRows = setdiff(1:size(x,1), I);
dupRowValues = x(ixDupRows,:);
[x1,indo]=sort(k(:,end));
x=k(indo,:);
%disp(x);
for i=1:m
fmin(i)=min(x(:,variables+i));
fmax(i)=max(x(:,variables+i));
end
r=max(x(:,variables+m+1));
%disp(r);
for k=1:r
t=[];
index=[];
f2=x(x(:,variables+m+1)==k,variables+1:variables+m);
[row,col]=size(f2);
if(row<2)
x(x(:,variables+m+1)==k,variables+m+2)=Inf;
else
x(x(:,variables+m+1)==k,variables+m+2)=crowdingdistance(fmin,fmax,f2);
x1=x(x(:,variables+m+1)==k,:);
[t,index]=sort(x1(:,variables+m+2),'descend');
x1=x1(index,:);
x(x(:,variables+m+1)==k,:)=x1;
end
end
z1=x;
end