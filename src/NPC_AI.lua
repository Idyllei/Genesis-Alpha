local NPCPlayer=require("NPCPlayer");
local NPCChar=game:GetService("ServerStorage"):findFirstChild("NPCChar"):Clone();

-- towns[name][1->N]=Vector3<EndPoint>
local towns={["volcano"]={},["void"]={},["aether"]={},["chthonic"]={},["palace"]={}};

