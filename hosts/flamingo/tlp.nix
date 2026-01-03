{
  services.tlp = {
    enable = true;

    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };
}
