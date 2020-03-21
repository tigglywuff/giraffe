function Giraffe.add_fact(string)
    if not Config['facts'] then
        Config['facts'] = {}
    end
    table.insert(Config['facts'], fact)
    print("new fact added")
end


function Giraffe.share_fact()
    local is_giraffe = UnitName('player') == 'Giraffe'
    if Config['facts'] then
         local facts = Config['facts']
         local random_fact = facts[math.random(#facts)]
         SendChatMessage("Facts! " .. random_fact, "EMOTE")
    end
end