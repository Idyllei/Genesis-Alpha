local math = require("Math")
local is_a_vector3, is_a_cframe
do
  local _obj_0 = require("type2")
  is_a_vector3, is_a_cframe = _obj_0.is_a_vector3, _obj_0.is_a_cframe
end
local getCharacter
do
  local _obj_0 = require("API")
  getCharacter = _obj_0.getCharacter
end
local Pathfinder
do
  local _base_0 = {
    Traverse = function(self, char_)
      if (not self.char) then
        self.char = getCharacter(char_)
      end
      local i = 1
      for _, point in pairs(self.path) do
        print("Moving @char to " .. (tostring2(point)) .. ".")
        char.Humanoid:moveTo(point)
        while (point - player.Character.Torso.Position).magnitude > 3 do
          wait()
        end
        i = i + 1
        if math.random() >= .875 then
          if (point == self.path[self.path_:CheckOcclusionAsync()]) and (path_:CheckOcclusionAsync() == i) then
            self.path_ = (game:GetService("PathfindingService")):ComputeRawPathAsync(point, self.path[-1], (point - self.path[-1]).magntiude * (2048 % (point - self.path[-1]).magnitude))
            self.path = self.path_:GetPointCoordinates()
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, startPath, endPoint, char_)
      if (type(startPath)) == "table" then
        if (type(endPoint)) == "table" then
          self.path_ = (game:GetService("PathfindingService")):ComputeRawPathAsync(startPath[1], endPoint[-1], (startPath[1] - endPoint[-1]).magntiude * (2048 % (startPoint[1] - endPoint[-1]).magnitude))
          self.path = self.path_:GetPointCoordinates()
          self.char = getCharacter(char_)
        else
          self.path = startPath
        end
      elseif (is_a_vector3(startPath)) then
        if (is_a_vector3(endPoint)) then
          self.path_ = (game:GetService("PathfindingService")):ComputeRawPathAsync(startPath, endPoint, (startPath - endPoint).magnitude * (2048 % (startPath - endPoint).magnitude))
          self.path = self.path_:GetPointCoordinates()
        elseif (is_a_cframe(endPoint)) then
          endPoint = Vector3.new(endPoint.x, endPoint.y, endPoint.z)
          self.path_ = (game:GetService("PathfindingService")):ComputeRawPathAsync(startPath, endPoint, (startPath - endPoint).magnitude * (2048 % (startPath - endPoint).magnitude))
          self.path = self.path_:GetPointCoordinates()
        end
      elseif (is_a_cframe(startPath)) then
        if (is_a_cframe(endPoint)) then
          local strt = Vector3.new(startPath.x, startPath.y, startPath.z)
          local endP = Vector3.new(endPoint.x, endPoint.y, endPoint.z)
          self.path_ = (game:GetService("PathfindingService")):ComputeRawPathAsync(strt, endP, (strt - endP).magnitude * (2048 % (strt - endP).magnitude))
          self.path = self.path_:GetPointCoordinates()
        elseif (is_a_vector3(endPoint)) then
          local strtP = Vector3.new(startPath.x, startPath.y, startPath.z)
          self.path_ = (game:GetService("PathfindingService")):ComputeRawPathAsync(strtP, endPoint, (strtP - endPoint).magntiude * (2048 % (strtP - endPoint).magnitude))
          self.path = self.path_:GetPointCoordinates()
        elseif (is_a_table(endPoint)) then
          self.path_ = (game:GetService("PathfindingService")):ComputeRawPathAsync((Vector3.new(startPath.x, startPath.y, startPath.z)), endPoint[-1], (startPath - endPoint).magntiude * (2048 % (startPath - endPoint).magnitude))
          self.path = self.path_:GetPointCoordinates()
          for i, v in pairs(self.path) do
            if (not is_a_vector3(v)) then
              self.path[i] = pcall(toVector3, v)
            end
          end
        end
      end
    end,
    __base = _base_0,
    __name = "Pathfinder"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Pathfinder = _class_0
end
return Pathfinder
