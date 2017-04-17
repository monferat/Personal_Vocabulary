json.name user_word.word.name
json.extract! user_word, :transcription, :translation, :associate, :phrase, :share, :learned
json.theme user_word.word.theme.name
json.image user_word.image.url
