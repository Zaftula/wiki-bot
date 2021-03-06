# Description:
#   Email from hubot to all_support
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot status <message> - Sends email with the <subject> <message> to address <user@email.com>
#
# Author:
#   jacobmovingfwd
#
# Additional Requirements
#   unix mail client installed on the system

util = require 'util'
http = require 'http'
nodemailer = require 'nodemailer'

# create reusable transport method (opens pool of SMTP connections)
smtpTransport = nodemailer.createTransport("SMTP",
  service: "SendGrid"
  auth:
    user: "wikibot"
    pass: "UUY64uFX4n(^VM@Gssjn"
)




module.exports = (robot) ->
  emailTime = null
  sendEmail = (msg, from) ->
    # setup e-mail data with unicode symbols
    mailOptions =
      from: "#{from} <alert@sendgrid.com>" # sender address
      to: "jacob@sendgrid.com" # list of receivers
      subject: "SendGrid Status Alert" # Subject line
      generateTextFromHTML: true
      html: "#{msg}" # html body

    smtpTransport.sendMail mailOptions, (error,response) ->
      if error
        console.log error
      else
        console.log "Message sent: " + response.message

  robot.respond /smtp (.*)/i, (msg) ->
    console.log msg.message
    sendEmail msg.match[1], msg.message.user.name
    msg.send "Status emailed. (fuckyeah)"
