double percentChangeBetween(double first, double second) =>
    ((second - first) / first == 0 ? 1 : first) * 100;
