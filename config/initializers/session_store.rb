# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
# ActionController::Base.session = {
#   :key         => '_cmdb_session',
#   :secret      => 'c66cf1edf392cf9370d6c7cf74b97b885fb289a4fdd842a629884dd04a904271cec86db53e7079970396f636fb2eba5bcd9c12633cd599795b8a04ca62ca3e5c'
# }

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
