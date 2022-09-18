local Conveyor = require("Conveyor")
local Detail = require("Detail")

math.randomseed(os.time())
local count_details = 3
local details = {}
local count_mechanisms = 4


while true do
    print('Start the conveyor? (Y/N)')
    local answer = io.read()
    if answer == "y" or answer == "Y" then
        print("Assign new values to details and mechanisms? (Y/N)")
        local assign_answer = io.read()
        if assign_answer == "y" or assign_answer == "Y" then
            io.write("Input number of details: ")
            count_details = io.read('*number')
            if count_details == nil  or count_details <= 0 then
                io.stderr:write("ERROR: Must contain only a positive number!")
                os.exit()
            end

            io.write("Input number of mechanisms: ")
            count_mechanisms = io.read('*number')
            if count_mechanisms == nil  or count_mechanisms <= 0 then
                io.stderr:write("ERROR: Must contain only a positive number!")
                os.exit()
            end
            answer = nil
            break
        elseif assign_answer == "n" or assign_answer == "N" then
            break
        else os.exit()
        end
    elseif answer == "n" or answer == "N" then
        os.exit()
    else
        io.stderr:write("Wrong answer; try again")
    end
end

local conveyor = Conveyor.create_conveyor(count_mechanisms)
for detail = 1, count_details do
    table.insert(details, Detail.create_detail(detail))
end

conveyor.run(details)