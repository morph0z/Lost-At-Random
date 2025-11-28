class_name rarity
@export var usedRarity:Rarities = Rarities.COMMON

##Values are all in percentages out of %100
enum Rarities{
	COMMON = 60, ##Most common rarity
	UNCOMMON = 19, ##Less most common rarity
	RARE = 7, ##RAREity
	GALACTIC = 5, ##Epic rarity stand in
	UNIVERSAL = 2, ##Legendary rarity stand in
	
	RANDOM = 3, ##Wild card (maybe godtier, maybe crap)
	
	PARADOXICAL = 4 ##Cursed rarity (good thing with a downside or catch)
}
