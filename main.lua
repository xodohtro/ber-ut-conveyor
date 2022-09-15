local Conveyor = require("Conveyor")
local Detail = require("Detail")

math.randomseed(os.time())
local num_details = 3
local details = {}
local num_mechanisms = 4


while true do
    print('Start the conveyor? (Y/N)')
    local answer = io.read()
    if answer == "y" or answer == "Y" then
        print("Assign new values to details and mechanisms? (Y/N)")
        local assign_answer = io.read()
        if assign_answer == "y" or assign_answer == "Y" then
            io.write("Input number of details: ")
            num_details = io.read('*number')
            if num_details == nil  or num_details <= 0 then
                io.stderr:write("ERROR: Must contain only a positive number!")
                os.exit()
            end

            io.write("Input number of mechanisms: ")
            num_mechanisms = io.read('*number')
            if num_mechanisms == nil  or num_mechanisms <= 0 then
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

local conveyor = Conveyor.create(num_mechanisms)
for i = 1, num_details do
    table.insert(details, Detail.create(i))
end

conveyor.run(details)