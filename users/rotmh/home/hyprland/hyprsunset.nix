{
  services.hyprsunset = {
    enable = true;

    settings = {
      profile = [
        {
          time = "6:30";
        }
        {
          time = "8:30";
          identity = true;
        }
        {
          time = "21:00";
          temperature = 5000;
        }
        {
          time = "22:30";
          temperature = 4000;
        }
        {
          time = "23:30";
          temperature = 3500;
        }
      ];
    };
  };
}
