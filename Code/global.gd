extends Node

const water_types = [Vector2i(5,0),Vector2i(6,0)]

var avg_item_vals = {"Whale":1000,"Turtle":100,"Citrus":20,"Coffee":30,"Gems":200}

# Example trade deal: {"AskedItem1":["Silk",2],"AskedItem2":["Coffee",1],"ReturnItem":["Gold",10],"Stock":3}
class Trader:
	var trade_deals = []
	func are_items_tradeable(Inventory:Dictionary) -> bool: #returns if trading is possible
		for n : Dictionary in trade_deals:
			if n["Stock"] > 0:
				if Inventory.get(n["AskedItem1"][0],-1) > n["AskedItem1"][1]:
					if n.has("AskedItem2"):
						if Inventory.get(n["AskedItem2"][0],-1) > n["AskedItem2"][1]:
							return true
					else:
						return true
		return false
	func trade(trade_id:int):
		trade_deals[trade_id]["Stock"] -= 1
	
