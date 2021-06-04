(self: super: {
  glibc_2_28 = super.glibc.overrideAttrs (oldAttrs: {
    src = super.fetchurl {
      url = "https://ftp.gnu.org/gnu/glibc/glibc-2.28.tar.xz";
      sha256 = "0wpwq7gsm7sd6ysidv0z575ckqdg13cr2njyfgrbgh4f65adwwji";
    };
  });
})
