local Mechanism = require("Mechanism")
local Status = require("Status")

local function create(num_mechanisms)
    local Conveyor = {
        pos = 0,
        mechanisms = {},
        details = {}
    }
    for i = 1, num_mechanisms do
        table.insert(Conveyor.mechanisms, Mechanism.create(i, math.random(4, 8)))
    end

    Conveyor.move = function()
        Conveyor.pos = Conveyor.pos + 1
        print("Conveyor moves")
    end

    Conveyor.is_run_mechanism = function(pos)
        return pos > Conveyor.pos - #Conveyor.details and pos <= Conveyor.pos
    end

    Conveyor.run = function(details)
        print("Conveyor run with "..#details.." details")
        Conveyor.details = details
        while not (Conveyor.pos - #Conveyor.details + 1 >= #Conveyor.mechanisms) do
            Conveyor.move()
            local results = {}
            local num_results = 0
            while true do
                for i, mechanism in ipairs(Conveyor.mechanisms) do
                    if Conveyor.is_run_mechanism(i) and results[i] == nil then
                        local curr_detail = Conveyor.details[Conveyor.pos - i + 1]
                        local result, time_work = mechanism.run(curr_detail)
                        if result ~= nil then
                            if time_work > mechanism.time_expect or result == Status.FAIL then
                                local because
                                if result == Status.FAIL then
                                    because = "failure"
                                else
                                    because = "timeout: "..time_work.." > "..mechanism.time_expect
                                end
                                print("Mechanism "..i.." fail to process detail "..curr_detail.id.." because "..because)
                                print("Conveyor paused")
                                while true do
                                    print("Restart mechanism "..i.."? Y/N")
                                    local answer = io.read()
                                    if answer == "y" or answer == "Y" then
                                        mechanism.restart()
                                        print("Mechanism "..i.." restarted")
                                        break
                                    elseif answer == "n" or answer == "N" then
                                        print("Conveyor stopped")
                                        os.exit()
                                    else
                                        print("Wrong answer; try again")
                                    end
                                end
                            else
                                results[i] = result
                                num_results = num_results + 1
                            end
                        end
                    end
                end
                local num_run_mechanisms = 0
                for i, _ in ipairs(Conveyor.mechanisms) do
                    if Conveyor.is_run_mechanism(i) then
                        num_run_mechanisms = num_run_mechanisms + 1
                    end
                end
                if num_run_mechanisms == num_results then
                    break
                end
            end
        end

        Conveyor.move()
        print("Conveyor finished")
    end

    return Conveyor
end

return {
    create = create
}