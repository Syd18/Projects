function [H]= NonDominatedSorting(Objectives,Dim,Pop_Obj_Matrix)
V=Dim;
M=Objectives;
[N,~] = size(Pop_Obj_Matrix);
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
            if (Pop_Obj_Matrix(i,V + k) < Pop_Obj_Matrix(j,V + k))
                dom_less = dom_less + 1;
            elseif (Pop_Obj_Matrix(i,V + k) == Pop_Obj_Matrix(j,V + k))
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
        Pop_Obj_Matrix(i,M + V + 1) = 1;
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
               		Pop_Obj_Matrix(individual(F(front).f(i)).pk(j),M + V + 1) = ...
                        front + 1;
                    Q = [Q individual(F(front).f(i)).pk(j)];
                end
            end
       end
   end
   front =  front + 1;
   F(front).f = Q;
end
[~,index_of_fronts] = sort( Pop_Obj_Matrix(:,M + V + 1));
for i = 1 : length(index_of_fronts)
    sorted_based_on_front(i,:) =  Pop_Obj_Matrix(index_of_fronts(i),:);
end
x=sorted_based_on_front;

%%Duplicate Removal
[k,~] = unique(x, 'rows', 'first'); 
hasDuplicates = size(k,1) < size(x,1); %finding duplicate solution
if hasDuplicates==1
[~,indo]=sort(k(:,end));
x=k(indo,:); %remove duplicate solutions
end


for i=1:M
fmin(i)=min(x(:,Dim+i));
fmax(i)=max(x(:,Dim+i));
end
r=max(x(:,Dim+M+1));

for k=1:r
f2=x(x(:,Dim+M+1)==k,Dim+1:Dim+M);
[row,~]=size(f2);
if(row<2)
x(x(:,Dim+M+1)==k,Dim+M+2)=Inf;
else
x(x(:,Dim+M+1)==k,Dim+M+2)=CrowdingDistance(fmin,fmax,f2);
x1=x(x(:,Dim+M+1)==k,:);
[~,index]=sort(x1(:,Dim+M+2),'descend');
x1=x1(index,:);
x(x(:,Dim+M+1)==k,:)=x1;
end
end
H=x; 
end

