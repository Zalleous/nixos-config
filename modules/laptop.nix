{ config, pkgs, ... }:

{
  # Laptop-specific power management and optimization

  # Enable TLP for better battery life
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Better scheduling for power saving
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";

  # Enable thermald for Intel CPUs
  services.thermald.enable = true;

  # Auto-cpufreq as alternative to TLP (disable one if using the other)
  # services.auto-cpufreq.enable = true;

  # Disable wake on various devices to save power
  powerManagement.powertop.enable = true;

  # Enable bluetooth with power saving
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  # Backlight control
  programs.light.enable = true;
  users.users.zalleous.extraGroups = [ "video" ];

  # Additional laptop utilities
  environment.systemPackages = with pkgs; [
    acpi
    powertop
    brightnessctl
  ];
}
