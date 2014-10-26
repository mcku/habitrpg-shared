_ = require 'lodash'
fs = require 'fs'
path = require 'path'
translations = {}

localePath = path.join(__dirname, "../locales/")
# copied from habitrpg/src/i18n.js
loadTranslations= (locale) ->
  files = fs.readdirSync(path.join(localePath, locale));
  translations[locale] = {};
  _.each files, (file) ->
    # console.log "i18n.coffee file: " + file
    if path.extname(file) != '.json' 
      return
    _.merge(translations[locale], require(path.join(localePath, locale, file)));
  

loadTranslations('en');
loadTranslations('tr');
loadTranslations('de');
loadTranslations('fr');

module.exports = 
  strings: null, # Strings for one single language
  translations: translations # Strings for multiple languages {en: strings, de: strings, ...}
  t: (stringName) -> # Other parameters allowed are vars (Object) and locale (String)
    vars = arguments[1]

    if _.isString(arguments[1])
      vars = null
      locale = arguments[1]
    else if arguments[2]?
      vars = arguments[1]
      locale = arguments[2]

    locale = 'en' if (!locale? or (!module.exports.strings and !module.exports.translations[locale]))
    string = if (!module.exports.strings) then module.exports.translations[locale][stringName] else module.exports.strings[stringName]
    console.log "locale: " + locale + " string " + string
    if string
      try
        _.template(string, (vars or {}))
      catch e
        'Error processing string. Please report to http://github.com/HabitRPG/habitrpg.'
    else
      stringNotFound = if (!module.exports.strings) then module.exports.translations[locale].stringNotFound else module.exports.strings.stringNotFound
      try
        _.template(stringNotFound, {string: stringName})
      catch e
        'Error processing string. Please report to http://github.com/HabitRPG/habitrpg.'