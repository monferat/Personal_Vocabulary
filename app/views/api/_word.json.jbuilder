json.name user_word.word.name
json.extract! user_word, :transcription, :translation, :associate, :phrase
json.theme user_word.word.theme.name
json.image user_word.image.url
json.user user_word.user.login
