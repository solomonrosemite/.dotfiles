-- Audio Device Management Script
-- Only reverts to preferred mic when change is NOT made via System Settings

local log = hs.logger.new("audioMicWatcher", "info")

-- CONFIGURATION - Change this to your preferred microphone name
local PREFERRED_MIC = "Razer Seiren Mini" -- Change to your preferred device name

-- Function to get the currently focused application name
local function getFocusedAppName()
	local focusedWindow = hs.window.focusedWindow()
	if focusedWindow then
		return focusedWindow:application():name()
	end
	return nil
end

-- Function to check if System Settings is currently focused
local function isSystemSettingsFocused()
	local focusedApp = getFocusedAppName()
	-- System Settings can have different names depending on macOS version
	return focusedApp == "System Settings" or focusedApp == "System Preferences" or focusedApp == "SystemUIServer"
end

-- Function to get current input device
local function getCurrentInputDevice()
	local result = hs.execute("/opt/homebrew/bin/SwitchAudioSource -t input -c")
	if result then
		return result:gsub("%s+", "") -- Remove whitespace
	end
	return nil
end

-- Function to set input device
local function setInputDevice(deviceName)
	local success = hs.execute(string.format('/opt/homebrew/bin/SwitchAudioSource -t input -s "%s"', deviceName))
	return success
end

-- Function to show notification
local function showNotification(title, text)
	hs.notify
		.new({
			title = title,
			informativeText = text,
			withdrawAfter = 3,
		})
		:send()
end

-- Variables for revert timer
local revertTimer = nil

-- Function to handle device change with notification and auto-revert
local function handleDeviceChange(newDevice)
	-- Cancel any existing revert timer
	if revertTimer then
		revertTimer:stop()
		revertTimer = nil
	end

	-- Show notification with action buttons
	local notification = hs.notify.new({
		title = "Microphone Changed",
		informativeText = string.format(
			"Changed to: %s\n\nPress Cmd+Alt+Ctrl+K to keep, or it will revert to %s in 10 seconds",
			newDevice,
			PREFERRED_MIC
		),
		withdrawAfter = 10,
		hasActionButton = false,
		actionButtonTitle = "",
	})

	notification:send()

	-- Set up auto-revert timer
	revertTimer = hs.timer.doAfter(10, function()
		log.i("Auto-reverting to preferred device: " .. PREFERRED_MIC)
		setInputDevice(PREFERRED_MIC)
		showNotification("Microphone Auto-Reverted", "Switched back to: " .. PREFERRED_MIC)
		lastKnownDevice = PREFERRED_MIC
		revertTimer = nil
	end)

	return false -- Always return false since we handle the logic with timer
end

-- Hotkey to keep the current device (cancel auto-revert)
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "K", function()
	if revertTimer then
		revertTimer:stop()
		revertTimer = nil
		local current = getCurrentInputDevice()
		showNotification("Microphone Kept", "Keeping current device: " .. current)
		lastKnownDevice = current
		log.i("User chose to keep current device: " .. current)
	end
end)

-- Variables for tracking state
local lastKnownDevice = getCurrentInputDevice()
local changeTimer = nil

-- Main callback function for audio device changes
local function audioDeviceWatcherCallback(event)
	-- Only respond to device changes (dev#)
	if event ~= "dev#" then
		return
	end

	log.i("Audio device change detected, event: " .. event)

	-- Small delay to let the system settle
	if changeTimer then
		changeTimer:stop()
	end

	changeTimer = hs.timer.doAfter(1, function()
		local currentDevice = getCurrentInputDevice()

		if not currentDevice then
			log.e("Could not get current input device")
			return
		end

		log.i("Current device: " .. currentDevice .. ", Last known: " .. (lastKnownDevice or "nil"))

		-- If the device changed and it's not our preferred device
		if currentDevice ~= lastKnownDevice and currentDevice ~= PREFERRED_MIC then
			log.i("Device changed from " .. (lastKnownDevice or "nil") .. " to " .. currentDevice)

			-- Check if System Settings is focused
			if isSystemSettingsFocused() then
				log.i("System Settings is focused - allowing manual change")
				showNotification("Microphone Changed", "Changed to: " .. currentDevice .. " (manual change detected)")
				lastKnownDevice = currentDevice
				return
			end

			-- Handle automatic device change with notification and timer
			log.i("Handling automatic device change with notification")
			handleDeviceChange(currentDevice)
			lastKnownDevice = currentDevice
		else
			-- Update our tracking
			lastKnownDevice = currentDevice
			if currentDevice ~= PREFERRED_MIC then
				log.i("Non-preferred device set, but no action taken (might be initial state)")
			end
		end
	end)
end

-- Initialize the audio device watcher
hs.audiodevice.watcher.setCallback(audioDeviceWatcherCallback)
hs.audiodevice.watcher.start()

-- Initialize last known device
lastKnownDevice = getCurrentInputDevice()

log.i("Audio microphone watcher started")
log.i("Preferred device: " .. PREFERRED_MIC)
log.i("Current device: " .. (lastKnownDevice or "unknown"))

-- Optional: Add a hotkey to manually check/set preferred device
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "M", function()
	local current = getCurrentInputDevice()
	if current == PREFERRED_MIC then
		showNotification("Microphone Status", "Already using preferred: " .. PREFERRED_MIC)
	else
		setInputDevice(PREFERRED_MIC)
		showNotification("Microphone Set", "Switched to preferred: " .. PREFERRED_MIC)
		lastKnownDevice = PREFERRED_MIC
	end
end)

-- Show startup notification
showNotification("Audio Watcher", "Microphone monitoring started")
