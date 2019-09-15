self: super: {
  jupyterWithBatteries = super.jupyter-kernel.create {
    definitions = super.python3.withPackages (py-pkgs: with py-pkgs; [
      ipykernel
      numpy
      scipy
      tensorflow
      pandas
      matplotlib
    ]);
  };
}
