local function capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

local function get_password(repository, username)
  local cmd ='/usr/bin/python /home/punchagan/.offlineimap.py --get ' .. repository .. ' ' .. username
  local password = capture(cmd)
  return password
end

local username = 'punchagan'
local account = IMAP {
    server = 'muse-amuse.in',
    username = 'punchagan',
    password = get_password('remote-muse-amuse', username),
    ssl = 'starttls',
}

-- Options

-- options.create = true
options.subscribe = true

-- Search and Filter!

-- Cron daemon and other system mailers.
local results = account.INBOX:contain_from('root@muse-amuse.in')
results:move_messages(account["maint"])

-- GitHub notifications
local gh = account.INBOX:contain_from('notifications@github.com')

-- (org2blog)
local o2b = gh * account.INBOX:contain_to('org2blog')
o2b:move_messages(account["org2blog"])

-- (nikola)
local nikola = gh * account.INBOX:contain_to('nikola')
nikola:move_messages(account["Nikola"])
local nikola_discuss = account.INBOX:contain_to('nikola-discuss@googlegroups.com')
nikola_discuss:move_messages(account["Nikola"])

-- (blaggregator)
local blaggregator = gh * account.INBOX:contain_to('blaggregator') +
  account.INBOX:contain_body('blaggregator')
blaggregator:move_messages(account["Blaggregator"])

-- (everything else)
local keras = gh * account.INBOX:contain_to('keras')
keras:move_messages(account["GitHub"])

gh = account.INBOX:contain_from('notifications@github.com')
gh:move_messages(account["GitHub"])

-- Lafoots
local lafoots = account.INBOX:contain_to('lafoots-252@googlegroups.com') +
  account.INBOX:contain_from('park@muse-amuse.in')
lafoots:move_messages(account["Lafoots"])

-- News/To-Read
local news = account.INBOX:contain_from('noreply@medium.com') +
  account.INBOX:contain_from('hi@qz.com') +
  account.INBOX:contain_from('support@instapaper.com')
news:move_messages(account["News"])

-- HackerSchool
local rc = account.INBOX:contain_subject('[community - ')
rc:move_messages(account["HackerSchool"])

-- Bitbucket
local bb = account.INBOX:contain_from('notifications-noreply@bitbucket.org')
bb:move_messages(account["Bitbucket"])

-- PyCon IN
local py_in = account.INBOX:contain_from('@pssi.org.in')
py_in:move_messages(account["PyConIN"])

-- Junk
local junk = account.INBOX:contain_from('noreply@coursera.org') +
  account.INBOX:contain_from('nanowrimo.org') +
  account.INBOX:contain_from('gun.io') +
  account.INBOX:contain_from('info@twitter.com') +
  account.INBOX:contain_from('notify@twitter.com') +
  account.INBOX:contain_from('info@e.twitter.com') +
  account.INBOX:contain_from('iglaw.com') +
  account.INBOX:contain_from('@ello.co') +
  account.INBOX:contain_from('noreply@github.com') +
  account.INBOX:contain_from('news@edx.org') +
  account.INBOX:contain_from('information@gandi.net') +
  account.INBOX:contain_from('info@makersasylum.com') +
  account.INBOX:contain_from('trello.com') +
  account.INBOX:contain_from('change.org')

junk:move_messages(account["Junk"])

-- Spam
local spam = account.INBOX:contain_body('If you no longer wish to receive mail from this sender') +
  account.INBOX:contain_from('events@qz.com') +
  ((account.INBOX:contain_body('deals') + account.INBOX:contain_body('sale'))
      * account.INBOX:contain_body('unsubscribe')) +
  account.INBOX:contain_from('@etailingindiaexpo')


spam:move_messages(account["Trash"])
