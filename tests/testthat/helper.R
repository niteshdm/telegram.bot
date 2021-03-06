
# You must define a valid TOKEN in Travis Environment Variables Settings
# NOTE: https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings
token <- Sys.getenv('TOKEN')

# Check if the token is valid, otherwise set a default token
# NOTE: This will skip the connection tests, as this token is not valid
res <- try(Bot(token = token))
if (inherits(res, 'try-error') && attr(t, 'condition')$message == "invalid token.")
  token <- "123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"

# Skip if it is run offline or the bot request is not valid
skip_if_offline <- function(bot){
  
  res <- try(bot$getMe())
  
  if (inherits(res, 'try-error'))
    skip(attr(res, 'condition')$message)
  else if (inherits(res, 'response') && res$status_code != 200)
    skip('Bad request.')
}

# Handler function
foo_handler <- function(bot, update, ...){return(update)}

# Foo update
foo_update <- list(update_id = 0,
                   message = list(from_user = 'Tester',
                                  chat = list(id = 123456789),
                                  text = '/foo bar'))
# Foo callbackquery
foo_callbackquery <- list(update_id = 1,
                          callback_query = list(data = 'foo'))

# Foo bot and foo updater
# NOTE: Only used for start_polling testing, as the bot features are tested in other contexts
foo_bot <- list(
  clean_updates = function(...){}
)
class(foo_bot) <- 'Bot'

foo_updater <- Updater(bot = foo_bot)

stop_handler <- function(...){foo_updater$stop_polling()}
