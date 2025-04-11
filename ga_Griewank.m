clc;
close all;
clear;
%% Setup Parameter
% metaheuristic parameter
MaxIt=500;
nPop=5000;
dim=20;

VarMin=-100;
VarMax=100;
BestCost=zeros(1,MaxIt);

% algorithm parameter
crossover_rate=0.7;
mutation_rate=0.3;

%% Initialization of the first population
empty_individual.Position=[]; % Empty solution
empty_individual.Cost=[];     % Empty cost function of that solution
BestSol.Position=[];	% Best Solution
BestSol.Cost=inf;	% Best solution function value
pop=repmat(empty_individual,nPop,1); % pop includes nPop solutions

for i=1:nPop
    pop(i).Position = unifrnd(VarMin,VarMax,[1 dim]);
    pop(i).Cost = fitness_function(pop(i).Position);

    if pop(i).Cost < BestSol.Cost
        BestSol.Cost=pop(i).Cost;
        BestSol.Position=pop(i).Position;
    end
end
clear empty_individual i;

%% Main iteration
for it =1:MaxIt
    for i=1:nPop
        k=randi([1,nPop]);
        %% crossover phase
        alpop=crossover_rate*pop(i).Position+(1-crossover_rate)*pop(k).Position;
        %% mutation phase
        for j=1:dim
            if rand< mutation_rate
                alpop(j)=pop(k).Position(j);
            end
        end
        %% Selection
        alcost= fitness_function(alpop);
        if alcost < pop(i).Cost
            pop(i).Position=alpop;
            pop(i).Cost=alcost;
        end
    end
    %% Update BestSol
    for i=1:nPop
        if pop(i).Cost < BestSol.Cost
            BestSol.Cost=pop(i).Cost;
            BestSol.Position=pop(i).Position;
        end 
    end
    clear alcost alpop i j k;
    BestCost(it)=BestSol.Cost;
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
end
plot(BestCost,'LineWidth',2);