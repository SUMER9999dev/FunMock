local function array_equal(arr1: {any}, arr2: {any}): boolean
    if #arr1 ~= #arr2 then
        return false
    end

    for index, value in arr1 do
        if arr2[index] ~= value then
            return false
        end
    end

    return true
end


local FunMock = {}
FunMock.__index = FunMock

function FunMock.new()
    local self = setmetatable({}, FunMock)

    self:reset()

    return self
end

function FunMock:reset()
    self.__implementation = function() end
    self.__throws = {}
    self.__returns = {}

    self.calls = {}
    self.called_times = 0
end

function FunMock:__call(...)
    local result = table.pack(pcall(self.__implementation, ...))
    local is_success = result[1]

    table.remove(result, 1)

    self.calls[#self.calls + 1] = {...}
    self.called_times += 1

    if is_success then
        self.__returns[#self.__returns + 1] = result
        return unpack(result)
    end

    self.__throws[#self.__throws + 1] = result
    error(unpack(result))
end

function FunMock:implement_once(callback: (...any) -> any)
    local previous_implementation = self.__implementation

    self.__implementation = function(...)
        self.__implementation = previous_implementation
        return callback(...)
    end

    return self
end

function FunMock:implement(callback: (...any) -> any)
    self.__implementation = callback
    return self
end

function FunMock:return_once(value: any)
    local previous_implementation = self.__implementation

    self.__implementation = function()
        self.__implementation = previous_implementation
        return value
    end

    return self
end

function FunMock:return_forever(value: any)
    self.__implementation = function()
        return value
    end

    return self
end

function FunMock:return_self()
    self.__implementation = function(fn_self)
        return fn_self
    end

    return self
end

function FunMock:first_call()
    return self.calls[1]
end

function FunMock:last_call()
    return self.calls[#self.calls]
end

function FunMock:called()
    return self.called_times > 0
end

function FunMock:throwed()
    return #self.__throws > 0
end

function FunMock:called_with(...)
    local match_arguments = {...}

    if not self:called() then
        return false
    end

    for _, call in self.calls do
        if array_equal(match_arguments, call) then
            return true
        end
    end

    return false
end

function FunMock:returned(...)
    local match_return = {...}

    if not self:called() then
        return false
    end

    for _, ret in self.__returns do
        if array_equal(match_return, ret) then
            return true
        end
    end

    return false
end

function FunMock:throwed_with(exception: any)
    if not self:throwed() then
        return false
    end

    for _, throw in self.__throws do
        if typeof(throw[1]) ~= 'string' or typeof(exception) ~= 'string' then
			if throw[1] == exception then
				return true
			end

			continue
		end

        if string.find(throw[1], exception) then
            return true
        end
    end

    return false
end


return function()
    return FunMock.new()
end