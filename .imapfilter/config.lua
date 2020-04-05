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
  local cmd ='/home/punchagan/bin/imap-pass get ' .. repository .. ' ' .. username
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

-- Jobs
local jobs = account.INBOX:contain_to('punchagan+jobs@muse-amuse.in')
jobs:move_messages(account["Jobs"])

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
local py_del = account.INBOX:contain_from('@pydelhi.org')
py_del:move_messages(account["PyConIN"])

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
  account.INBOX:contain_from('edx.org') +
  account.INBOX:contain_from('information@gandi.net') +
  account.INBOX:contain_from('info@makersasylum.com') +
  account.INBOX:contain_from('trello.com') +
  account.INBOX:contain_from('change.org') +
  account.INBOX:contain_from('vimeo.com') +
  account.INBOX:contain_from('berkeley.edu') +
  account.INBOX:contain_from('stanford.edu') +
  account.INBOX:contain_from('kaggle.com') +
  account.INBOX:contain_from('safaribooksonline.com') +
  account.INBOX:contain_from('quantifiedcode')

junk:move_messages(account["Junk"])

-- Spam
local spam = account.INBOX:contain_body('If you no longer wish to receive mail from this sender') +
  account.INBOX:contain_from('events@qz.com') +
  ((account.INBOX:contain_body('deals') + account.INBOX:contain_body('sale'))
      * account.INBOX:contain_body('unsubscribe')) +
  account.INBOX:contain_from('etailingindia') +
  account.INBOX:contain_from('@localcirclesemail.com') +
  account.INBOX:contain_from('@hcc.commnet.edu') +
  account.INBOX:contain_from('@jobreferrals.in') +
  account.INBOX:contain_from('@youth4work.in') +
  account.INBOX:contain_from('directconnect.in') +
  account.INBOX:contain_body('to opt out') +
  account.INBOX:contain_body('Million Dollars') +
  account.INBOX:contain_body('PROMOTIONAL SMS')


spam:move_messages(account["Trash"])

-- UPAI
local upai = account.INBOX:contain_to('admin@indiaultimate.org')
upai:move_messages(account["UPAI"])

local upai = account.INBOX:contain_cc('admin@indiaultimate.org')
upai:move_messages(account["UPAI"])

local upai = account.INBOX:contain_bcc('admin@indiaultimate.org')
upai:move_messages(account["UPAI"])
