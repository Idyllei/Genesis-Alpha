--[[

  LuaCrypt Library v0.5
  
  Exported hash functions:
    crypt.md5     MD5
    crypt.crc32   CRC32 (IEEE 802.3)
    crypt.sha1      SHA-1
    crypt.sha1_binary
    crypt.sha224    SHA-224
    crypt.sha256    SHA-256

  Sample hash function usage:
      local crypt=require("crypt");
      print(crypt.sha256("abc"));
      

  Please send a PM to 
      if you discover any bugs or errors.
]]

local crypt={};

crypt.crc32=require("crc32");
crypt.sha1=require("sha1");
crypt.sha1_binary=require("sha1");
crypt.sha224=require("sha2");
crypt.sha256=require("sha2");
crypt.md5=require("md5");

return crypt;