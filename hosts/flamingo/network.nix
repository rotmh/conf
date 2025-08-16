{ config, ... }:
{
  sops = {
    secrets = {
      "wifi/home/ssid" = {
        sopsFile = ./secrets/network.yaml;
      };
      "wifi/home/psk" = {
        sopsFile = ./secrets/network.yaml;
      };
    };

    templates = {
      "wifi.env".content = ''
        WIFI_HOME_SSID="${config.sops.placeholder."wifi/home/ssid"}"
        WIFI_HOME_PSK="${config.sops.placeholder."wifi/home/psk"}"
      '';
    };
  };

  networking.networkmanager = {
    enable = true;

    ensureProfiles = {
      environmentFiles = [ config.sops.templates."wifi.env".path ];

      profiles = {
        home-wifi = {
          connection = {
            id = "$WIFI_HOME_SSID";
            type = "wifi";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$WIFI_HOME_SSID";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$WIFI_HOME_PSK";
          };
          ipv4.method = "auto";
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
        };
      };
    };
  };
}
