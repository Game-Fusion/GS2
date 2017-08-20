function split(str, pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    if str ~= nil then
       local fpat = "(.-)" .. pat
       local last_end = 1
       local s, e, cap = str:find(fpat, 1)
       while s do
          if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
          end
          last_end = e+1
          s, e, cap = str:find(fpat, last_end)
       end
       if last_end <= #str then
          cap = str:sub(last_end)
          table.insert(t, cap)
       end
    else
        print("##ERROR failed to split ["..str.."] by:"..pat)
    end
    return t
end

local function getTableSize(table)
	local sz = 0
	for k,v in pairs(table) do
		sz = sz + 1
	end
	return sz
end

function unformatTable(string, join)
	return split(string, join)
end

function formatTable(table, join, start)
	if start == nil then start = 1 end
	local str = ""
	for i=start,#table do
		if i == start then str = table[i] else str = str..join..table[i] end
	end
	return str
end

function formatComplexTable(table, join, op)
	local str = ""
	for k,v in pairs(table) do
		if type(v) ~= "function" and type(v) ~= "nil" then
			if str == "" then 
				str = k..op..v 
			else 
				str = str..join..k..op..v 
			end
		end
	end
	return str
end

function unformatComplexTable(string, join, op)
	local table = split(string, join)
	local ntable = {}
	for i=1,#table do
		local splt = split(table[i], op)
		if splt[1] ~= nil then
			ntable[splt[1]] = splt[2]
		end
	end
	return ntable
end

function createServer(sname, sid)
	local server = {
		name = sname,
		id = sid,
		users = { },
		data = { },
		getPlayerList = function(self)
			local list = {}
			for k,v in pairs(self.users) do
				list[#list + 1] = k
			end
			return list
		end,
		sendPlayerList = function(self, player)
			local p = self.users[player]
			if p ~= nil then
				rednet.send(p[1], formatTable(self:getPlayerList(), "#@#"))
			end
		end,
		getUsers = function(self)
			return self.users
		end,
		addPlayer = function(self, player, id, data)
			self:getUsers()[player] = {id, data}
		end,
		removePlayer = function(self, player)
			local users = self.users
			if users == nil then users = {} end
			users[player] = nil
			self.users = users
		end,
		addSData = function(self, name, info)
			local data = self.data
			if data == nil then data = {} end
			data[name] = info
			self.data = data
		end,
		getSData = function(self)
			local val = self.data
			if val ~= nil then
				val = formatComplexTable(val, "#@#", "#=#")
				return val
			end
			return nil
		end,
		getPlayer = function(self, id)
			local users = self.users
			if users == nil then users = {} end
			for k,v in pairs(users) do
				if v[1] == id then return k end
			end
			self.users = users
			return nil
		end,
		getID = function(self, player)
			local users = self.users
			if users == nil then users = {} end
			local p = users[player]
			if p ~= nil then return p[1] else
				return nil
			end
			self.users = users
		end,
		getData = function(self, player)
			local users = self.users
			if users == nil then users = {} end
			local p = users[player]
			if p ~= nil then return p[2] else
				return data
			end
			self.users = users
		end,
		setData = function(self, player, data)
			local users = self.users
			if users == nil then users = {} end
			local p = users[player]
			if p ~= nil then 
				p[2] = data
			end
			self.users = users
		end,
		pingUsers = function(self, info)
			local users = self.users
			if users == nil then users = {} end
			for k,v in pairs(users) do
				rednet.send(v[1], info)
			end
			self.users = users
		end,
		waitForCommand = function(self)
			local id, message, distance = rednet.receive()
			local users = self.users
			if users == nil then users = {} end
			local data = self.data
			if data == nil then data = {} end
			
			local typ = nil
			if id ~= nil then
				if message:sub(1, 5) == "JOIN " then
					local splt = split(message, " ")
					local name = formatTable(splt, " ", 2)
					users[name] = { id, {} }
					typ = 1
				elseif message == "LEAVE" then
					self:removePlayer(self:getPlayer(id))
					typ = 2
				elseif message == "GET_DATA" then
					if self:getPlayer(id) ~= nil then
						local player = self:getPlayer(id)
						local dat = self:getData(player)
						if dat ~= nil then
							rednet.send(id, formatTable(dat, "#@#"))
							typ = 3
						end
					end
				elseif message:sub(1, string.len("SET_DATA ")) == "SET_DATA " then
					local type = 11
					if self:getPlayer(id) ~= nil then
						local splt = split(message, " ")
						local ftabl = formatTable(splt, " ", 2)
						local table = unformatTable(ftabl, "#@#")
						if table ~= nil then
							self.setData(self, self:getPlayer(id), table)
							typ = 8
						end
					end
				elseif message == "GET_PLAYERLIST" then
					if self:getPlayer(id) ~= nil then
						local fmt = formatTable(self:getPlayerList(), "#@#")
						rednet.send(id, "PLS::"..fmt)
						typ = 4
					end
				elseif message == "@#@GET_NAME@#@" then
					rednet.send(id, "~S~"..self.name)
					typ = 5
				elseif message == "GET_SERVER_DATA" then
					if self:getPlayer(id) ~= nil then
						rednet.send(id, self:getSData())
						typ = 6
					end
				elseif message:sub(1, string.len("SET_SERVER_DATA@#@")) == "SET_SERVER_DATA@#@" then
					if self:getPlayer(id) ~= nil then
						local splt = split(message, "@#@")
						local piece = splt[3]
						local name = splt[2]
						if name == "#LEN#" then name = #data end
						if name == "#LEN+#" then name = #data + 1 end
						self:addSData(name, piece)
						typ = 7
					end
				end
			end
			if typ ~= nil then
				return tonumber(typ)
			else
				return "INVALID"
			end
			self.users = users
			self.data = data
		end,
	}
	return server
end

function createUser(uname, sname, uid, sid)
	local user = {
		name = uname,
		id = uid,
		server_name = sname,
		server_id = sid,
		joinServer = function(self)
			rednet.send(self.server_id, "JOIN "..self.name)
		end,
		leaveServer = function(self)
			rednet.send(self.server_id, "LEAVE")
		end,
		getPlayerList = function(self)
			rednet.send(self.server_id, "GET_PLAYERLIST")
			local id, message, distance = rednet.receive()
			local typ = string.sub(message, 1, 5)
			message = message:sub(6, -1)
			local n = 1
			while id ~= self.server_id and typ ~= "PLS::" and n < 20 do
				id, message, distance = rednet.receive()
				typ = string.sub(message, 1, 5)
				message = message:sub(6, -1)	
				n = n + 1
			end
			if n < 20 then
				return unformatTable(message, "#@#")
			end
			return nil
		end,
		getData = function(self)
			rednet.send(self.server_id, "GET_DATA")
			local id, message, distance = rednet.receive()
			if id == self.server_id then
				return unformatTable(message, "#@#")
			end
			return nil
		end,
		setData = function(self, table)
			rednet.send(self.server_id, "SET_DATA "..formatTable(table, "#@#", 1))
		end,
		getSData = function(self)
			rednet.send(self.server_id, "GET_SERVER_DATA")
			local id, message, distance = rednet.receive()
			if id == self.server_id then
				return unformatComplexTable(message, "#@#", "#=#")
			end
			return nil
		end,
		setSData = function(self, name, piece)
			rednet.send(self.server_id, "SET_SERVER_DATA@#@"..name.."@#@"..piece)
		end,
		waitForPing = function(self)
			local id, message, distance = rednet.receive()
			if id ~= nil and id == self.server_id then
				return message
			end
			return nil
		end,
		isFromServer = function(self, id)
			return id == self.server_id
		end,
	}
	return user
end

function getServers()
	local servers = {}
	local n = 0
	local i = 0
	local ok = true
	rednet.broadcast("@#@GET_NAME@#@")
	while ok and i < 500 do
		local id, message, distance = rednet.receive(2)
		if id ~= nil then
			local str = message:sub(1, 3)
			if str == "~S~" then
				local sname = message:sub(4, -1)
				servers[sname] = id
				n = 0
			else
				n = n + 1
				if n > 5 then ok = false end
			end
		else
			ok = false
		end
		i = i + 1
	end
	return servers
end
