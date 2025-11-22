_: final: prev: {
  gci = prev.gci.override {
    buildGoModule = final.buildGo124Module;
  };
}
