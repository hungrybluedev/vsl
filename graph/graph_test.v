module graph

fn test_graph01() {
	/*
	*           [10]
	 *      0 ––––––––→ 3      numbers in parentheses
	 *      |    (1)    ↑      indicate edge ids
	 *   [5]|(0)        |
	 *      |        (3)|[1]
	 *      ↓    (2)    |      numbers in brackets
	 *      1 ––––––––→ 2      indicate weights
	 *           [3]
	*/
	g := new_graph([[0, 1], [0, 3], [1, 2],
		[2, 3],
	], [f64(5), 10, 3, 1], [], [])
	assert g.shares.keys().len == 4 // nverts
	assert g.key2edge.keys().len == 4 // nedges
	assert g.dist.len == 4 // nverts
	assert g.next.len == 4 // nverts
	shares := [[0, 1], [0, 2], [2, 3],
		[1, 3],
	]
	for k, share in shares {
		for i, s in g.shares[k] {
			assert s == shares[k][i]
		}
	}
	assert g.key2edge[hash_edge_key(0, 1)] == 0 // (0,1) → edge 0
	assert g.key2edge[hash_edge_key(0, 3)] == 1 // (0,3) → edge 1
	assert g.key2edge[hash_edge_key(1, 2)] == 2 // (1,2) → edge 2
	assert g.key2edge[hash_edge_key(2, 3)] == 3 // (2,3) → edge 3
	edg0 := g.get_edge(0, 1) or { panic(err) }
	assert edg0 == 0
	edg1 := g.get_edge(0, 3) or { panic(err) }
	assert edg1 == 1
	edg2 := g.get_edge(1, 2) or { panic(err) }
	assert edg2 == 2
	edg3 := g.get_edge(2, 3) or { panic(err) }
	assert edg3 == 3
	g2 := g.shortest_paths(.fw)
	mut pth := g2.path(0, 3)
	for i, v in [0, 1, 2, 3] {
		assert pth[i] == v
	}
	mut weights_e := g2.weights_e
	weights_e[3] = 13
	g3 := {
		g2 |
		weights_e: weights_e
	}
	g4 := g3.shortest_paths(.fw)
	pth = g4.path(0, 3)
	for i, v in [0, 3] {
		assert pth[i] == v
	}
}

fn test_graph02() {
	/*
	*             [3]
	 *      4 –––––––––––→ 5 .  [4]      numbers in parentheses
	 *      ↑      (0)     |  `.         indicate edge ids
	 *      |           (4)| (6)`.v
	 *      |              |       3
	 *  [11]|(1)        [7]|  (5),^      numbers in brackets
	 *      |              |   ,' [9]    indicate weights
	 *      |   (2)    (3) ↓ ,'
	 *      1 ←–––– 0 ––––→ 2
	 *          [6]    [8]
	*/
	g := new_graph([[4, 5], [1, 4], [0, 1],
		[0, 2], [5, 2], [2, 3], [5, 3]], [f64(3), 11, 6, 8, 7, 9, 4], [], [])
	assert g.shares.keys().len == 6 // nverts
	assert g.key2edge.keys().len == 7 // nedges
	assert g.dist.len == 6 // nverts
	assert g.next.len == 6 // nverts
	shares := [[2, 3], [1, 2], [3, 4, 5],
		[5, 6], [0, 1], [0, 4, 6]]
	for k, share in shares {
		for i, s in g.shares[k] {
			assert s == shares[k][i]
		}
	}
	assert g.key2edge[hash_edge_key(4, 5)] == 0 // (4,5) → edge 0
	assert g.key2edge[hash_edge_key(1, 4)] == 1 // (1,4) → edge 1
	assert g.key2edge[hash_edge_key(0, 1)] == 2 // (0,1) → edge 2
	assert g.key2edge[hash_edge_key(0, 2)] == 3 // (0,2) → edge 3
	assert g.key2edge[hash_edge_key(5, 2)] == 4 // (5,2) → edge 4
	assert g.key2edge[hash_edge_key(2, 3)] == 5 // (2,3) → edge 5
	assert g.key2edge[hash_edge_key(5, 3)] == 6 // (5,3) → edge 6
	g2 := g.shortest_paths(.fw)
	pth := g2.path(1, 3)
	for i, v in [1, 4, 5, 3] {
		assert pth[i] == v
	}
}
