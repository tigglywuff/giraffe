function Giraffe.do_portal(user)
    print("PORT ALERT!")
    
    if Config['enabled'] then
        PlaySound("ReadyCheck")
        local safe = true
        for _,v in ipairs(Config['ignore']) do
            if string.match(v, user) then
                safe = false
            end
        end
        if safe then
            InviteUnit(user)
        end
    end
end