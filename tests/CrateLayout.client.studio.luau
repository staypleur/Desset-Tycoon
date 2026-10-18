-- Play client with Crates open; no payments or production writes.
local gui=game.Players.LocalPlayer.PlayerGui
local choices=assert(gui:FindFirstChild("CrateChoices",true));task.wait(.2)
local n,p=choices.NormalCrateChoice,choices.PerkCrateChoice
assert(n.AbsolutePosition.Y==p.AbsolutePosition.Y)
local center=choices.AbsolutePosition.X+choices.AbsoluteSize.X/2
assert(math.abs((n.AbsolutePosition.X+n.AbsoluteSize.X/2+p.AbsolutePosition.X+p.AbsoluteSize.X/2)/2-center)<2)
for _,card in {n,p} do
 local a,b=card.Open1,card.Open10
 assert(a.AbsolutePosition.Y==b.AbsolutePosition.Y and a.AbsolutePosition.X<b.AbsolutePosition.X)
 assert(card.DetailsButton.Text=="View Odds" and card.DetailsButton.AbsolutePosition.Y>a.AbsolutePosition.Y)
 assert(a:GetAttribute("Quantity")==1 and b:GetAttribute("Quantity")==10)
 for _,t in card:GetDescendants() do if t:IsA("TextLabel") or t:IsA("TextButton") then
  assert(not t.Text:find("%%") and not t.Text:lower():find("shard"),"Main cards must stay simple")
 end end
end
assert(not gui:FindFirstChild("OpenShardExchange",true))
print("[CrateLayout] PASS: centered compact picture/open cards, quantities, separate View Odds, no inline probabilities or shard UI")
