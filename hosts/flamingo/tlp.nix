{
  services.tlp = {
    enable = true;

    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      PCIE_ASPM_ON_BAT = "powersave";
    };
  };

  services.power-profiles-daemon.enable = false;

  powerManagement.powertop.enable = true;
}
