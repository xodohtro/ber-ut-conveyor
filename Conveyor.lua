local Mechanism = require("Mechanism")
local OperationStatus = require("OperationStatus")

local function create_conveyor(count_mechanisms)
    local Conveyor = {
        head_pos = 0,
        mechanisms = {},
        details = {}
    }
    for mechanism_index = 1, count_mechanisms do
        table.insert(Conveyor.mechanisms, Mechanism.create_mechanism(mechanism_index, math.random(4, 8)))
    end

    Conveyor.shift = function()
        Conveyor.head_pos = Conveyor.head_pos + 1
        print("Conveyor shifted")
    end

    Conveyor.mechanism_is_running = function(head_pos)
        return head_pos > Conveyor.head_pos - #Conveyor.details and head_pos <= Conveyor.head_pos
    end

    Conveyor.get_detail = function(mechanism_index)
        local index = Conveyor.head_pos - mechanism_index + 1
        return Conveyor.details[index]
    end

    Conveyor.finished = function()
        return Conveyor.head_pos - #Conveyor.details + 1 >= #Conveyor.mechanisms
    end

    Conveyor.count_mechanisms = function()
        local count = 0
        for i, _ in ipairs(Conveyor.mechanisms) do
            if Conveyor.mechanism_is_running(i) then
                count = count + 1
            end
        end
        return count
    end

    Conveyor.manual_restart_conveyor = function(mechanism_index, mechanism)
        while true do
            io.write("Restart mechanism "..mechanism_index.."? Y/N")
            local answer = io.read()
            if answer == "y" or answer == "Y" then
                mechanism.restart()
                print("Mechanism "..mechanism_index.." restarted")
                break
            elseif answer == "n" or answer == "N" then
                print("Conveyor stopped")
                os.exit()
            else
                io.stderr:write("Wrong answer; try again")
            end
        end
    end

    Conveyor.run = function(details)
        print("Conveyor run with "..#details.." details")
        Conveyor.details = details
        while not Conveyor.finished() do
            Conveyor.shift()
            local results = {}
            local count_results = 0
            while true do
                for mechanism_index, mechanism in ipairs(Conveyor.mechanisms) do
                    if Conveyor.mechanism_is_running(mechanism_index) and results[mechanism_index] == nil then
                        local curr_detail = Conveyor.get_detail(mechanism_index)
                        local result, work_time = mechanism.run(curr_detail)
                        if result ~= nil then
                            if work_time > mechanism.expect_time or result == OperationStatus.FAIL then
                                local reason
                                if result == OperationStatus.FAIL then
                                    reason = "failure"
                                else
                                    reason = "timeout: "..work_time.." > "..mechanism.expect_time
                                end
                                print("Mechanism "..mechanism_index.." fail to process detail "..curr_detail.id.." because "..reason)
                                print("Conveyor paused")
                                Conveyor.manual_restart_conveyor(mechanism_index, mechanism)
                            else
                            results[mechanism_index] = result
                            count_results = count_results + 1
                            end
                        end
                    end
                end
                if Conveyor.count_mechanisms() == count_results then
                    break
                end
            end
        end

        Conveyor.shift()
        print("Conveyor finished")
    end

    return Conveyor
end

return {
    create_conveyor = create_conveyor
}