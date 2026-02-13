enum PlantCategory {
  ornamental(1, 'Ornamental'),
  frutal(2, 'Frutal'),
  medicinal(3, 'Medicinal'),
  other(4, 'Otros');

  final int id;
  final String name;

  const PlantCategory(this.id, this.name);

  static PlantCategory fromId(int id) {
    return PlantCategory.values.firstWhere(
      (e) => e.id == id,
      orElse: () => PlantCategory.other,
    );
  }
}
