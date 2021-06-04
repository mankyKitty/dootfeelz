{ extensions = [
  {
    name = "project-manager";
    publisher = "alefragnani";
    version = "12.1.0";
    sha256 = "1zrgjz1nh0r70xfbcki8bwi76gsydfjpdij7axv9i97xd6clm03x";
  }
  {
    name = "vscode-tlaplus";
    publisher = "alygin";
    version = "1.5.4";
    sha256 = "0mf98244z6wzb0vj6qdm3idgr2sr5086x7ss2khaxlrziif395dx";
  }
  {
    name = "nix-env-selector";
    publisher = "arrterian";
    version = "1.0.7";
    sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
  }
  {
    name = "Nix";
    publisher = "bbenoist";
    version = "1.0.1";
    sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
  }
  {
    name = "bracket-pair-colorizer";
    publisher = "CoenraadS";
    version = "1.0.61";
    sha256 = "0r3bfp8kvhf9zpbiil7acx7zain26grk133f0r0syxqgml12i652";
  }
  {
    name = "crystal-lang";
    publisher = "faustinoaq";
    version = "0.4.3";
    sha256 = "0hcfy8wp4jif4r55v17zc816mhnz8bgldiiwp6k9mkgr8k6z482c";
  }
  {
    name = "reasonml";
    publisher = "freebroccolo";
    version = "1.0.38";
    sha256 = "1nay6qs9vcxd85ra4bv93gg3aqg3r2wmcnqmcsy9n8pg1ds1vngd";
  }
  {
    name = "gleam";
    publisher = "gleam";
    version = "1.3.0";
    sha256 = "1vd6lg5ap7fja75170wyzb1z72vnc9nxd88l8ad4r63qaqsfzw63";
  }
  {
    name = "go";
    publisher = "golang";
    version = "0.25.1";
    sha256 = "0v0qxa9w2r50h5iivzyzlbznb8b9a30p1wbfxmxp83kkv4vicdb4";
  }
  {
    name = "haskell";
    publisher = "haskell";
    version = "1.4.0";
    sha256 = "1jk702fd0b0aqfryixpiy6sc8njzd1brd0lbkdhcifp0qlbdwki0";
  }
  {
    name = "language-haskell";
    publisher = "justusadam";
    version = "3.4.0";
    sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
  }
  {
    name = "magit";
    publisher = "kahole";
    version = "0.6.13";
    sha256 = "0n8g201rikdfm7czrckc2czrzwvkqm2rj06pxdja04hlbm0qc9zx";
  }
  {
    name = "brittany";
    publisher = "MaxGabriel";
    version = "0.0.9";
    sha256 = "1cfbzc8fmvfsxyfwr11vnszvirl47zzjbjp6rihg5518gf5wd36k";
  }
  {
    name = "theme-monokai-pro-vscode";
    publisher = "monokai";
    version = "1.1.19";
    sha256 = "0skzydg68bkwwwfnn2cwybpmv82wmfkbv66f54vl51a0hifv3845";
  }
  {
    name = "cmake-tools";
    publisher = "ms-vscode";
    version = "1.7.3";
    sha256 = "0jisjyk5n5y59f1lbpbg8kmjdpnp1q2bmhzbc1skq7fa8hj54hp9";
  }
  {
    name = "nimvscode";
    publisher = "nimsaem";
    version = "0.1.21";
    sha256 = "09d2x334dy5i74q4fpxas3pd8nwnamc5zca554aa895cff9f3myp";
  }
  {
    name = "nunjucks";
    publisher = "ronnidc";
    version = "0.3.0";
    sha256 = "1xdh3d6azj9al6dcmz0jmivixlz4a3qxcm09x17c0w0f6issmbdf";
  }
  {
    name = "rust";
    publisher = "rust-lang";
    version = "0.7.8";
    sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
  }
  {
    name = "fish-vscode";
    publisher = "skyapps";
    version = "0.2.1";
    sha256 = "0y1ivymn81ranmir25zk83kdjpjwcqpnc9r3jwfykjd9x0jib2hl";
  }
  {
    name = "vim";
    publisher = "vscodevim";
    version = "1.20.3";
    sha256 = "0za138wvp60dhz9abb0j4ida8jk7mzzpj8wga9ihc1cfxp8ad8an";
  }
  {
    name = "clang-format";
    publisher = "xaver";
    version = "1.9.0";
    sha256 = "0bwc4lpcjq1x73kwd6kxr674v3rb0d2cjj65g3r69y7gfs8yzl5b";
  }
];
}
######## Old extension config
    # vscodeExtensions = with pkgs-unstable.vscode-extensions; [
    #   bbenoist.Nix
    #   ms-vscode.Go
    #   ms-vscode.cpptools
    #   justusadam.language-haskell
    #   skyapps.fish-vscode
    #   vscodevim.vim
    # ] ++ pkgs-unstable.vscode-utils.extensionsFromVscodeMarketplace [
    #   {
    #     name = "project-manager";
    #     publisher = "alefragnani";
    #     version = "12.0.1";
    #     sha256 = "1bckjq1dw2mwr1zxx3dxs4b2arvnxcr32af2gxlkh4s26hvp9n1v";
    #   }
    #   {
    #     name = "nix-env-selector";
    #     publisher = "arrterian";
    #     version = "0.1.2";
    #     sha256 = "1n5ilw1k29km9b0yzfd32m8gvwa2xhh6156d4dys6l8sbfpp2cv9";
    #   }
    #   {
    #     name = "bracket-pair-colorizer";
    #     publisher = "coenraads";
    #     version = "1.0.61";
    #     sha256 = "0r3bfp8kvhf9zpbiil7acx7zain26grk133f0r0syxqgml12i652";
    #   }
    #   {
    #     publisher = "faustinoaq";
    #     name = "crystal-lang";
    #     version = "0.4.0";
    #     sha256 = "04dnyap8hl2a25kh5r5jv9bgn4535pxdaa77r1cj9hmsadqd4sgr";
    #   }
    #   {
    #     publisher = "freebroccolo";
    #     name = "reasonml";
    #     version = "1.0.38";
    #     sha256 = "1nay6qs9vcxd85ra4bv93gg3aqg3r2wmcnqmcsy9n8pg1ds1vngd";
    #   }
    #   {
    #     publisher = "gleam";
    #     name = "gleam";
    #     version = "1.0.0";
    #     sha256 = "0r8k7y1247dmd0jc1d5pg31cfxi7q849x5psajw8h2s4834c4dk9";
    #   }
    #   {
    #     publisher = "kahole";
    #     name = "magit";
    #     version = "0.6.2";
    #     sha256 = "0qr11k4n96wnsc2rn77i01dmn0zbaqj32wp9cblghhr6h5vs2y9h";
    #   }
    #   {
    #     publisher = "xaver";
    #     name = "clang-format";
    #     version = "1.9.0";
    #     sha256 = "0bwc4lpcjq1x73kwd6kxr674v3rb0d2cjj65g3r69y7gfs8yzl5b";
    #   }
    #   {
    #     publisher = "monokai";
    #     name = "theme-monokai-pro-vscode";
    #     version = "1.1.18";
    #     sha256 = "0dg68z9h84rpwg82wvk74fw7hyjbsylqkvrd0r94ma9bmqzdvi4x";
    #   }
    #   {
    #     publisher = "ronnidc";
    #     name = "nunjucks";
    #     version = "0.3.0";
    #     sha256 = "1xdh3d6azj9al6dcmz0jmivixlz4a3qxcm09x17c0w0f6issmbdf";
    #   }
    #   {
    #     publisher = "haskell";
    #     name = "haskell";
    #     version = "1.2.0";
    #     sha256 = "0vxsn4s27n1aqp5pp4cipv804c9cwd7d9677chxl0v18j8bf7zly";
    #   }
    #   {
    #     publisher = "ms-vscode";
    #     name = "cmake-tools";
    #     version = "1.6.0";
    #     sha256 = "1j3b6wzlb5r9q2v023qq965y0avz6dphcn0f5vwm9ns9ilcgm3dw";
    #   }
    #   {
    #     publisher = "rust-lang";
    #     name = "rust";
    #     version = "0.7.8";
    #     sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
    #   }
    #   {
    #     publisher = "nimsaem";
    #     name = "nimvscode";
    #     version = "0.1.21";
    #     sha256 = "09d2x334dy5i74q4fpxas3pd8nwnamc5zca554aa895cff9f3myp";
    #   }
    #   {
    #     publisher = "MaxGabriel";
    #     name = "brittany";
    #     version = "0.0.9";
    #     sha256 = "1cfbzc8fmvfsxyfwr11vnszvirl47zzjbjp6rihg5518gf5wd36k";
    #   }
    #   {
    #     publisher = "alygin";
    #     name = "vscode-tlaplus";
    #     version = "1.5.4";
    #     sha256 = "0mf98244z6wzb0vj6qdm3idgr2sr5086x7ss2khaxlrziif395dx";
    #   }
    # ];
