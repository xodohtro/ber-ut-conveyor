local Status = require("Status")

local function wait(time_work)
    local time_end = tonumber(os.clock() + time_work);
    repeat coroutine.yield() until os.clock() >= time_end
end

local function create(pos, time_expect)

    local Mechanism = {
        pos = pos,
        time_expect = time_expect
    }

    Mechanism.restart = function()
        Mechanism.process = coroutine.create(function(detail)
            local time_work = math.random(1, 5)
            print("Mechanism "..Mechanism.pos..": START process detail "..detail.id)
            wait(time_work)
            local result
            if math.random(1, 10) == 5 then
                result = Status.FAIL
            else
                result = Status.OK
                print("Mechanism "..Mechanism.pos..": END process detail "..detail.id.."; work for "..time_work.." sec")
            end
            return result, time_work
        end)
    end

    Mechanism.run = function(detail)
        if detail == nil then return nil end
        if coroutine.status(Mechanism.process) == "dead" then
            Mechanism.restart()
            return nil
        end
        local _, status, work_time = coroutine.resume(Mechanism.process, detail)
        return status, work_time
    end

    Mechanism.restart()

    return Mechanism
end

return {
    create = create
}

