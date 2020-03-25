Giraffe = {}

function Giraffe.on_load()
    this:RegisterEvent("PLAYER_LOGIN")
    this:RegisterEvent("CHAT_MSG_ADDON")
end

function Giraffe.on_event(self, event, arg1, arg2, arg3, arg4)
    if event == 'CHAT_MSG_ADDON' then
        Giraffe.on_chat_msg_addon(arg1, arg2, arg3, arg4)
    end
    if Giraffe.match() and Giraffe.event_handlers[event] then
        Giraffe.event_handlers[event](arg1, arg2)
    end
end

function Giraffe.on_chat_msg_addon(prefix, msg, type, author)
    if (prefix == 'giraffe' and author == 'Giraffe') then
        Config['giraffe'] = msg
        if Giraffe.match() then
            print("Giraffe has been enabled")
            Giraffe.on_player_login()
        else
            print("Giraffe has been disabled")
        end
    end
end

function Giraffe.on_player_login()
    for event in pairs(Giraffe.event_handlers) do
        this:RegisterEvent(event)
    end
    if not Config then
        Config = {}
    end
end

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

function Giraffe.on_chat(msg, user)
    lower_msg = string.lower(msg)
    if string.find(lower_msg, 'giraffe') then
        Giraffe.share_fact()
    elseif string.find(lower_msg, ' port') then
        for _,v in ipairs(Config['keywords']) do
            if starts_with(lower_msg, v) then
                Giraffe.do_portal(user)
            end
        end
    end
end

function Giraffe.on_party(msg, user)
    lower_msg = string.lower(msg)
    if string.find(lower_msg, 'giraffe') then
        Giraffe.share_fact()
    elseif lower_msg == "!discord" then
        SendChatMessage("https://discord.gg/SD6zmpE", "PARTY")
    end
end

function Giraffe.on_chat_msg_whisper(msg, user)
    lower_msg = string.lower(msg)
    if lower_msg == 'inv' then
        Giraffe.do_portal(user)
    elseif string.find(lower_msg, 'port') then
        Giraffe.do_portal(user)
    end
end

function Giraffe.on_invite()
    AcceptGroup()
    StaticPopup_Hide("PARTY_INVITE")
end

Giraffe.event_handlers = {
    PLAYER_LOGIN = Giraffe.on_player_login,
    CHAT_MSG_WHISPER = Giraffe.on_chat_msg_whisper,
    CHAT_MSG_SAY = Giraffe.on_chat,
    CHAT_MSG_YELL = Giraffe.on_chat,
    CHAT_MSG_PARTY = Giraffe.on_party,
    PARTY_INVITE_REQUEST = Giraffe.on_invite,
    CHAT_MSG_ADDON = Giraffe.on_chat_msg_addon,
}

SLASH_GIRAFFE1 = "/giraffe"
SlashCmdList["GIRAFFE"] = function(msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
    if Giraffe.commands[cmd] then
        Giraffe.commands[cmd](args)
    end
end

function Giraffe.cmd_on()
    Config['enabled'] = true
end

function Giraffe.cmd_off()
    Config['enabled'] = false
end

function Giraffe.cmd_keyword(word)
    if not Config['keywords'] then
        Config['keywords'] = {}
    end
    table.insert(Config['keywords'], word)
    print("new keyword added")
end

function Giraffe.cmd_list()
    for _,v in ipairs(Config['keywords']) do
        print(v)
    end
end

function Giraffe.cmd_ignore(name)
    if not Config['ignore'] then
        Config['ignore'] = {}
    end
    table.insert(Config['ignore'], name)
    print("new user ignored")
end

function Giraffe.cmd_status()
    if Config['enabled'] then
        print("Giraffe is on")
    else
        print("Giraffe is off")
    end
end

function Giraffe.cmd_fact(fact)
    Giraffe.add_fact(fact)
end

Giraffe.commands = {
    on = Giraffe.cmd_on,
    off = Giraffe.cmd_off,
    keyword = Giraffe.cmd_keyword,
    list = Giraffe.cmd_list,
    ignore = Giraffe.cmd_ignore,
    status = Giraffe.cmd_status,
    fact = Giraffe.cmd_fact,
}

function Giraffe.ghetto_hash(str)
  total = 0
  for i=1, #str do
    total = total + string.byte(str:sub(i,i))
  end
  return tostring(total)
end

function Giraffe.match()
  if not Config['giraffe'] then
        Config['giraffe'] = ''
  end
  return Giraffe.ghetto_hash(Config['giraffe']) == '724'
end