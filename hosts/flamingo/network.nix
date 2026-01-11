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
      "wifi/hotspot/ssid" = {
        sopsFile = ./secrets/network.yaml;
      };
      "wifi/hotspot/psk" = {
        sopsFile = ./secrets/network.yaml;
      };
      "wifi/class/ssid" = {
        sopsFile = ./secrets/network.yaml;
      };
      "wifi/class/psk" = {
        sopsFile = ./secrets/network.yaml;
      };
    };

    templates = {
      "wifi.env".content = ''
        WIFI_HOME_SSID="${config.sops.placeholder."wifi/home/ssid"}"
        WIFI_HOME_PSK="${config.sops.placeholder."wifi/home/psk"}"
        WIFI_HOTSPOT_SSID="${config.sops.placeholder."wifi/hotspot/ssid"}"
        WIFI_HOTSPOT_PSK="${config.sops.placeholder."wifi/hotspot/psk"}"
        WIFI_CLASS_SSID="${config.sops.placeholder."wifi/class/ssid"}"
        WIFI_CLASS_PSK="${config.sops.placeholder."wifi/class/psk"}"
      '';
    };
  };

  networking.networkmanager = {
    enable = true;

    wifi.powersave = true;

    ensureProfiles = {
      environmentFiles = [ config.sops.templates."wifi.env".path ];

      profiles = {
        home = {
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

        hotspot = {
          connection = {
            id = "$WIFI_HOTSPOT_SSID";
            type = "wifi";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$WIFI_HOTSPOT_SSID";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$WIFI_HOTSPOT_PSK";
          };
          ipv4.method = "auto";
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
        };

        class = {
          connection = {
            id = "$WIFI_CLASS_SSID";
            type = "wifi";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$WIFI_CLASS_SSID";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$WIFI_CLASS_PSK";
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
