
GPL : TestProg Alg* [Src] HiddenWgt Wgt HiddenGtp Gtp Implementation Base :: MainGpl ;

Alg | Number
	| Connected
	| Strong
	| Cycle
	| MSTPrim
	| MSTKruskal ;

Strong : Transpose StronglyConnected :: _Strong ;

Src | BFS
    | DFS ;

HiddenWgt : [WeightedWithEdges] [WeightedWithNeighbors] [WeightedOnlyVertices] :: WeightOptions ;

Wgt | Weighted
    | Unweighted ;

HiddenGtp | DirectedWithEdges
	| DirectedWithNeighbors
	| DirectedOnlyVertices
	| UndirectedWithEdges
	| UndirectedWithNeighbors
	| UndirectedOnlyVertices ;

Gtp | Directed
	| Undirected ;

Implementation | OnlyVertices
	| WithNeighbors
	| WithEdges ;

Number implies Gtp and Src
