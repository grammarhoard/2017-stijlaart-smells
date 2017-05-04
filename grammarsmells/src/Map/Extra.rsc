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

map[&K, list[&V]] addItemToValueList(map[&K, list[&V]] index, &K k, &V v) {
	if(k in index) {
		list[&V] old = index[k];
		index[k] = old + v;
	} else {
		index[k] = [v];
	}
	return index;
}

map[&K, &V] merge(map[&K, &V] a, map[&K, &V] b, &V(&V,&V) add ) {
	for (k <- b) {
		if (a[k]?) {
			a[k] = add(a[k], b[k]);
		} else {
			a[k] = b[k];
		}
	}
	return a;
}


map[&T,int] incK(map[&T,int] m, &T k, int by) {
	m[k] = m[k] + by;
	return m;
}