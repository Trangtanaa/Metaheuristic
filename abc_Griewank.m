clc;
close all;
clear;
%% Setup Parameter
% metaheuristic parameter
MaxIt=5000;
nPop=100;
dim=60;

VarMin=-100;
VarMax=100;
BestCost=zeros(1,MaxIt);

% algorithm parameter
Scout_bee=nPop;
Onlooker_bee=nPop;
a=1;
L=zeros(1,nPop);
Lmax=MaxIt/2;

%% Initialization of the first population
empty_individual.Position=[]; % Empty solution
empty_individual.Cost=[];     % Empty cost function of that solution
BestSol.Position=[];	% Best Solution
BestSol.Cost=inf;	% Best solution function value
pop=repmat(empty_individual,nPop,1); % pop includes nPop solutions

for i=1:nPop
    pop(i).Position = unifrnd(VarMin,VarMax,[1 dim]);
    pop(i).Cost = fitness_function(pop(i).Position,0);

    if pop(i).Cost < BestSol.Cost
        BestSol.Cost=pop(i).Cost;
        BestSol.Position=pop(i).Position;
    end
end
clear empty_individual i;

%% Main iteration
for it =1:MaxIt
    %% Employed Bees
    for i=1:nPop
        k=randi([1,nPop]);
        phi=a*unifrnd(-1, +1, [1 dim]);
        alpop=pop(i).Position+phi.*(pop(i).Position-pop(k).Position);
        alpop=min(VarMax,max(alpop,VarMin));
        % Selection
        alcost= fitness_function(alpop,0);

        if alcost < pop(i).Cost
            pop(i).Position=alpop;
            pop(i).Cost=alcost;
        else
            L(i)=L(i)+1;
        end
    end

    %% Selection
    E=zeros(1,nPop);
    for i=1:nPop
        E(i)=pop(i).Cost;
    end
    E_ave=E/sum(E);

    %% Onlooker Bees
    for j=1:nPop
        %i=randsrc(1,1,[1:nPop;E_ave]);
        i=randi([1,nPop]);
        k=randi([1,nPop]);
        phi=a*unifrnd(-1, +1, [1 dim]);
        alpop=pop(i).Position+phi.*(pop(i).Position-pop(k).Position);
        alpop=min(VarMax,max(alpop,VarMin));
        % Selection
        alcost= fitness_function(alpop,0);
        if alcost < pop(i).Cost
            pop(i).Position=alpop;
            pop(i).Cost=alcost;
        else
            L(i)=L(i)+1;
        end
    end

    %% Scout Bees
    for i=1:nPop
        if L(i)>Lmax
            alpop=unifrnd(VarMin,VarMax,[1 dim]);
            % Selection
            alcost= fitness_function(alpop,0);
            if alcost < pop(i).Cost
                pop(i).Position=alpop;
                pop(i).Cost=alcost;
            else
                L(i)=L(i)+1;
            end
        end
    end
    %% Update BestSol
    for i=1:nPop
        if pop(i).Cost < BestSol.Cost
            BestSol.Cost=pop(i).Cost;
            BestSol.Position=pop(i).Position;
        end 
    end
    BestCost(it)=BestSol.Cost;
    clear alcost alpop i j k;
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
end
plot(BestCost,'LineWidth',2);
