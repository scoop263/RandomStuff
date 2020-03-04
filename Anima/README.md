# Anima
A Repo Directory Containing an Anima Character Creation

Made by: scoop263

Contact:

	Discord: scoop263#2890
	Reddit: u/scoop263
	Email: scoop263@yahoo.com
		(I dont use this much, Discord or Reddit is best way to get answer within the next 12 hours.)


Why did I make this?

My friends play Anima, I don't. Plus I want to see what random
bad combiniations you could get. 

What doesn't this script do?

It does not:

	Decide which Advantages/Disadvantages
		Why?
			Because it is too difficult

	LP Multiples
		Why?
			Because I didnt implement it in my first revision.
			It will come eventually

	Ki Techniques
		Why?
			Too difficult, and I dont understand it at all.
	
	Doesn't Add up a final value for each stat.
		Why?
			This is meant to generate each value at random and you
			transfer it to a character sheet, you might have additional
			values to add to it.

FAQ's

In this portion I will answer general questions one might have.

	My level is Level 4 and not 1, why?
		Character levels are chosen at random.
			LV1 =  50% Chance
			LV2 =  30% Chance
			LV3 =  10% Chance
			LV4 =   5% Chance
			LV5 = 2.5% Chance
			LV6 =   1% Chance
			LV7 = 0.5% Chance
			LV8 = 0.3% Chance
			LV9 = 0.2% Chance
		      LV10 = 0.18% Chance
		      LV11 = 0.15% Chance
		      LV12 = 0.08% Chance
		      LV13 = 0.05% Chance
		      LV14 = 0.03% Chance
		      LV15 = 0.01% Chance
		Lets get real this is a Gacha Machine

	How do I change where it saves?
		In the Properties folder, there is a 
		.txt file called "FileSpecs" and you
		may change it. Inside it is a location you want to specify it.

	How can I make more character sheets at a single time?
		In the Properties folder, there is a 
		.txt file called "FileSpecs" and you
		may change it. Inside it on the second line you may put how many times it
		runs.
	
	Can I place my character sheets somewhere else, other than CharacterSheets?
		As it stands, no. 
		Needs to be in that directory.

	I havent messed with any files, in properties, or the script itself, but it doesnt work.
		Sometimes Windows prevents you from running scripts, to protect you.
		In Windows Search bar type "Powershell" right-click and Run as Administrator.
		Enter the following:

			Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
			
	In the above FAQ you told me how to get the script to work, how do I undo it?
		Same method in opening Powershell but instead use this following line:

			Set-ExecutionPolicy -ExecutionPolicy Default

	I have allowed scripts to run, however it still wont work, help!
		Make sure you right click the file "AnimaRandomizer" and click run with Powershell
		If the problem still exists then check the FileSpecs.txt file to make sure it is correct.
		
		File Contents look like this:
			Filename: .\CharacterSheets\Example.txt
			Make X Files: 1

	Why is there no class "Freelancer"?
		When making the first revisions I concluded that it would be to difficult.
	
	You say that Freelancer is too difficult, why?
		I have to randomly select it's bonus's why every other class has a specific set of bonus's
		Currently how the script works, It just wont work.

	I want my Freelancer.
		Not a question but a statement, but look it will get there eventually, or not.

	What is the lowest Characteristic Value I can get?
		The lowest that the initial value will get, without modifying it is 4

	You just said my Characteristic Values could only get as low as 4, but im getting 2 and 3's.
		Because of race of the character Values may get as low as 2 and 3, Just got bad luck,
		run it again.
	
	My values are above 10, how did it do that?
		So going based off my DM's method, Values can exceed 10 if all other characteristics
		above a certain criteria. This happens if you recieve a level of 2+, where
		a "Characteristic+" point is given to increase a value. To replicate this I do something
		like this.

			To go from 10 to 11, all other values need to be 5
			To go from 11 to 12, all other values need to be 6
			etc.

	My Values are Exceeding 10 even though I have a 2,3, or 4 value for my Characteristics, why?
		Your chosen race will only be that affecting factor, thats why.

	I want my character to have a number between 1 - 10, not 4 - 10, how can I change this?
		You can't, unless you will take my work and modify it on your own.
	
	How are the Development Points distributed?
		Depending on your Archetype, a percent is given to each sub category:
			Combat
			Supernatural
			Psychic
			Secondary
		If you are a paladin then your percentage is something like this
			98% of getting a +1 point in a Combat ability.
			10% of getting a +1 point in a Supernatural Ability.
			etc
		Then each time it gets a point the percentage goes down by 1.
	
	Can I change these percentages?
		Yea sure go into the script and find the Pecent portion in the baseCalc function.
	
	I dont like Ki in my character builds, but I keep getting Ki, why does your script suck?
		Currently Ki is grouped in with Combat, In future iterations I will give Ki
		its own rate. 

	I know Powershell, and would like to give you my feedback, how?
		Contact me.
	
	You didn't answer any of my questions how do I get them answered?
		Contact me.