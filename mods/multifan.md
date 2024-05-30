# Tie your two parts fans together to use as one sigle fan unit

### Credits to [Roar Ree on FB](https://www.facebook.com/groups/6997076173737632/permalink/7222730737838840)
    [multi_pin fan_pins]
    pins: extra_mcu:PA7, extra_mcu:PB1

    [fan]
    pin:multi_pin: fan_pins
    max_power: 1.0