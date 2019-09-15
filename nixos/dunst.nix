{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Iosevka";
        markup = "full";
        format = "<b>%s</b>\\n%b";
        icon_position = "left";
        sort = true;
        geometry = "500x60-10+29";
        alignment = "center";
        separator_height = 2;
        transparency = 10;
        padding = 6;
        horizontal_padding = 6;
        word_wrap = true;
        separator_color = "frame";
        frame_width = 2; 
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
      urgency_low = {
        frame_color = "#3B7C87";
        foreground = "#3B7C87";
        background = "#191311";
        timeout = 4;
      };
      urgency_normal = {
        frame_color = "#5B8234";
        foreground = "#5B8234";
        background = "#191311";
        timeout = 6;
      };
      urgency_critical = {
        frame_color = "#B7472A";
        foreground = "#B7472A";
        background = "#191311";
        timeout = 8;
      };
    };
  };
}
