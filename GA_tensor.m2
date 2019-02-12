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
    
    (if #completableEntries == #indexedEntries then k := 1
    else if #completableEntries < #indexedEntries then k = 0);

    k
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

------------------------------
-- Genetic Algorithm Functions

fitness = pop -> (
    
    -- Inputs: pop, indexedEntries, popSize, 

    fit = for i to popSize-1 list 1./(sum(pop#i) + (1 - isThisSubsetGood(strToSubset(pop#i)))*#indexedEntries);
    fitSum := sum(fit);
    rFit = for i to popSize-1 list numeric(fit#i/fitSum);
    
    --output
    --fit, rFit
    
    )

crossover = (s1, s2) -> (
    
    -- Inputs: s1, s2, xProb, strSize
    
    k := random(1,100);
    xsite := random(0,strSize);
    (if k <= xProb*100 then (child1 := join(s1_(0..xsite-1), s2_(xsite..strSize-1)), child2:= join(s2_(0..xsite-1), s1_(xsite..strSize-1))) 
    else (child1 = s1, child2 = s2));
    
    --output
    (child1, child2)
    
    )

mutation = s1 -> (
    
    -- Inputs: s1, mutProb, strSize
    
    k := random(1,100);
    v := new MutableList from s1;
    if k <= mutProb*100 then (r = random(0, strSize-1), v#r = 1 - v#r);
    
    --output
    toList v
    
    )

strToSubset = s -> (
    
    -- Inputs: strSize, tSize, s
    
    --Output
    for i to strSize-1 list (if s#i == 0 then continue; {i%((tSize#0)*(tSize#1))//tSize#1 + 1,i%((tSize#0)*(tSize#1))%tSize#1 + 1 ,i//((tSize#0)*(tSize#1)) + 1})
    
    )

roulette = pop -> (
    
    -- Inputs: pop, popSize, rFit, 
    
    prob := 0;
    roultt := for i to popSize-1 list prob = prob + rFit#i;
    roultt = prepend(0,roultt);
    rValues := for i to popSize-1 list random(0.,1.);
    mating = new MutableList from {}; 
    
    for i to popSize-1 do (for j to popSize-1 do (if roultt#(j) <= rValues#i and rValues#i < roultt#(j+1) then mating = append(mating,pop#j)));
    
    parents = {};
    t := 0; while t < popSize-1 do (parents = append(parents, (mating#t, mating#(t+1))); t = t + 2);
    
    -- Output
    parents 
 
    )
    
------------------------------
-- End of function definitions
------------------------------

restart

tSize = (5,5,3);
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

--------------------
-- Genetic Algorithm
--------------------

strSize = #indexedEntries;
popSize = 20;
generations = {};
maxGen = 200;
xProb = 0.7;
mutProb = 0.07;
currPop = for i to popSize-1 list for i to strSize-1 list random(0,1);
generations = append(generations, currPop);
genCounter = 0;

-- Tengo que ser super cuidadoso con los inputs de las funciones
-- Otra cosa es que las funciones no todas tienen que dar un output especifico... solo es necesario que hagan algo.

while genCounter < maxGen-1 do (
    
    --generations = append(generations, currPop);
    
    -- Computes the fitness and relative fitness of the current pop and defines both lists
    fitness(currPop);
    
    -- Form mating pool
    parents = roulette(currPop);
    
    -- Forms new population
    newPop = {};
    for i to length(parents)-1 do (
	
	(child1, child2) = crossover(parents#i#0, parents#i#1),
	mutChild1 := mutation(child1),
	mutChild2 := mutation(child2),
	newPop = append(newPop, mutChild1),
	newPop = append(newPop, mutChild2)
	
        );
    
    currPop = newPop;
    generations = append(generations, currPop);
    genCounter = genCounter + 1;
    
    )
