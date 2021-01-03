# "Raining Death" Minetest Mod

This [MineTest](https://www.minetest.net/) mod causes TNT to rain from the sky
at random.

## Profiles

### MineTest with a Twist

For players wanting normal MineTest, but with infrequent bombings adding a
twist to gameplay.

```
raining_death_waves = false
raining_death_clear_objects = false
raining_death_chat_notifications = false
raining_death_initial_break_duration = 0
raining_death_initial_difficulty = 200
raining_death_difficulty_change_per_wave = 0
raining_death_break_duration_change_per_wave = 0
raining_death_wave_duration_change_per_wave = 0
```

### Get to Shelter Immediately

For players wanting an extreme form of gameplay where the surface is barely
survivable.

```
raining_death_waves = true
raining_death_clear_objects = true
raining_death_chat_notifications = true
raining_death_initial_difficulty = 900
raining_death_difficulty_change_per_wave = 1
raining_death_break_duration_change_per_wave = 0
raining_death_wave_duration_change_per_wave = 1
raining_death_max_wave_duration = 60
```

## To Do

- [ ] Siren
- [ ] Bomb only during day/night
- [x] Internationalization
- [ ] Clear objects once certain number is reached
- [ ] Do something if TNT model does not exist.
- [ ] Diagnostic log messages
