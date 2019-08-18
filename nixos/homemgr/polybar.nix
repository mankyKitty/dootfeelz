{ pkgs, ... }:
{
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      pulseSupport = true;
      githubSupport = true;
    };
    script = "polybar top &";

    config = {
      "bar/eDP-1" = {
        "inherit" = "bar/top";
        monitor = "\${env:MONITOR:eDP-1}";
      };
      "bar/HDMI-1" = {
        "inherit" = "bar/top";
        monitor = "\${env:MONITOR:HDMI-1}";
      };

      "bar/top" = {
        width = "100%";
        height = "2%";
        radius = 0;

        tray-position = "right";

        modules-left = "workspace-xmonad";
        modules-center = "title-xmonad";
        modules-right = "date battery";

        padding-left = 0;
        padding-right = 2;

        module-margin-left = 1;
        module-margin-right = 2;

        font-0 = "Iosevka:size=10;1";
        font-1 = "Unifont:size=12:weight=bold;2";
        font-2 = "FontAwesome:style=Regular:pixelsize=10;";
      };

      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "ADP1";
        full-at = "98";
      };

      "module/workspace-xmonad" = {
        type = "custom/script";
        exec = "${pkgs.coreutils}/bin/tail -F /tmp/.xmonad-workspace-log";
        exec-if = "[ -p  /tmp/.xmonad-workspace-log ]";
        tail = true;
      };

      "module/title-xmonad" = {
        type = "custom/script";
        exec = "${pkgs.coreutils}/bin/tail -F /tmp/.xmonad-title-log";
        exec-if = "[ -p  /tmp/.xmonad-title-log ]";
        tail = true;
      };

      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%d/%m/%Y";
        time = "%H:%M%z";
        label = "%time%  %date%";
      };
    };
  };
}
