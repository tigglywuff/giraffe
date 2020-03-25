function Giraffe.add_fact(string)
    if not Config['facts'] then
        Config['facts'] = {}
    end
    if (string) then
        table.insert(Config['facts'], fact)
        print("new fact added")
    else
        Giraffe.share_fact()
    end
end


function Giraffe.share_fact()
    local is_giraffe = UnitName('player') == 'Giraffe'
    if Config['facts'] and is_giraffe then
         local facts = Config['facts']
         local random_fact = facts[math.random(#facts)]
         SendChatMessage("Facts! " .. random_fact, "EMOTE")
    end
end