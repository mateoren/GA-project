-- method for obtaining a slice of a list 

List_Sequence := (x,y) -> apply(toList y, i -> x#i);


isThisEntryGood = (I,E) -> (
    
    
  
    newE := append(E,I);
    
    nEparameters := for i to #newE-1 list product for j to d-1 list s_{j+1,newE#i#j};
    
    newRank := rank substitute(jacobian ideal nEparameters ,substituteList);

    newRank == originalRank
    
    )


isThisSubsetGood = E -> (
    
    -- for a subset of entries, yields true if it completes the tensor
    -- also stores the entries completable from E
    
    Eparameters = for i to #E-1 list product for j to d-1 list s_{j+1,E#i#j};
    
    originalRank = rank substitute(jacobian ideal Eparameters, substituteList);
    
    completableEntries = select(for I in last \ baseName \ gens R list (I, isThisEntryGood(I,E)),p -> p#1);
    
    (if #completableEntries == #indexedEntries then 0
    else if #completableEntries < #indexedEntries then 1);
    
    
    )


printSlicesOriginal = specifiedEntries-> (
    
    
    for i from 1 to lastIndices#2 do M_(i)=mutableMatrix(ZZ,lastIndices#0,lastIndices#1);
    
    for i to #specifiedEntries-1 do M_(specifiedEntries#i#2)_(specifiedEntries#i#0-1,specifiedEntries#i#1-1)=1; -- -1 to the index, starts at 0.
    
    for i from 1 to lastIndices#2 do << M_(i); -- << M_(i) prints the matrix.
    
    )    

printSlicesCompletion = completableEntries-> (
    
    -- The input is a list of sequences where each sequence is of the form: ({1,2,1},true) ----- does this need to be changed?

    for i from 1 to lastIndices#2 do M_(i)=mutableMatrix(ZZ,lastIndices#0,lastIndices#1);
    
    for i to #completableEntries-1 do M_(completableEntries#i#0#2)_(completableEntries#i#0#0-1,completableEntries#i#0#1-1)=1;
    
    for i from 1 to lastIndices#2 do << M_(i);
    
    << " - - ";
    
    )



-- GA functions


fitAndRelFit = pop -> (
    
    --may as well output the fitness list and relative fitness list
    -- ahh un gran problema... tengo que maximizar el fitness ... no minimizar.
    -- inventar una cota superior y multiplicar el factor de abajo por un escalar que diferencia mas 
    -- el fitness de cromosomas diferentes.
    
    
    fit := for i to popSize-1 list sum(pop#i) + isThisSubsetGood(pop#i)*#indexedEntries;
    fitSum := sum(fit);
    relFit := for i to popSize-1 list numeric(fit#i/fitSum);
    
    
    
    )


crossover = (s1, s2) -> (
    
    k := random(1,10);
    xsite := random(0,strSize);
    (if k <= xProb*10 then child1 := join(s1_(0..xsite-1), s2_(xsite..strSize-1)), child2:= join(s2_(0..xsite-1), s1_(xsite..strSize-1)) 
    else child1 := s1, child2 := s2);

    child1, child2;
    
    )


mutation = s1 -> (
    
    k := random(1,100);
    v := new MutableList from s1;
    if k<= mutProb*100 then r = random(0, strSize-1), v#r = 1 - v#r;
    
    toList v;
    
    
    )


strToSubset = s -> (
    
    for i to strSize-1 list (if s#i == 0 then continue; {i%((tSize#0)*(tSize#1))//tSize#1 + 1,i%((tSize#0)*(tSize#1))%tSize#1 + 1 ,i//((tSize#0)*(tSize#1)) + 1})
    
    )


roulette = pop -> (
    
    -- output a list of pairs of the elements that are going to mate.
    
    random(0.,1.)
    prob := 0
    roultt := for i to popSize-1 list prob = prob + relFit#i;
    
    mating = {};
    
    for i to popSize-1 do for 
    
    
    
    )




restart



tSize = (2,2,2);

d = #tSize;
   

firstIndices = {1,1,1};
    
lastIndices = for i to d-1 list tSize#i;

-- all entries
indexedEntries = toList (firstIndices..lastIndices);
    
-- indexed variables
listOfParameters = flatten for i from 1 to d list for j from 1 to lastIndices#(i-1) list s_{i,j};

-- polynomial rings
R=QQ[p_firstIndices..p_lastIndices];
S=QQ[listOfParameters];
    
    
-- give random values to the parameters
substituteList = for i to #listOfParameters-1 list (flatten entries vars S)_i => random(1,100); 




----------------------------------------------------------------------------------------------------
-- GA




strSize = #indexedEntries;

popSize = 30;

generations  = {};




-- 

xProb = 0.6;

mutProb = 0.05;

startPop = for i to popSize-1 list for i to strSize-1 list random(0,1);


