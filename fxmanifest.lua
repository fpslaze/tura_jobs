fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author '@tura'
description 'jobback'
lua54 'yes'

shared_script {
    'config.lua',
    'languages/translation.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

-- version must match version.file
version '0.0.1'
vorp_checker 'yes'
-- can use color codes ^1
vorp_name '^5tura_jobs ^4version Check^3'
-- path to the github repository, in here it must have a version.file file type where your change logs will be, also must be public repository
vorp_github 'https://github.com/fpslaze/tura_jobs'
