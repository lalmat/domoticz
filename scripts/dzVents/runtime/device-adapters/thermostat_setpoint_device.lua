return {

	baseType = 'device',

	name = 'Thermostat setpoint device adapter',

	matches = function (device, adapterManager)
		local res = device.deviceSubType == 'SetPoint' and device.hardwareTypeValue ~= 20
		if (not res) then
			adapterManager.addDummyMethod(device, 'updateSetPoint')
		end
		return res
	end,

	process = function (device, data, domoticz, utils, adapterManager)

		device['SetPoint'] = device.rawData[1] or 0

		function device.updateSetPoint(setPoint)
			-- send the command using openURL otherwise, due to a bug in Domoticz, you will get a timeout on the script
			local url = domoticz.settings['Domoticz url'] ..
					'/json.htm?type=command&param=setsetpoint&idx=' .. device.id .. '&setpoint=' .. setPoint
			utils.log('Setting setpoint using openURL ' .. url, utils.LOG_DEBUG)
			domoticz.openURL(url)
		end

	end

}

