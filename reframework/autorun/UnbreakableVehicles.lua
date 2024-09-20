local WriteInfoLogs = false -- Set to true to enable info logging

local function log_info(info_message)
  if WriteInfoLogs then
    log.info("[Chaplain Grimaldus > Invincible Vehicles]: " .. info_message)
  end
end

local hasRunInitially = false
local currentScene = nil

local function make_vehicle_invincible(scene, vehicle_name)
  local vehicle = scene:call("findGameObject(System.String)", vehicle_name)
  if not vehicle then
    log_info(vehicle_name .. " not found!")
    return
  end

  local hitPointController = vehicle:call("getComponent(System.Type)",
    sdk.typeof("app.solid.HitPointController"))
  if not hitPointController then
    log_info(vehicle_name .. " HitPointController not found")
    return
  end

  hitPointController:set_Invincible(true)
  hitPointController:set_NoDamage(true)
  log_info(vehicle_name .. " set to Invincible and NoDamage")
end

re.on_pre_application_entry("LockScene", function()
  local sceneManager = sdk.get_native_singleton("via.SceneManager")
  if not sceneManager then
    log_info("SceneManager not found")
    return
  end

  local scene = sdk.call_native_func(sceneManager, sdk.find_type_definition("via.SceneManager"), "get_CurrentScene")
  if not scene then
    log_info("Current scene not found")
    return
  end

  if currentScene ~= scene then
    hasRunInitially = false
    currentScene = scene
    log_info("Scene has changed, resetting invincibility")
  end

  local player = scene:call("findGameObject(System.String)", "Pl_Frank")
  if not player then
    hasRunInitially = false
    log_info("Player not found, resetting.")
    return
  end

  if not hasRunInitially then
    make_vehicle_invincible(scene, "Vehicle_om009b_Bike")

    make_vehicle_invincible(scene, "PREF_Vehicle_om009a_Hammer_Em4d")

    make_vehicle_invincible(scene, "Vehicle_om0009_2DoorCar")

    hasRunInitially = true
  end
end)
