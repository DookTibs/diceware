Simple script that generates Diceware (http://world.std.com/~reinhold/diceware.html) 
passphrases.

Requirements:
* Coffeescript

Usage:
coffee main.coffee <numWordsInPassphrase>
Randomly generates dice rolls and a passphrase with specified number of words. Arg defaults to 5.

coffee main.coffee <numWordsInPassphrase> <diceroll> <diceroll> ...
Allows you to supply the dicerolls yourself, in case you prefer to use a different random number
generation method (like rolling actual dice).
Ex: "coffee main.coffee 2 12345 62431" will give you "apathy urge" every time you run it.

I make no claims as to the cryptographic security of this software. I've attempted to 
use good random number generation but use at your own risk.
