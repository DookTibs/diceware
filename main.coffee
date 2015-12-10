crypto = require('crypto')
http = require('http')
fs = require('fs')

wlRemoteLoc = "http://world.std.com/~reinhold/diceware.wordlist.asc"
wlFilename = "diceware.wordlist"

random = (howMany, chars) ->
  if (chars == undefined)
    chars = "123456"

  rnd = crypto.randomBytes(howMany)
  val = new Array(howMany)
  len = chars.length

  for i in [0..howMany-1]
    val[i] = chars[rnd[i] % len]

  return val.join('')

loadWordList = (callback) ->
  fileExistsLocally = false
  try
    stats = fs.statSync(wlFilename)
    if (stats.isFile())
      fileExistsLocally = true
  catch error
    # console.log("ERROR [" + error + "] statsync")

  if (fileExistsLocally)
    console.log("Reading wordlist from local file...")
    data = fs.readFileSync(wlFilename, {"encoding": "UTF-8"})
    callback(data)
  else
    console.log("Fetching wordlist from '" + wlRemoteLoc + "'...")
    http.get(wlRemoteLoc, ((res) ->
      data = ""
      res.on('data', ((chunk) ->
        data += chunk
      ))
      res.on('end', ((chunk) ->
        fs.writeFileSync(wlFilename, data)
        callback(data)
      ))
    )).on("error", (() ->
      callback(null)
    ))

loadWords = (data) ->
  console.log("parsing wordlist...")
  chunks = data.split("\n")

  words = {}

  pips = "[123456]"
  re = new RegExp("^" + pips + pips + pips + pips + pips + "\t")
  for c, i in chunks
    if re.test(c)
      codeAndWord = c.split("\t")
      words[codeAndWord[0]] = codeAndWord[1]

  return words


# main
numWordsInPassphrase = 5
if (process.argv.length >= 3)
  numWordsInPassphrase = parseInt(process.argv[2])

keys = []
if (process.argv.length == 3 + numWordsInPassphrase)
  console.log("Building a diceware passphrase using supplied lookups.")
  # you have specified the dicerolls on the command line
  for i in [3..process.argv.length-1]
    keys[i-3] = process.argv[i]
else
  console.log("Randomly generating a diceware passphrase with " + numWordsInPassphrase + " words.")
  
loadWordList((data) ->
  if (data == null)
    console.log("An error occurred while fetching the wordlist.")
  else
    # console.log(data.substring(0, 200))
    words = loadWords(data)
    
    console.log("Generating passphrase...")
    passphrase = ""
    for i in [1..numWordsInPassphrase]
      if (keys.length > 0)
        key = keys[i-1]
      else
        key = random(5)
      word = words[key]
      passphrase += (if passphrase == "" then "" else " ") + word

    console.log("Generated passphrase is: [" + passphrase + "]")
)


###
console.log("random 5: [" + random(5) + "]")
console.log("random 5: [" + random(5) + "]")
console.log("random 5: [" + random(5) + "]")
console.log("random 5: [" + random(5) + "]")
console.log("random 5: [" + random(5) + "]")
###
