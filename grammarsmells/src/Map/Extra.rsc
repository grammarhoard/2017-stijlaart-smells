module Map::Extra


map[&K, set[&V]] addItemToValueSet(map[&K, set[&V]] index, &K k, &V v) {
	if(k in index) {
		set[&V] old = index[k];
		index[k] = old + v;
	} else {
		index[k] = {v};
	}
	return index;
}
