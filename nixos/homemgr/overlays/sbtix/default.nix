self: super: {
  sbtix = super.callPackage (super.fetchFromGitLab {
    owner = "teozkr";
    repo = "Sbtix";
    rev = "df76eeb2312f5873caef69f1f193a56da99a6334";
    sha256 = "1jxv168kyyp4mxrwilr21pkicd09v7pd3lj5v1lq217gr8c61arr";
  }) {};
}
