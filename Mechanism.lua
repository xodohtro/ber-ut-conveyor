local OperationStatus = require("OperationStatus")

local function working(work_time)
    local working_end_time = tonumber(os.clock() + work_time);
    repeat coroutine.yield() until os.clock() >= working_end_time
end

local function create_mechanism(pos, expect_time)

    local Mechanism = {
        pos = pos,
        expect_time = expect_time
    }

    Mechanism.restart = function()
        Mechanism.process = coroutine.create(function(detail)
            local work_time = math.random(1, 5)
            print("Mechanism "..Mechanism.pos..": START process detail "..detail.id)
            working(work_time)
            local status
            if math.random(1, 10) == 5 then
                status = OperationStatus.FAIL
            else
                status = OperationStatus.OK
                print("Mechanism "..Mechanism.pos..": END process detail "..detail.id.."; work for "..work_time.." sec")
            end
            return status, work_time
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
    create_mechanism = create_mechanism
}

