PAUSE_BEFORE_GAME_BEGINS = 5
THEORETICAL_MAX_DIFFICULTY = 1010
CONFIGURABLE_MAX_DIFFICULTY = 1000
UNLIMITED = 0
VERTICAL_SPAWN_ADJUSTMENT = 50
MINIMUM_BREAK_DURATION = 0
MINIMUM_WAVE_DURATION = 0

-- Settings
local waves = minetest.settings:get_bool("raining_death_waves") or true
local clear_objects = minetest.settings:get_bool("raining_death_clear_objects") or true
local chat_notifications = minetest.settings:get_bool("raining_death_chat_notifications") or true
local initial_wave_duration = tonumber(minetest.settings:get("raining_death_wave_duration") or 30)
local initial_break_duration = tonumber(minetest.settings:get("raining_death_break_duration") or 30)
local initial_difficulty = tonumber(minetest.settings:get("raining_death_initial_difficulty") or 800)
local difficulty_change_per_wave = tonumber(minetest.settings:get("raining_death_difficulty_change_per_wave")) or 10
local break_duration_change_per_wave = tonumber(minetest.settings:get("raining_death_break_duration_change_per_wave")) or 0
local wave_duration_change_per_wave = tonumber(minetest.settings:get("raining_death_wave_duration_change_per_wave")) or 1
local max_difficulty = tonumber(minetest.settings:get("raining_death_max_difficulty")) or CONFIGURABLE_MAX_DIFFICULTY
local max_break_duration = tonumber(minetest.settings:get("raining_death_max_break_duration")) or UNLIMITED
local max_wave_duration = tonumber(minetest.settings:get("raining_death_max_wave_duration")) or UNLIMITED

local current_wave = 1
local current_difficulty = initial_difficulty
local current_wave_duration = initial_wave_duration
local current_break_duration = initial_break_duration
local on_break = true

local S = minetest.get_translator and minetest.get_translator("raining_death")
local tnt_model = minetest.registered_nodes["tnt:tnt_burning"]
    and "tnt:tnt_burning"
    or "tnt:tnt"

-- local function round (num)
--     return math.floor(num + 0.5)
-- end

-- NOTE: I think there might be a more efficient way to do this: https://dev.minetest.net/minetest.register_globalstep

local function spawn_tnt_action (pos, node, active_object_count, active_object_count_wider)
    if on_break then
        return
    end

    local current_easiness = (THEORETICAL_MAX_DIFFICULTY - current_difficulty)
    if math.random(math.max(1, current_easiness)) > 1 then
        return
    end

    local spawn_pos = {
        x = pos.x,
        y = pos.y + VERTICAL_SPAWN_ADJUSTMENT, -- Just to make sure most of them spawn above the player.
        z = pos.z,
    }

    minetest.add_node(spawn_pos, {
        name=tnt_model
    })
end

local function update_difficulty ()
    current_wave = current_wave + 1
    local proposed_wave_duration = math.max(current_wave_duration + wave_duration_change_per_wave, MINIMUM_WAVE_DURATION)
    local proposed_break_duration = math.max(current_break_duration + break_duration_change_per_wave, MINIMUM_BREAK_DURATION)
    current_wave_duration = max_wave_duration == UNLIMITED
        and proposed_wave_duration
        or math.min(proposed_wave_duration, max_wave_duration)
    current_break_duration = max_break_duration == UNLIMITED
        and proposed_break_duration
        or math.min(proposed_break_duration, max_break_duration)
    current_difficulty = math.min(current_difficulty + difficulty_change_per_wave, max_difficulty)
end

-- I don't really get why this has to be global.
function Start_break ()
    on_break = true
    if chat_notifications then
        minetest.chat_send_all(
            S("End of TNT wave @1. Bombing will cease for @2 seconds.",
            current_wave,
            current_break_duration)
        )
    end
    minetest.after(current_break_duration, Start_wave)
    update_difficulty()
end

-- I don't really get why this has to be global.
function Start_wave ()
    if waves then
        if chat_notifications then
            minetest.chat_send_all(
                S("Starting TNT wave @1, which will last @2 seconds. Difficulty: @3.",
                current_wave,
                current_wave_duration,
                current_difficulty)
            )
        end
        if clear_objects then
            minetest.clear_objects({
                mode="quick",
            })
        end
    end
    on_break = false
    if waves then
        minetest.after(current_wave_duration, Start_break)
    end
end

minetest.register_abm({
    label = "Rain TNT",
    nodenames = {"air"},
    interval = 1,
    chance = 1000,
    action = spawn_tnt_action,
})

minetest.after(PAUSE_BEFORE_GAME_BEGINS, Start_wave)
