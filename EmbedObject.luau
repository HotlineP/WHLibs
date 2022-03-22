local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local EmbedObject = {
	__signals = {},
	__methods = {},
	instance = false
}

local ReservedWords = {
	"__signals",
	"instance"
}

EmbedObject.__index = EmbedObject
EmbedObject.__metatable = "This metatable is locked."

function EmbedObject.new()
	local self = setmetatable({}, EmbedObject)
	
	return self
end


-- # Adding methods


function EmbedObject:AddProperty(PropertyIndex:string, PropertyValue):boolean
	if not PropertyIndex or PropertyValue == nil then warn("Argument missing.") return false end
	if self[PropertyIndex] then warn("Index already exists.") return false end

	self[PropertyIndex] = PropertyValue

	return true
end


function EmbedObject:AddMethod(MethodIndex:string, Method:(any?) -> (any?)):boolean
	if not MethodIndex or Method == nil then warn("Argument missing.") return false end
	if self.__methods[MethodIndex] then warn("Index already exists.") return false end

	self[MethodIndex] = Method

	return true
end


function EmbedObject:AddSignal(SignalName, Signal):boolean
	if not SignalName or Signal == nil then warn("Argument missing.") return false end
	if self.__signals[SignalName] then warn("Index already exists.") return false end

	self.__signals[SignalName] = Signal

	return true
end


-- # Listing methods


function EmbedObject:ListProperties():{number: string?}
	local tab = {}

	for propertyname, property in pairs(self) do
		if not ReservedWords[propertyname] then
			table.insert(tab, propertyname)
		end
	end

	return tab
end


function EmbedObject:ListSignals():{number: string?}
	local tab = {}

	for signalname, signal in pairs(self.__signals) do
		if not ReservedWords[signalname] then
			table.insert(tab, signalname)
		end
	end

	return tab
end


function EmbedObject:ListMethods():{number: string?}
	local tab = {}

	for methodname, method in pairs(self.__methods) do
		if not ReservedWords[methodname] then
			table.insert(tab, methodname)
		end
	end

	return tab
end


-- # Assembling and disassembling from object.


function EmbedObject:Assemble(Object:Instance):boolean
	self.instance = Object
	return true
end


function EmbedObject:Disassemble():boolean
	self.instance = false
	return true
end


return EmbedObject
