-- Test the actual server branch with a fake teleport and an atomic in-memory commit.
local source=game.ServerScriptService.DessertGame.Source
local a=assert(source:find('if verb=="IdleRejoin" then',1,true))
local b=assert(source:find('if verb=="RedeemCode" then',a,true))
local branch=source:sub(a,b-1)
local now=2000;local studio=false;local failSave=false;local failTeleport=false
local commits,teleports,destroyed=0,0,0
local fakeGame={PrivateServerId="",JobId="QA-public-server",PlaceId=98510499854486}
function fakeGame:GetService(name)
 assert(name=="TeleportService")
 return {TeleportAsync=function(_,place,players,options)
  assert(place==fakeGame.PlaceId and options.ServerInstanceId==fakeGame.JobId)
  assert(commits>0 and destroyed==2,'Persist and collect drops before teleport')
  teleports+=1;if failTeleport then error('Network unavailable') end
 end}
end
local fn=assert(loadstring('return function(player,p,s) local verb="IdleRejoin";'..branch..' end'))
setfenv(fn,setmetatable({game=fakeGame,os={clock=function() return now end},Config={IdleRejoinSeconds=1080},
 Run={IsStudio=function() return studio end},Profiles={Mutate=function(p,mutate)
  if failSave then return false end
  local trial=table.clone(p.Data);assert(mutate(trial));p.Data=trial;commits+=1;return true
 end}},{__index=getfenv()}))
local run=fn();local player={Kick=function() error('Unexpected kick') end}
local p={LastActivity=0,Data={AFKStored=1}}
local s={Drops={{Value=2,Model={Destroy=function() destroyed+=1 end}},{Value=3,Model={Destroy=function() destroyed+=1 end}}}}
studio=true;assert(not run(player,p,s) and commits==0);studio=false
p.LastActivity=now;assert(not run(player,p,s) and commits==0);p.LastActivity=0
fakeGame.PrivateServerId='private';assert(not run(player,p,s) and commits==0);fakeGame.PrivateServerId=''
failSave=true;assert(not run(player,p,s) and teleports==0 and destroyed==0);failSave=false
now+=30;failTeleport=true;assert(not run(player,p,s));assert(p.Data.AFKStored==6 and #s.Drops==0 and teleports==1)
assert(not run(player,p,s) and teleports==1,'Throttle duplicate reconnect')
now+=30;failTeleport=false;assert(run(player,p,s));assert(p.Data.AFKStored==6 and teleports==2,'Retry never duplicates saved drops')
print('[IdleRejoin] PASS: idle/public/Studio guards, save-before-transfer, failure preserves drops, throttling, exact-once retry')
